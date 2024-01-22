import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:quran/utils/theme_color.dart';

class ScreenLayout extends StatelessWidget {
  const ScreenLayout({required this.shellNavigator, Key? key})
      : super(
            key: key ?? const ValueKey<String>('ScaffoldBottomNavigationBar'));

  final StatefulNavigationShell shellNavigator;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColor.background,
      extendBody: true,
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          highlightColor: ThemeColor.background.withOpacity(0.5),
          splashFactory: NoSplash.splashFactory,
        ),
        child: BottomNavigationBar(
          backgroundColor: ThemeColor.surface,
          type: BottomNavigationBarType.fixed,
          currentIndex: shellNavigator.currentIndex,
          onTap: (int idx) {
            shellNavigator.goBranch(idx, initialLocation: idx == 0);
          },
          elevation: 0.0,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          items: [
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                'assets/icons/quran.svg',
                theme: SvgTheme(
                  currentColor: isActiveItem(shellNavigator.currentIndex, 0),
                ),
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                'assets/icons/light.svg',
                theme: SvgTheme(
                  currentColor: isActiveItem(shellNavigator.currentIndex, 1),
                ),
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                'assets/icons/prayer.svg',
                theme: SvgTheme(
                  currentColor: isActiveItem(shellNavigator.currentIndex, 2),
                ),
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                'assets/icons/bookmark.svg',
                theme: SvgTheme(
                  currentColor: isActiveItem(shellNavigator.currentIndex, 3),
                ),
              ),
              label: 'Home',
            ),
          ],
        ),
      ),
      body: shellNavigator,
    );
  }

  Color isActiveItem(int currentIdx, int itemIdx) {
    return currentIdx == itemIdx ? ThemeColor.primary : ThemeColor.secondary;
  }
}
