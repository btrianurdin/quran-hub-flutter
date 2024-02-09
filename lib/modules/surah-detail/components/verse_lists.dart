import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:quran/models/bookmark_model.dart';
import 'package:quran/models/last_read_model.dart';
import 'package:quran/models/quran_audio_model.dart';
import 'package:quran/models/verse_model.dart';
import 'package:quran/providers/audio_provider.dart';
import 'package:quran/providers/bookmark_provider.dart';
import 'package:quran/providers/last_read_provider.dart';
import 'package:quran/utils/font_styles.dart';
import 'package:quran/utils/theme_color.dart';
import 'package:share_plus/share_plus.dart';
import 'package:visibility_detector/visibility_detector.dart';

class VerseLists extends ConsumerWidget {
  const VerseLists({
    required this.surahId,
    required this.surahName,
    required this.verse,
    required this.bookmark,
    required this.isLastItem,
    super.key,
  });

  final int surahId;
  final String surahName;
  final VerseModel verse;
  final BookmarkModel bookmark;
  final bool isLastItem;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    log('cek => bookmarks:');

    return SizedBox(
      width: double.infinity,
      child: VisibilityDetector(
        key: Key('verse-${verse.numberOfVerse}'),
        onVisibilityChanged: (visibilityInfo) {
          if (visibilityInfo.visibleFraction == 1) {
            ref.read(updateLastReadProvider(
              LastReadModel(
                surahName: surahName,
                numberOfVerse: verse.numberOfVerse,
              ),
            ));
          }
        },
        child: Column(
          children: [
            Container(
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
                  // Number Box
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
                      Row(
                        children: [
                          IconButton(
                            color: ThemeColor.primary,
                            onPressed: () {
                              ref.read(playAudioProvider(
                                QuranAudioModel(
                                  id: surahId,
                                  surahName: surahName,
                                  currentNumber: verse.numberOfVerse,
                                ),
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
                              if (bookmark.bookmarkId != -1) {
                                ref.read(removeBookmarkProvider(
                                  bookmark.bookmarkId,
                                ));
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
                              bookmark.bookmarkId != -1
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: ThemeColor.primary,
                              size: 24,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 4),
                      IconButton(
                        color: ThemeColor.primary,
                        onPressed: () async {
                          try {
                            await Share.share(
                              'Surah $surahName Ayat ${verse.numberOfVerse}\n\n${verse.arabicText}\n\n${verse.translationText}\n\nQuran App ~',
                            );
                          } catch (e) {
                            Fluttertoast.showToast(msg: 'Error: $e');
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
            ),
            const SizedBox(height: 30),
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.only(
                bottom: 16,
              ),
              decoration: BoxDecoration(
                border: !isLastItem
                    ? const Border(
                        bottom: BorderSide(
                          color: ThemeColor.surface,
                          width: 2,
                        ),
                      )
                    : null,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    verse.arabicText,
                    style: FontStyles.arabic.copyWith(
                      fontSize: 28,
                      height: 2,
                    ),
                    textAlign: TextAlign.right,
                    textDirection: TextDirection.rtl,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    verse.translationText,
                    style: FontStyles.regular.copyWith(
                      fontSize: 14,
                      color: ThemeColor.textPrimary,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.left,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
