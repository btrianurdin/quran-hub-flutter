import 'package:quran/models/quran_audio_model.dart';

class PlayerStateModel {
  final QuranAudioModel? data;
  final int? surahId;
  final String? surahName;
  final List<String>? sources;
  final int? prevNumber;
  final int? currentNumber;
  final int? nextNumber;
  final bool isPlaying;
  final bool isShowPlayer;
  final Duration? duration;
  final Duration? position;
  final double? percentage;

  PlayerStateModel({
    this.data,
    this.surahId,
    this.surahName,
    this.sources,
    this.prevNumber,
    this.currentNumber,
    this.nextNumber,
    required this.isPlaying,
    required this.isShowPlayer,
    this.duration,
    this.position,
    this.percentage,
  });

  PlayerStateModel copyWith({
    QuranAudioModel? data,
    int? surahId,
    String? surahName,
    List<String>? sources,
    int? prevNumber,
    int? currentNumber,
    int? nextNumber,
    bool? isPlaying,
    bool? isShowPlayer,
    Duration? duration,
    Duration? position,
    double? percentage,
  }) {
    return PlayerStateModel(
      data: data ?? this.data,
      surahId: surahId ?? this.surahId,
      surahName: surahName ?? this.surahName,
      sources: sources ?? this.sources,
      prevNumber: prevNumber ?? this.prevNumber,
      currentNumber: currentNumber ?? this.currentNumber,
      nextNumber: nextNumber ?? this.nextNumber,
      isPlaying: isPlaying ?? this.isPlaying,
      isShowPlayer: isShowPlayer ?? this.isShowPlayer,
      duration: duration ?? this.duration,
      position: position ?? this.position,
      percentage: percentage ?? this.percentage,
    );
  }
}
