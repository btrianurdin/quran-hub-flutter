class SurahModel {
  final int? id;
  final String arabicName;
  final String latinName;
  final int verseCount;
  final String relativationType;
  final String meaning;
  final String description;

  SurahModel({
    required this.id,
    required this.arabicName,
    required this.latinName,
    required this.verseCount,
    required this.relativationType,
    required this.meaning,
    required this.description,
  });

  factory SurahModel.fromJson(Map<String, dynamic> json) {
    return SurahModel(
      id: json['nomor'],
      arabicName: json['nama'],
      latinName: json['namaLatin'],
      verseCount: json['jumlahAyat'],
      relativationType: json['tempatTurun'],
      meaning: json['arti'],
      description: json['deksripsi'] ?? '',
    );
  }

  static List<SurahModel> toLists(List<dynamic> data) {
    return data.map((e) => SurahModel.fromJson(e)).toList();
  }
}
