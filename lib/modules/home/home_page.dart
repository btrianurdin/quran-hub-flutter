import 'package:flutter/material.dart';
import 'package:quran/modules/home/components/surah_tab.dart';
import 'package:quran/modules/home/components/tab_view_container.dart';
import 'package:quran/utils/font_styles.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    print('home render');
    return TabViewContainer(
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
}
