import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:quran/modules/bookmark/bookmark_page.dart';
import 'package:quran/modules/home/home_page.dart';
import 'package:quran/modules/startup/startup_page.dart';
import 'package:quran/modules/surah-detail/surah_detail_page.dart';

class Routes {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static final GoRouter router = GoRouter(
    initialLocation: '/intro',
    routes: <RouteBase>[
      GoRoute(
        path: '/intro',
        builder: (context, state) => const StartupPage(),
      ),
      GoRoute(path: '/home', builder: (context, state) => const HomePage()),
      GoRoute(
        path: '/surah/:id',
        builder: (context, GoRouterState state) {
          final id = int.parse(state.pathParameters['id'] ?? '1');

          return SurahDetailPage(surahId: id);
        },
      ),
      GoRoute(
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
  );
}
