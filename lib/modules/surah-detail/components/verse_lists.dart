import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quran/models/bookmark_model.dart';
import 'package:quran/models/last_read_model.dart';
import 'package:quran/modules/surah-detail/components/verse_number_box.dart';
import 'package:quran/providers/bookmark_provider.dart';
import 'package:quran/providers/last_read_provider.dart';
import 'package:quran/providers/surah_provider.dart';
import 'package:quran/utils/font_styles.dart';
import 'package:quran/utils/theme_color.dart';
import 'package:visibility_detector/visibility_detector.dart';

class VerseLists extends ConsumerWidget {
  const VerseLists({required this.surahId, required this.surahName, super.key});

  final int surahId;
  final String surahName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final verses = ref.watch(versesProvider(surahId));
    final bookmarks = ref.watch(selectBookmarkProvider(surahId));

    return SizedBox(
      width: double.infinity,
      child: verses.when(
        data: (data) {
          return ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              final verse = data[index];
              BookmarkModel bookmark = bookmarks.firstWhere((element) {
                return element.numberOfVerse == verse.numberOfVerse;
              }, orElse: () {
                return BookmarkModel(bookmarkId: -1);
              });

              return VisibilityDetector(
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
                    VerseNumberBox(
                      surahId: surahId,
                      surahName: surahName,
                      verse: verse,
                      isBookmarked: bookmark.bookmarkId != -1,
                      bookmarkId: bookmark.bookmarkId,
                    ),
                    const SizedBox(height: 30),
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(bottom: 16),
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
              );
            },
            separatorBuilder: (context, index) {
              return const Divider(
                height: 1,
                color: Color.fromRGBO(135, 137, 163, .40),
              );
            },
            itemCount: data.length,
          );
        },
        error: (error, stackTrace) {
          return Center(
            child: Text('Error: $error'),
          );
        },
        loading: () {
          return Container(
            padding: const EdgeInsets.symmetric(vertical: 30),
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        },
      ),
    );
  }
}
