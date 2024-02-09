import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quran/extension/cache_for.dart';
import 'package:quran/models/surah_model.dart';
import 'package:quran/models/verse_model.dart';
import 'package:quran/repositories/surah_repository.dart';

final surahProvider = FutureProvider<List<SurahModel>>((ref) {
  return ref.watch(surahRepositoryProvider).getAll();
});

final surahDetailProvider = FutureProvider.family<SurahModel, int>(
  (ref, surahId) async {
    final surah = await ref.watch(surahProvider.future);
    return surah.firstWhere((element) => element.id == surahId);
  },
);

final versesProvider = FutureProvider.family.autoDispose<List<VerseModel>, int>(
  (ref, surahId) async {
    ref.cacheFor(const Duration(minutes: 5));
    final details = await ref.watch(surahRepositoryProvider).getById(surahId);
    return details.verses;
  },
);
