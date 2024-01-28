class LastReadModel {
  final String surahName;
  final int numberOfVerse;

  LastReadModel({
    required this.surahName,
    required this.numberOfVerse,
  });

  factory LastReadModel.fromJson(Map<String, dynamic> json) {
    return LastReadModel(
      surahName: json['surahName'],
      numberOfVerse: json['numberOfVerse'],
    );
  }

  static toJson(LastReadModel lastRead) {
    return {
      'surahName': lastRead.surahName,
      'numberOfVerse': lastRead.numberOfVerse,
    };
  }
}
