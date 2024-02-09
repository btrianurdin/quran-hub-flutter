import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quran/services/storage/hive_storage.dart';

class StartupNotifier extends StateNotifier<bool?> {
  final HiveStorage hiveStorage;

  StartupNotifier(this.hiveStorage) : super(null) {
    init();
  }

  Future<void> init() async {
    final isStartup = await hiveStorage.get('is_startup');
    await Future.delayed(const Duration(seconds: 1));
    if (isStartup == null) {
      state = false;
    } else {
      state = true;
    }
  }

  Future<void> updateStartup() async {
    await hiveStorage.put('is_startup', true);
    await Future.delayed(const Duration(seconds: 2));
    state = true;
  }
}

final startupNotifierProvider =
    StateNotifierProvider<StartupNotifier, bool?>((ref) {
  final storage = ref.watch(hiveStorageProvider);
  return StartupNotifier(storage);
});

final startupProvider = Provider<bool?>((ref) {
  return ref.watch(startupNotifierProvider);
});