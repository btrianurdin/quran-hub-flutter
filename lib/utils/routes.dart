import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
    ],
  );
}
