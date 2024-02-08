import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:quran/providers/startup_provider.dart';
import 'package:quran/utils/font_styles.dart';
import 'package:quran/utils/theme_color.dart';

class StartupPage extends StatefulWidget {
  const StartupPage({super.key});

  @override
  State<StartupPage> createState() => _StartupPageState();
}

class _StartupPageState extends State<StartupPage> {
  bool _loading = false;

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
                          child: Consumer(
                            builder: (context, ref, child) {
                              return SizedBox(
                                width: 200,
                                height: 55,
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
                                  child: !_loading
                                      ? Text(
                                          'Get Started',
                                          style: FontStyles.regular.copyWith(
                                            fontSize: 18,
                                            color: ThemeColor.background,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        )
                                      : const SizedBox(
                                          width: 23,
                                          height: 23,
                                          child: CircularProgressIndicator(
                                            color: ThemeColor.background,
                                          ),
                                        ),
                                  onPressed: () {
                                    if (_loading) return;
                                    setState(() {
                                      _loading = true;
                                    });
                                    ref
                                        .read(startupNotifierProvider.notifier)
                                        .updateStartup()
                                        .then((_) => context.go('/home'));
                                  },
                                ),
                              );
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
