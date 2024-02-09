import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quran/models/surah_model.dart';
import 'package:quran/providers/surah_provider.dart';

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
