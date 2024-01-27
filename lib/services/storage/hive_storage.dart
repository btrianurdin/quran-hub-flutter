import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:quran/services/storage/storage_service.dart';

class HiveStorage extends LocalStorageService {
  final String _storageKey = "QURAN";
  late Box<dynamic> _box;

  Future<void> init() async {
    await Hive.initFlutter();
    _box = await Hive.openBox(_storageKey);
  }

  @override
  Future<void> put(String key, dynamic value) async {
    await _box.put(key, value);
  }

  @override
  Future<dynamic> get(String key) async {
    return await _box.get(key);
  }

  @override
  Future<void> delete(String key) async {
    await _box.delete(key);
  }

  @override
  Future<void> clear() async {
    await _box.clear();
  }
}

final hiveStorageProvider = Provider<HiveStorage>((ref) {
  return HiveStorage();
});
