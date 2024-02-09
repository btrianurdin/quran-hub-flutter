import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:just_audio/just_audio.dart';
import 'package:quran/models/player_state_model.dart';
import 'package:quran/models/quran_audio_model.dart';
import 'package:quran/providers/surah_provider.dart';
import 'package:quran/services/audio/audio_service.dart';

class PlayerStateNotifier extends StateNotifier<PlayerStateModel> {
  final AudioPlayer _player;

  PlayerStateNotifier(this._player)
      : super(PlayerStateModel(
          isPlaying: false,
          isShowPlayer: false,
          sources: [],
          currentNumber: 0,
          totalNumber: 0,
          percentage: 0.0,
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
          state = state.copyWith(isPlaying: event.playing, isLoading: false);
          break;
        case ProcessingState.completed:
          state = state.copyWith(isPlaying: false);
          if (state.currentNumber <= state.totalNumber - 1) {
            state = state.copyWith(currentNumber: state.currentNumber + 1);
            _player.setUrl(state.sources[state.currentNumber - 1]);
            _player.play();
            return;
          }
          _player.stop();
          break;
        case ProcessingState.loading:
          state = state.copyWith(isLoading: true);
          break;
        default:
      }
    });
  }

  void loaded({
    required List<String> audios,
    required QuranAudioModel audio,
  }) {
    state = state.copyWith(
      isShowPlayer: true,
      data: audio,
      sources: audios,
      currentNumber: audio.currentNumber,
      totalNumber: audios.length,
      isLoading: true,
    );
    _player.setUrl(audios[audio.currentNumber - 1]);
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
    state = state.copyWith(
      isShowPlayer: false,
      sources: [],
      currentNumber: 0,
      totalNumber: 0,
      percentage: 0.0,
    );
    _player.stop();
  }
}

final playerStateProvider =
    StateNotifierProvider<PlayerStateNotifier, PlayerStateModel>((ref) {
  return PlayerStateNotifier(ref.read(audioServiceProvider));
});

final playAudioProvider = FutureProvider.family
    .autoDispose<void, QuranAudioModel>((ref, audio) async {
  final verse = await ref.watch(versesProvider(audio.id).future);
  final audios = verse.map((e) => e.audio).toList();

  return ref
      .read(playerStateProvider.notifier)
      .loaded(audios: audios, audio: audio);
});
