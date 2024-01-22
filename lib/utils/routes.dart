import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:quran/modules/bookmark/bookmark_page.dart';
import 'package:quran/modules/home/home_page.dart';
import 'package:quran/modules/insight/insight_page.dart';
import 'package:quran/modules/short-prayer/short_prayer_page.dart';
import 'package:quran/modules/startup/startup_page.dart';
import 'package:quran/screen.dart';

class Routes {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();
  final GlobalKey<NavigatorState> shellNavigatorKey =
      GlobalKey<NavigatorState>();

  static final GoRouter router = GoRouter(
    initialLocation: '/intro',
    routes: <RouteBase>[
      GoRoute(
        path: '/intro',
        builder: (context, state) => const StartupPage(),
      ),
      GoRoute(path: '/home', builder: (context, state) => const HomePage()),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return ScreenLayout(
            shellNavigator: navigationShell,
          );
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/home',
                builder: (context, state) => const HomePage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/insight',
                builder: (context, state) => const InsightPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/shortprayer',
                builder: (context, state) => const ShortPrayerPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/bookmark',
                builder: (context, state) => const BookmarkPage(),
              ),
            ],
          ),
        ],
      )
    ],
  );
}
