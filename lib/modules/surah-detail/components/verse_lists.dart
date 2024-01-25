import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quran/providers/surah_provider.dart';
import 'package:quran/utils/font_styles.dart';
import 'package:quran/utils/theme_color.dart';
import 'package:share_plus/share_plus.dart';

class VerseLists extends ConsumerWidget {
  const VerseLists({required this.surahId, required this.surahName, super.key});

  final int surahId;
  final String surahName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final verses = ref.watch(versesProvider(surahId));

    return SizedBox(
      width: double.infinity,
      child: verses.when(
        data: (data) {
          return ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return Column(
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
                              data[index].numberOfVerse.toString(),
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
                                    'Surah $surahName Ayat ${data[index].numberOfVerse}\n\n${data[index].arabicText}\n\n${data[index].translationText}\n\nQuran App ~',
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
                            IconButton(
                              color: ThemeColor.primary,
                              onPressed: () {},
                              icon: const Icon(
                                Icons.favorite_border,
                                color: ThemeColor.primary,
                                size: 24,
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(bottom: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          data[index].arabicText,
                          style: FontStyles.arabic.copyWith(
                            fontSize: 28,
                            height: 2,
                          ),
                          textAlign: TextAlign.right,
                          textDirection: TextDirection.rtl,
                        ),
                        const SizedBox(height: 20),
                        Text(
                          data[index].translationText,
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
