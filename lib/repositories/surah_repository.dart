import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:quran/models/surah_detail_model.dart';
import 'package:quran/models/surah_model.dart';

class SurahRepository {
  Future<List<SurahModel>> getAll() async {
    try {
      final data = await rootBundle.loadString('assets/data/surah.json');

      final surah = SurahModel.toLists(json.decode(data));
      return surah;
    } catch (e) {
      return [];
    }
  }

  Future<SurahDetailModel> getById(int id) async {
    try {
      final data = await rootBundle
          .loadString('assets/data/surah-details/surah-$id.json');

      final surah = SurahDetailModel.fromJson(json.decode(data));

      return surah;
    } catch (e) {
      throw Exception('Error when get surah by id');
    }
  }
}
