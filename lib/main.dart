import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quran/providers/startup_provider.dart';
import 'package:quran/services/storage/hive_storage.dart';
import 'package:quran/utils/font_styles.dart';
import 'package:quran/utils/routes.dart';
import 'package:quran/utils/theme_color.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final HiveStorage hiveStorage = HiveStorage();
  await hiveStorage.init();

  // hiveStorage.clear();

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

    return Consumer(
      builder: (context, ref, child) {
        final startup = ref.watch(startupProvider);

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
          builder: (context, child) {
            if (startup == null) return _buildLoading();

            return child!;
          },
          routerConfig: Routes.init(startup: startup),
        );
      },
    );
  }

  Widget _buildLoading() {
    return Scaffold(
      backgroundColor: ThemeColor.background,
      body: Center(
        child: Stack(
          children: [
            Center(
              child: SizedBox(
                width: 150,
                height: 150,
                child: Image.asset('assets/images/splash.png'),
              ),
            ),
            Positioned(
              bottom: 30,
              left: 0,
              right: 0,
              child: Center(
                child: Column(
                  children: [
                    Text(
                      'Quran Hub',
                      style: FontStyles.regular.copyWith(fontSize: 16),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'version 1.2.0',
                      style: FontStyles.regular
                          .copyWith(fontSize: 10, color: ThemeColor.secondary),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
