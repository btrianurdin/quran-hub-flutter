import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quran/models/surah_detail_model.dart';
import 'package:quran/models/surah_model.dart';
import 'package:quran/repositories/surah_repository.dart';

class SurahNotifier extends StateNotifier<List<SurahModel>> {
  final SurahRepository _surahRepository = SurahRepository();

  SurahNotifier({
    required SurahRepository repository,
  }) : super([]);

  Future<List<SurahModel>> getAll() async {
    return await _surahRepository.getAll();
  }

  Future<SurahDetailModel> getById(int id) async {
    return await _surahRepository.getById(id);
  }
}

final surahRepositoryProvider =
    StateNotifierProvider<SurahNotifier, List<SurahModel>>((ref) {
  return SurahNotifier(repository: SurahRepository());
});

final surahProvider = FutureProvider<List<SurahModel>>((ref) async {
  final surah = await ref.watch(surahRepositoryProvider.notifier).getAll();
  return surah;
});

final surahDetailProvider =
    FutureProvider.family<SurahDetailModel, int>((ref, id) async {
  final surah = await ref.watch(surahRepositoryProvider.notifier).getById(id);
  return surah;
});
