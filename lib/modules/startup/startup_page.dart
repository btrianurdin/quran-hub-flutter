import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:quran/utils/font_styles.dart';
import 'package:quran/utils/theme_color.dart';

class StartupPage extends StatelessWidget {
  const StartupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColor.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Quran App',
                    style: FontStyles.title,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Learn Quran and\n Recite once everyday',
                    style: FontStyles.regular.copyWith(
                      color: ThemeColor.secondary,
                      fontSize: 18,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Column(
                        children: [
                          SvgPicture.asset(
                            'assets/images/startup.svg',
                            width: MediaQuery.of(context).size.width,
                          ),
                          const SizedBox(height: 30)
                        ],
                      ),
                      Positioned(
                        bottom: 25,
                        left: 0,
                        right: 0,
                        child: Center(
                          child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                ThemeColor.accent,
                              ),
                              padding: MaterialStateProperty.resolveWith(
                                (states) => const EdgeInsets.symmetric(
                                  horizontal: 40,
                                  vertical: 16,
                                ),
                              ),
                            ),
                            child: Text(
                              'Get Started',
                              style: FontStyles.regular.copyWith(
                                fontSize: 18,
                                color: ThemeColor.background,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            onPressed: () {
                              Future.microtask(() => context.go('/home'));
                            },
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
