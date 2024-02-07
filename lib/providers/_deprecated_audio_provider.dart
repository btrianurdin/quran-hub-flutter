import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:quran/models/quran_audio_model.dart';

class PlayerNotifier extends ChangeNotifier {
  final AudioPlayer _player = AudioPlayer();
  QuranAudioModel? _audioData;
  Duration _duration = const Duration();
  Duration _position = const Duration();
  double _percentage = 0;
  bool _isPlayerShow = false;

  QuranAudioModel? get audioData => _audioData;
  Duration get duration => _duration;
  Duration get position => _position;
  double get percentage => _percentage;
  bool get isPlaying => _player.playing;
  bool get isPlayerShow => _isPlayerShow;

  void loaded(QuranAudioModel audio) {
    log('CEK --> LOADED ${_player.audioSource}');
    _audioData = audio;
    _player.setUrl(audio.url).then((value) {
      log('CEK --> SET URL ${_player.audioSource}');
      _isPlayerShow = true;
      _player.play();
      _progress();
    });
  }

  void _progress() {
    _player.durationStream.listen((event) {
      log('CEK --> DURATION $event');
      if (event != null) {
        _duration = event;
      }
    });
    _player.playerStateStream.listen((event) {
      log('CEK --> STATE $event');
      if (event.processingState == ProcessingState.completed) {
        _player.stop();
      }
    });
    _player.positionStream.listen((event) {
      // log('CEK --> POSITION $event');
      final calculate =
          event.inMilliseconds.toDouble() / _duration.inMilliseconds.toDouble();
      if (calculate >= 0.0 && calculate <= 1.0) {
        _percentage = calculate;
      }
      _position = event;
      notifyListeners();
    });
  }

  void play() {
    // log('CEK --> PLAY ${_player.playing} ${_player.position.inMilliseconds.toDouble()} ${_player.duration?.inMilliseconds.toDouble()}');
    if (!_player.playing && _player.processingState == ProcessingState.idle) {
      _player.seek(const Duration()).then((value) => _player.play());
      return;
    }
    _player.play();
  }

  void pause() => _player.pause();

  void destroy() {
    log('CEK dispose player');
    _isPlayerShow = false;
    _audioData = null;
    _duration = const Duration();
    notifyListeners();
    _player.stop();
  }
}

final playerProvider = ChangeNotifierProvider<PlayerNotifier>((ref) {
  return PlayerNotifier();
});
