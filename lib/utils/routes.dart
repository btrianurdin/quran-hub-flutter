import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:quran/modules/bookmark/bookmark_page.dart';
import 'package:quran/modules/home/home_page.dart';
import 'package:quran/modules/startup/startup_page.dart';
import 'package:quran/modules/surah-detail/surah_detail_page.dart';
import 'package:quran/providers/startup_provider.dart';
import 'package:quran/shared/audio_player_box.dart';
import 'package:quran/shared/shell_route_layout.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final routerProvider = Provider<GoRouter>((ref) {
  final startup = ref.watch(startupProvider);

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/intro',
    redirect: (context, state) {
      if (startup == null) return null;
      if (startup && state.matchedLocation == '/intro') return '/home';
      if (!startup) return '/intro';
      return null;
    },
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
});
