import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quran/providers/audio_provider.dart';

class ShellRouteLayout extends StatefulWidget {
  const ShellRouteLayout({
    required this.child,
    required this.audioPlayer,
    super.key,
  });

  final Widget child;
  final Widget audioPlayer;

  @override
  State<ShellRouteLayout> createState() => _ShellRouteLayoutState();
}

class _ShellRouteLayoutState extends State<ShellRouteLayout> {
  double? _localPosition;
  double? _alignment;

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final player = ref.watch(playerStateProvider.select((value) => value.isShowPlayer));

        return Scaffold(
          body: Stack(
            children: [
              widget.child,
              if (player)
                Positioned(
                  top: _alignment ?? (MediaQuery.of(context).size.height - 70),
                  left: 0,
                  right: 0,
                  child: GestureDetector(
                    onVerticalDragStart: (details) {
                      setState(() {
                        _alignment = details.globalPosition.dy -
                            details.localPosition.dy;
                        _localPosition = details.localPosition.dy;
                      });
                    },
                    onVerticalDragUpdate: (details) {
                      if (details.globalPosition.dy - _localPosition! <
                          MediaQuery.of(context).size.height - 60) return;
                      setState(() {
                        _alignment =
                            details.globalPosition.dy - _localPosition!;
                      });
                    },
                    onVerticalDragEnd: (details) {
                      if (_alignment! - _localPosition! >
                          MediaQuery.of(context).size.height - 60) {
                        ref.read(playerStateProvider.notifier).destroy();

                        setState(() {
                          _alignment = null;
                          _localPosition = null;
                        });
                      } else {
                        setState(() {
                          _alignment = MediaQuery.of(context).size.height - 70;
                        });
                      }
                    },
                    child: widget.audioPlayer,
                  ),
                )
            ],
          ),
        );
      },
    );
    // return Scaffold(
    //   extendBody: true,
    //   body: widget.child,
    //   floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    //   floatingActionButton: ,
    // );
  }
}
