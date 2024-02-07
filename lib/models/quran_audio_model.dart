class QuranAudioModel {
  final int id;
  final String url;
  final String surahName;
  final int numberOfVerse;

  QuranAudioModel({
    required this.id,
    required this.url,
    required this.surahName,
    required this.numberOfVerse,
  });

  factory QuranAudioModel.fromJson(Map<String, dynamic> json) {
    return QuranAudioModel(
      id: json['nomor'],
      url: json['ayat']['audio']['05'],
      surahName: json['namaLatin'],
      numberOfVerse: json['ayat']['nomorAyat'],
    );
  }
}

// class QuranAudioVerseModel {
//   final int id;
//   final String url;
//   final String surahName;
//   final String numberOfVerse;

//   QuranAudioVerseModel({
//     required this.id,
//     required this.url,
//     required this.surahName,
//     required this.numberOfVerse,
//   });

//   factory QuranAudioVerseModel.fromJson(Map<String, dynamic> json) {
//     return QuranAudioVerseModel(
//       id: json['nomor'],
//       url: json['ayat']['audio']['05'],
//       surahName: json['namaLatin'],
//       numberOfVerse: json['ayat']['nomorAyat'],
//     );
//   }
// }
