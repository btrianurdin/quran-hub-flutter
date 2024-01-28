import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quran/services/storage/hive_storage.dart';
import 'package:quran/utils/routes.dart';
import 'package:quran/utils/theme_color.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final HiveStorage hiveStorage = HiveStorage();
  await hiveStorage.init();

  runApp(
    ProviderScope(
      overrides: [
        hiveStorageProvider.overrideWithValue(hiveStorage),
      ],
      child: const AppMain(),
    ),
  );
}

class AppMain extends StatelessWidget {
  const AppMain({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: ThemeColor.background,
      ),
    );

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        pageTransitionsTheme: const PageTransitionsTheme(builders: {
          TargetPlatform.android: CupertinoPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder()
        }),
      ),
      routerConfig: Routes.router,
    );
  }
}
