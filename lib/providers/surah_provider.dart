import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quran/models/surah_detail_model.dart';
import 'package:quran/models/surah_model.dart';
import 'package:quran/models/verse_model.dart';
import 'package:quran/repositories/surah_repository.dart';

class SurahNotifier extends StateNotifier<List<SurahModel>> {
  final SurahRepository _surahRepository = SurahRepository();

  SurahNotifier({
    required SurahRepository repository,
  }) : super([]);

  Future<List<SurahModel>> getAll() async {
    return await _surahRepository.getAll();
  }

  Future<SurahModel> getOne(int surahId) async {
    final surah = await _surahRepository.getAll();

    return surah.firstWhere((data) => data.id == surahId);
  }

  Future<List<VerseModel>> getVerses(int surahId) async {
    final verses = await _surahRepository.getById(surahId);

    return verses.verses;
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
    FutureProvider.family<SurahModel, int>((ref, surahId) async {
  final surah = await ref.watch(surahRepositoryProvider.notifier).getOne(surahId);

  return surah;
});

final versesProvider =
    FutureProvider.family<List<VerseModel>, int>((ref, surahId) async {
  final verses =
      await ref.watch(surahRepositoryProvider.notifier).getVerses(surahId);

  return verses;
});
