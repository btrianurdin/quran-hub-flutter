import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:quran/modules/bookmark/bookmark_page.dart';
import 'package:quran/modules/home/home_page.dart';
import 'package:quran/modules/startup/startup_page.dart';
import 'package:quran/modules/surah-detail/surah_detail_page.dart';
import 'package:quran/shared/audio_player_box.dart';
import 'package:quran/shared/shell_route_layout.dart';

class Routes {
  static final GlobalKey<NavigatorState> _rootNavigatorKey =
      GlobalKey<NavigatorState>();
  static final GlobalKey<NavigatorState> _shellNavigatorKey =
      GlobalKey<NavigatorState>();

  static final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/intro',
    routes: <RouteBase>[
      GoRoute(
        path: '/intro',
        builder: (context, state) => const StartupPage(),
      ),
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) => ShellRouteLayout(
          audioPlayer: const AudioPlayerBox(),
          child: child,
        ),
        routes: [
          GoRoute(
            parentNavigatorKey: _shellNavigatorKey,
            path: '/home',
            builder: (context, state) => const HomePage(),
          ),
          GoRoute(
            parentNavigatorKey: _shellNavigatorKey,
            path: '/surah/:id',
            builder: (context, GoRouterState state) {
              final id = int.parse(state.pathParameters['id'] ?? '1');
              var extra = state.extra as Map<String, dynamic>? ?? {};

              return SurahDetailPage(
                  surahId: id, surahName: extra['surahName']);
            },
          ),
          GoRoute(
            parentNavigatorKey: _shellNavigatorKey,
            path: '/bookmarks',
            pageBuilder: (context, state) {
              const begin = Offset(0.0, 0.7);
              const end = Offset.zero;
              const curve = Curves.easeInOut;

              final tween = Tween(begin: begin, end: end).chain(
                CurveTween(curve: curve),
              );

              return CustomTransitionPage(
                child: const BookmarkPage(),
                transitionDuration: const Duration(milliseconds: 200),
                reverseTransitionDuration: const Duration(milliseconds: 200),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  return SlideTransition(
                    position: animation.drive(tween),
                    child: child,
                  );
                },
              );
            },
            builder: (context, state) => const BookmarkPage(),
          ),
        ],
      ),
    ],
  );
}
