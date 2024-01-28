import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quran/models/last_read_model.dart';
import 'package:quran/services/storage/hive_storage.dart';
import 'package:quran/services/storage/storage_service.dart';

class LastReadNotifier extends StateNotifier<LastReadModel> {
  final LocalStorageService _storage;

  LastReadNotifier(
    this._storage,
  ) : super(LastReadModel(surahName: '', numberOfVerse: 0)) {
    getLastRead();
  }

  Future<LastReadModel> getLastRead() async {
    final data = await _storage.get('last_read');

    if (data != null) {
      final lastRead = LastReadModel.fromJson(jsonDecode(data));
      state = lastRead;

      return state;
    }

    return LastReadModel(surahName: '', numberOfVerse: 0);
  }

  Future<void> setLastRead(LastReadModel lastRead) async {
    await _storage.put('last_read', jsonEncode(LastReadModel.toJson(lastRead)));

    state = lastRead;
  }
}

final lastReadRepositoryProvider =
    StateNotifierProvider<LastReadNotifier, LastReadModel>((ref) {
  return LastReadNotifier(ref.watch(hiveStorageProvider));
});

final updateLastReadProvider = Provider.family((ref, LastReadModel newRead) {
  final last = ref.watch(lastReadRepositoryProvider);

  if (newRead.numberOfVerse == last.numberOfVerse &&
      newRead.surahName == last.surahName) return null;
  return ref.watch(lastReadRepositoryProvider.notifier).setLastRead(newRead);
});

final lastReadProvider = Provider((ref) {
  return ref.watch(lastReadRepositoryProvider);
});
