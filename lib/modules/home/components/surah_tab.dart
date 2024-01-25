import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:quran/providers/surah_provider.dart';
import 'package:quran/utils/font_styles.dart';
import 'package:quran/utils/theme_color.dart';

class SurahTab extends ConsumerWidget {
  const SurahTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final surah = ref.watch(surahProvider);

    return surah.when(
      data: (data) {
        return ListView.separated(
          separatorBuilder: (context, index) {
            return const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Divider(
                height: 1,
                color: Color.fromRGBO(135, 137, 163, .40),
              ),
            );
          },
          itemCount: data.length,
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemBuilder: (context, index) {
            final current = data[index];

            return InkWell(
              overlayColor: MaterialStateProperty.all(ThemeColor.surface),
              splashFactory: InkSplash.splashFactory,
              onTap: () => {
                context.push('/surah/${current.id}')
              },
              child: Container(
                padding: const EdgeInsets.all(18),
                margin: const EdgeInsets.all(0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Stack(
                      children: [
                        SvgPicture.asset('assets/images/verse-number.svg'),
                        Positioned(
                          top: 8,
                          left: 0,
                          right: 0,
                          child: Center(
                            child: Text(
                              current.id.toString(),
                              style: FontStyles.regular.copyWith(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          current.latinName,
                          style: FontStyles.regular
                              .copyWith(fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Text(
                              current.relativationType.toUpperCase(),
                              style: FontStyles.regular.copyWith(
                                fontSize: 12,
                                color: ThemeColor.secondary,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '•',
                              style: FontStyles.regular.copyWith(
                                fontSize: 12,
                                color: ThemeColor.secondary,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${current.verseCount} Verses'.toUpperCase(),
                              style: FontStyles.regular.copyWith(
                                fontSize: 12,
                                color: ThemeColor.secondary,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                    const Spacer(),
                    Text(
                      current.arabicName,
                      style: FontStyles.arabic.copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: ThemeColor.primary,
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        );
      },
      error: (error, stackTrace) {
        return Center(
          child: Text(
            'Error, please try again later',
            style: FontStyles.regular,
          ),
        );
      },
      loading: () {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
