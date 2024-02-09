import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quran/providers/bookmark_provider.dart';
import 'package:quran/shared/single_scrolling_layout.dart';
import 'package:quran/utils/font_styles.dart';
import 'package:quran/utils/theme_color.dart';
import 'package:share_plus/share_plus.dart';

class BookmarkPage extends StatelessWidget {
  const BookmarkPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleScrollingLayout(
      appBarTitle: 'Bookmarks',
      slivers: [
        Consumer(
          builder: (context, ref, child) {
            final bookmarks = ref.watch(bookmarkProviderGrouped);

            if (bookmarks.isEmpty) {
              return SliverToBoxAdapter(
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 30),
                  child: Center(
                    child: Text(
                      'No bookmarks yet.',
                      style: FontStyles.regular.copyWith(
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              );
            }

            return SliverList.separated(
              itemBuilder: (context, index) {
                return Container(
                  padding: const EdgeInsets.symmetric(vertical: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        bookmarks[index].key,
                        style: FontStyles.regular.copyWith(
                            fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                      Column(
                        children: bookmarks[index].value.map((bookmark) {
                          return Container(
                            padding: const EdgeInsets.only(top: 30),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: ThemeColor.surface,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 2,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        width: 27,
                                        height: 27,
                                        margin: const EdgeInsets.only(left: 14),
                                        decoration: BoxDecoration(
                                          color: ThemeColor.primary,
                                          borderRadius:
                                              BorderRadius.circular(50),
                                        ),
                                        child: Center(
                                          child: Text(
                                            bookmark.numberOfVerse.toString(),
                                            style: FontStyles.regular.copyWith(
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          IconButton(
                                            color: ThemeColor.primary,
                                            onPressed: () async {
                                              try {
                                                await Share.share(
                                                  'Surah ${bookmarks[index].key} Ayat ${bookmark.numberOfVerse}\n\n${bookmark.arabicText}\n\n${bookmark.translationText}\n\nQuran App ~',
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
                                          const SizedBox(width: 4),
                                          Consumer(
                                              builder: (context, ref, child) {
                                            return IconButton(
                                              color: ThemeColor.primary,
                                              onPressed: () {
                                                ref.read(removeBookmarkProvider(
                                                  bookmark.bookmarkId,
                                                ));
                                              },
                                              icon: const Icon(
                                                Icons.favorite,
                                                color: ThemeColor.primary,
                                                size: 24,
                                              ),
                                            );
                                          }),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 30),
                                Text(
                                  bookmark.arabicText!,
                                  style: FontStyles.arabic.copyWith(
                                    fontSize: 28,
                                    height: 2,
                                  ),
                                  textAlign: TextAlign.right,
                                  textDirection: TextDirection.rtl,
                                ),
                                const SizedBox(height: 20),
                                Text(
                                  bookmark.translationText!,
                                  style: FontStyles.regular.copyWith(
                                    fontSize: 14,
                                    color: ThemeColor.textPrimary,
                                    height: 1.5,
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                );
              },
              itemCount: bookmarks.length,
              separatorBuilder: (context, index) {
                return const Divider(
                  color: ThemeColor.surface,
                  height: 2,
                );
              },
            );
          },
        )
      ],
    );
  }
}
