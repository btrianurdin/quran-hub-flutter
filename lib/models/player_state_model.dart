import 'package:quran/models/quran_audio_model.dart';

class PlayerStateModel {
  final QuranAudioModel? data;
  final bool isPlaying;
  final bool isShowPlayer;
  final Duration? duration;
  final Duration? position;
  final double? percentage;

  PlayerStateModel({
    this.data,
    required this.isPlaying,
    required this.isShowPlayer,
    this.duration,
    this.position,
    this.percentage,
  });

  PlayerStateModel copyWith({
    QuranAudioModel? data,
    bool? isPlaying,
    bool? isShowPlayer,
    Duration? duration,
    Duration? position,
    double? percentage,
  }) {
    return PlayerStateModel(
      data: data ?? this.data,
      isPlaying: isPlaying ?? this.isPlaying,
      isShowPlayer: isShowPlayer ?? this.isShowPlayer,
      duration: duration ?? this.duration,
      position: position ?? this.position,
      percentage: percentage ?? this.percentage,
    );
  }
}
