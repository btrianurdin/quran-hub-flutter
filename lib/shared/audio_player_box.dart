import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quran/providers/audio_provider.dart';
import 'package:quran/utils/font_styles.dart';
import 'package:quran/utils/format_duration.dart';
import 'package:quran/utils/theme_color.dart';

class AudioPlayerBox extends ConsumerStatefulWidget {
  const AudioPlayerBox({super.key});

  @override
  ConsumerState<AudioPlayerBox> createState() => _AudioPlayerBoxState();
}

class _AudioPlayerBoxState extends ConsumerState<AudioPlayerBox> {
  @override
  Widget build(BuildContext context) {
    final player = ref.watch(playerStateProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: ThemeColor.surface,
          borderRadius: const BorderRadius.all(
            Radius.circular(8),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Surah ${player.data?.surahName} | Ayah ${player.currentNumber}',
                          style: FontStyles.regular.copyWith(
                              fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${formatDuration(player.position)} / ${formatDuration(player.duration)}',
                          style: FontStyles.regular.copyWith(fontSize: 10),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      if (player.isPlaying) {
                        ref.read(playerStateProvider.notifier).pause();
                      } else {
                        ref.read(playerStateProvider.notifier).play();
                      }
                    },
                    child: player.isLoading!
                        ? Container(
                            width: 18,
                            height: 18,
                            margin: const EdgeInsets.only(right: 8),
                            child: const CircularProgressIndicator(
                              color: ThemeColor.primary,
                              strokeWidth: 2,
                            ),
                          )
                        : Icon(
                            player.isPlaying
                                ? CupertinoIcons.pause_solid
                                : CupertinoIcons.play_arrow_solid,
                            color: ThemeColor.primary,
                          ),
                  )
                ],
              ),
            ),
            Stack(
              children: [
                FractionallySizedBox(
                  widthFactor: player.percentage,
                  child: Container(
                    height: 3,
                    color: ThemeColor.primary,
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: 3,
                  color: ThemeColor.primary.withOpacity(0.2),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
