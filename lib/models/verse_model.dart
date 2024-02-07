class VerseModel {
  final int numberOfVerse;
  final String arabicText;
  final String latinText;
  final String translationText;
  final String audio;

  VerseModel({
    required this.numberOfVerse,
    required this.arabicText,
    required this.latinText,
    required this.translationText,
    required this.audio,
  });

  factory VerseModel.fromJson(Map<String, dynamic> json) {
    return VerseModel(
      numberOfVerse: json['nomorAyat'],
      arabicText: json['teksArab'],
      latinText: json['teksLatin'],
      translationText: json['teksIndonesia'],
      audio: json['audio']['05'],
    );
  }

  static List<VerseModel> toLists(List<dynamic> data) {
    return data.map((e) => VerseModel.fromJson(e)).toList();
  }
}