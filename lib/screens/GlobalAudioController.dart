import 'package:echo_pod_frontend/screens/mini_audio_player.dart';
import 'package:flutter/material.dart';

class GlobalAudioController {
  static final GlobalAudioController instance = GlobalAudioController._internal();

  GlobalAudioController._internal();

  bool isPlaying = false;
  String? currentTitle;

  Widget get miniPlayerWidget => MiniAudioPlayer(
    currentTitle: currentTitle ?? '',
    onExpand: () {
      // TODO: Implement navigation to full AudioPlayerScreen if needed
    },
  );

  void updateNowPlaying({
    required String title,
  }) {
    currentTitle = title;
    isPlaying = true;
  }

  void stop() {
    isPlaying = false;
    currentTitle = null;
  }

  void expandFullPlayer(BuildContext context) {
    // TODO: Implement actual logic to navigate to full audio player
    debugPrint("Expanding full audio player");
  }
}