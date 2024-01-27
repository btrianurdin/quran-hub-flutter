import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quran/models/surah_model.dart';
import 'package:quran/models/verse_model.dart';
import 'package:quran/repositories/surah_repository.dart';

class SurahNotifier extends StateNotifier<List<SurahModel>> {
  final SurahRepository _surahRepository = SurahRepository();

  SurahNotifier({
    required SurahRepository repository,
  }) : super([]);

  Future<List<SurahModel>> getAll() async {
    // added to prevent blocking UI
    await Future.delayed(const Duration(milliseconds: 300));

    return await _surahRepository.getAll();
  }

  Future<SurahModel> getOne(int surahId) async {
    final surah = await _surahRepository.getAll();

    return surah.firstWhere((data) => data.id == surahId);
  }

  Future<List<VerseModel>> getVerses(int surahId) async {
    // added to prevent blocking UI
    await Future.delayed(const Duration(milliseconds: 300));

    final verses = await _surahRepository.getById(surahId);

    return verses.verses;
  }

  Future<List<SurahModel>> getFiltered(String query) async {
    final surah = await _surahRepository.getAll();

    return surah.where((element) {
      return element.latinName.toLowerCase().contains(query.toLowerCase());
    }).toList();
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

final surahDetailProvider = FutureProvider.family<SurahModel, int>(
  (ref, surahId) async {
    final surah =
        await ref.watch(surahRepositoryProvider.notifier).getOne(surahId);

    return surah;
  },
);

final versesProvider = FutureProvider.family.autoDispose<List<VerseModel>, int>(
  (ref, surahId) async {
    final verses =
        await ref.watch(surahRepositoryProvider.notifier).getVerses(surahId);

    return verses;
  },
);

final searchTextSurahProvider = StateProvider<String>((ref) {
  return '';
});


final searchSurahProvider = FutureProvider<List<SurahModel>>((ref) async {
  final query = ref.watch(searchTextSurahProvider);

  if (query.isEmpty) {
    return [];
  }

  final lists = await ref.watch(surahProvider.future);
  await Future.delayed(const Duration(milliseconds: 100));
  return lists.where((element) {
    return element.latinName.toLowerCase().contains(query.toLowerCase());
  }).toList();
});
