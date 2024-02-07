import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:just_audio/just_audio.dart';
import 'package:quran/models/player_state_model.dart';
import 'package:quran/models/quran_audio_model.dart';
import 'package:quran/services/audio/audio_service.dart';

class PlayerStateNotifier extends StateNotifier<PlayerStateModel> {
  final AudioPlayer _player;

  PlayerStateNotifier(this._player)
      : super(PlayerStateModel(
          isPlaying: false,
          isShowPlayer: false,
        )) {
    log('CEK --> INIT PLAYER STATE NOTIFIER');

    _player.durationStream.listen((event) {
      state = state.copyWith(duration: event);
    });

    _player.playbackEventStream.listen((event) {}, onError: (e, s) {
      Fluttertoast.showToast(msg: 'Internet connection is not available');
    });

    _player.positionStream.listen((event) {
      if (state.duration == null) return;

      final currentDuration = event.inMilliseconds.toDouble();
      final stateDuration = state.duration!.inMilliseconds.toDouble();
      final calculate = currentDuration / stateDuration;
      if (calculate >= 0.0 && calculate <= 1.0) {
        state = state.copyWith(percentage: calculate);
      }
      state = state.copyWith(position: event);
    });

    _player.playerStateStream.listen((event) {
      switch (event.processingState) {
        case ProcessingState.ready:
          if (event.playing) {
            state = state.copyWith(isPlaying: true);
          } else {
            state = state.copyWith(isPlaying: false);
          }
          break;
        case ProcessingState.completed:
          state = state.copyWith(isPlaying: false);
          _player.stop();
          break;
        default:
      }
    });
  }

  void loaded(QuranAudioModel audio) {
    state = state.copyWith(isShowPlayer: true, data: audio);

    _player.setUrl(audio.url);
    _player.play();
  }

  void play() {
    if (!_player.playing && _player.processingState == ProcessingState.idle) {
      _player.seek(const Duration()).then((value) => _player.play());
      return;
    }
    _player.play();
  }

  void pause() => _player.pause();
  void destroy() {
    state = state.copyWith(isShowPlayer: false);
    _player.stop();
  }
}

final playerStateProvider =
    StateNotifierProvider<PlayerStateNotifier, PlayerStateModel>((ref) {
  return PlayerStateNotifier(ref.read(audioServiceProvider));
});
