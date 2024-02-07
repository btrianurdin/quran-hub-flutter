import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:quran/modules/home/components/search_box.dart';
import 'package:quran/modules/home/components/surah_tab.dart';
import 'package:quran/modules/home/components/tab_view_container.dart';
import 'package:quran/providers/last_read_provider.dart';
import 'package:quran/utils/font_styles.dart';
import 'package:quran/utils/theme_color.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    log('home render');
    return TabViewContainer(
      adapterBox: SliverToBoxAdapter(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              Text(
                'Assalamualaikum',
                style: FontStyles.regular.copyWith(
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 18),
              const SearchBox(),
              const SizedBox(height: 24),
              Stack(
                children: [
                  _lastReadView(),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: SvgPicture.asset('assets/images/home-quran.svg'),
                  )
                ],
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
      views: [
        const SurahTab(),
        Center(
          child: Text(
            'Juz',
            style: FontStyles.regular.copyWith(
              fontSize: 24,
            ),
          ),
        ),
      ],
    );
  }

  Widget _lastReadView() {
    return Consumer(
      builder: (context, ref, child) {
        final lastRead = ref.watch(lastReadRepositoryProvider);

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: ThemeColor.accent,
            borderRadius: BorderRadius.circular(10),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              stops: [0.0, 1.0],
              colors: [Color(0xFFDF98FA), Color(0xFF9055FF)],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Last Read',
                style: FontStyles.regular.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                lastRead.surahName.isNotEmpty ? lastRead.surahName : '-',
                style: FontStyles.title.copyWith(fontSize: 18),
              ),
              const SizedBox(height: 4),
              Text(
                'Ayah No. ${lastRead.numberOfVerse == 0 ? '-' : lastRead.numberOfVerse}',
                style: FontStyles.regular.copyWith(fontSize: 14),
              ),
            ],
          ),
        );
      },
    );
  }
}
