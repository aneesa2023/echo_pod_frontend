import 'package:echo_pod_frontend/screens/GlobalAudioController.dart';
import 'package:echo_pod_frontend/screens/audio_player_screen.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class MiniAudioPlayer extends StatefulWidget {
  final VoidCallback onExpand;

  const MiniAudioPlayer({super.key, required this.onExpand, required String currentTitle});

  @override
  State<MiniAudioPlayer> createState() => _MiniAudioPlayerState();
}

class _MiniAudioPlayerState extends State<MiniAudioPlayer> {
  final audioPlayer = AudioPlayer();
  final controller = GlobalAudioController.instance;

  bool isPlaying = true;

  @override
  void initState() {
    super.initState();
    audioPlayer.onPlayerStateChanged.listen((state) {
      if (!mounted) return;
      setState(() => isPlaying = state == PlayerState.playing);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 12,
      child: InkWell(
        onTap: () => controller.expandFullPlayer(context),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          color: Colors.deepPurple.shade50,
          child: Row(
            children: [
              const Icon(Icons.music_note, color: Colors.deepPurple),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  controller.currentTitle ?? "Playing...",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
              IconButton(
                icon: Icon(
                  isPlaying ? Icons.pause : Icons.play_arrow,
                  color: Colors.deepPurple,
                ),
                onPressed: () async {
                  if (isPlaying) {
                    await audioPlayer.pause();
                  } else {
                    await audioPlayer.resume();
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
