import 'package:quran/models/surah_model.dart';
import 'package:quran/models/verse_model.dart';

class SurahDetailModel {
  final SurahModel detail;
  final List<VerseModel> verses;

  SurahDetailModel({
    required this.detail,
    required this.verses,
  });

  factory SurahDetailModel.fromJson(Map<String, dynamic> json) {
    return SurahDetailModel(
      detail: SurahModel(
        id: json['nomor'],
        arabicName: json['nama'],
        latinName: json['namaLatin'],
        verseCount: json['jumlahAyat'],
        relativationType: json['tempatTurun'],
        meaning: json['arti'],
        description: json['deksripsi'] ?? '',
      ),
      verses: VerseModel.toLists(json['ayat']),
    );
  }
}
