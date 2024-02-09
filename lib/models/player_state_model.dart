import 'package:quran/models/quran_audio_model.dart';

class PlayerStateModel {
  final QuranAudioModel? data;
  final int? surahId;
  final String? surahName;
  final List<String> sources;
  final int totalNumber;
  final int currentNumber;
  final bool isPlaying;
  final bool isShowPlayer;
  final Duration? duration;
  final Duration? position;
  final double? percentage;
  final bool? isLoading;

  PlayerStateModel({
    this.data,
    required this.totalNumber,
    this.surahId,
    this.surahName,
    required this.sources,
    required this.currentNumber,
    required this.isPlaying,
    required this.isShowPlayer,
    this.duration,
    this.position,
    this.percentage,
    this.isLoading,
  });

  PlayerStateModel copyWith({
    QuranAudioModel? data,
    int? totalNumber,
    int? surahId,
    String? surahName,
    List<String>? sources,
    int? currentNumber,
    bool? isPlaying,
    bool? isShowPlayer,
    Duration? duration,
    Duration? position,
    double? percentage,
    bool? isLoading,
  }) {
    return PlayerStateModel(
      data: data ?? this.data,
      totalNumber: totalNumber ?? this.totalNumber,
      surahId: surahId ?? this.surahId,
      surahName: surahName ?? this.surahName,
      sources: sources ?? this.sources,
      currentNumber: currentNumber ?? this.currentNumber,
      isPlaying: isPlaying ?? this.isPlaying,
      isShowPlayer: isShowPlayer ?? this.isShowPlayer,
      duration: duration ?? this.duration,
      position: position ?? this.position,
      percentage: percentage ?? this.percentage,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
