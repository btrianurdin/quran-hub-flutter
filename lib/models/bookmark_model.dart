import 'dart:convert';

class BookmarkModel {
  int bookmarkId;
  int? surahId;
  String? surahName;
  int? numberOfVerse;
  String? arabicText;
  String? latinText;
  String? translationText;

  BookmarkModel({
    required this.bookmarkId,
    this.surahId,
    this.surahName,
    this.numberOfVerse,
    this.arabicText,
    this.latinText,
    this.translationText,
  });

  factory BookmarkModel.fromJson(Map<String, dynamic> json) {
    return BookmarkModel(
      bookmarkId: json['bookmarkId'],
      surahId: json['surahId'],
      surahName: json['surahName'],
      numberOfVerse: json['numberOfVerse'],
      arabicText: json['arabicText'],
      latinText: json['latinText'],
      translationText: json['translationText'],
    );
  }

  static toList(List<dynamic> data) {
    return data.map((e) => BookmarkModel.fromJson(e)).toList();
  }

  static toJson(List<BookmarkModel> data) {
    return json.encode(data
        .map((e) => {
              'bookmarkId': e.bookmarkId,
              'surahId': e.surahId,
              'surahName': e.surahName,
              'numberOfVerse': e.numberOfVerse,
              'arabicText': e.arabicText,
              'latinText': e.latinText,
              'translationText': e.translationText,
            })
        .toList());
  }
}
