import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quran/models/bookmark_model.dart';
import 'package:quran/models/quran_audio_model.dart';
import 'package:quran/models/verse_model.dart';
import 'package:quran/providers/audio_provider.dart';
import 'package:quran/providers/bookmark_provider.dart';
import 'package:quran/utils/font_styles.dart';
import 'package:quran/utils/theme_color.dart';
import 'package:share_plus/share_plus.dart';

class VerseNumberBox extends StatelessWidget {
  const VerseNumberBox({
    required this.surahId,
    required this.surahName,
    required this.verse,
    required this.isBookmarked,
    required this.bookmarkId,
    super.key,
  });

  final int surahId;
  final String surahName;
  final VerseModel verse;
  final int bookmarkId;
  final bool isBookmarked;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: ThemeColor.surface,
        borderRadius: BorderRadius.circular(10),
      ),
      margin: const EdgeInsets.only(top: 24),
      padding: const EdgeInsets.symmetric(
        horizontal: 2,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 27,
            height: 27,
            margin: const EdgeInsets.only(left: 14),
            decoration: BoxDecoration(
              color: ThemeColor.primary,
              borderRadius: BorderRadius.circular(50),
            ),
            child: Center(
              child: Text(
                verse.numberOfVerse.toString(),
                style: FontStyles.regular.copyWith(
                  fontSize: 14,
                ),
              ),
            ),
          ),
          Row(
            children: [
              Consumer(builder: (context, ref, child) {
                return Row(
                  children: [
                    IconButton(
                      color: ThemeColor.primary,
                      onPressed: () {
                        ref
                            .read(playerStateProvider.notifier)
                            .loaded(QuranAudioModel(
                              id: surahId,
                              url: verse.audio,
                              surahName: surahName,
                              numberOfVerse: verse.numberOfVerse,
                            ));
                      },
                      padding: const EdgeInsets.all(0),
                      icon: const Icon(
                        CupertinoIcons.play_arrow_solid,
                        color: ThemeColor.primary,
                        size: 26,
                      ),
                    ),
                    const SizedBox(width: 4),
                    IconButton(
                      color: ThemeColor.primary,
                      onPressed: () {
                        if (isBookmarked) {
                          ref.read(removeBookmarkProvider(bookmarkId));
                        } else {
                          ref.read(addBookmarkProvider(
                            BookmarkModel(
                              bookmarkId: UniqueKey().hashCode,
                              surahId: surahId,
                              surahName: surahName,
                              numberOfVerse: verse.numberOfVerse,
                              arabicText: verse.arabicText,
                              latinText: verse.latinText,
                              translationText: verse.translationText,
                            ),
                          ));
                        }
                      },
                      icon: Icon(
                        isBookmarked ? Icons.favorite : Icons.favorite_border,
                        color: ThemeColor.primary,
                        size: 24,
                      ),
                    ),
                  ],
                );
              }),
              const SizedBox(width: 4),
              IconButton(
                color: ThemeColor.primary,
                onPressed: () async {
                  try {
                    await Share.share(
                      'Surah $surahName Ayat ${verse.numberOfVerse}\n\n${verse.arabicText}\n\n${verse.translationText}\n\nQuran App ~',
                    );
                  } catch (e) {
                    print('Error: $e');
                  }
                },
                icon: const Icon(
                  Icons.share_outlined,
                  color: ThemeColor.primary,
                  size: 24,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
