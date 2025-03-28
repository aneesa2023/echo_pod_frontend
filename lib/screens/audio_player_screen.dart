import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:async';

class AudioService {
  static final AudioService _instance = AudioService._internal();
  factory AudioService() => _instance;

  late AudioPlayer audioPlayer;
  bool initialized = false;

  AudioService._internal() {
    audioPlayer = AudioPlayer();
  }

  void reset() {
    audioPlayer.dispose();
    audioPlayer = AudioPlayer();
  }
}

class AudioPlayerScreen extends StatefulWidget {
  final Map<String, dynamic> podcast;
  final List<Map<String, String>> chapters;
  final int initialIndex;

  const AudioPlayerScreen({
    super.key,
    required this.podcast,
    required this.chapters,
    required this.initialIndex,
  });

  @override
  State<AudioPlayerScreen> createState() => _AudioPlayerScreenState();
}

class _AudioPlayerScreenState extends State<AudioPlayerScreen> {
  final audioPlayer = AudioService().audioPlayer;
  StreamSubscription? _positionSub;
  StreamSubscription? _durationSub;
  StreamSubscription? _completeSub;

  int currentIndex = 0;
  Duration currentPosition = Duration.zero;
  Duration totalDuration = Duration.zero;
  bool isPlaying = false;
  double playbackSpeed = 1.0;
  double volume = 1.0;
  int? sleepTimerMinutes;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.initialIndex;
    _initListeners();
    _playCurrent();
  }

  void _initListeners() {
    _positionSub = audioPlayer.onPositionChanged.listen((pos) {
      if (!mounted) return;
      setState(() => currentPosition = pos);
    });

    _durationSub = audioPlayer.onDurationChanged.listen((dur) {
      if (!mounted) return;
      setState(() => totalDuration = dur);
    });

    _completeSub = audioPlayer.onPlayerComplete.listen((_) async {
      if (!mounted) return;
      if (currentIndex < widget.chapters.length - 1) {
        setState(() => currentIndex++);
        await _playCurrent();
      } else {
        setState(() => isPlaying = false);
      }
    });
  }

  Future<void> _playCurrent() async {
    final chapter = widget.chapters[currentIndex];
    try {
      await audioPlayer.stop();
      await audioPlayer.setSourceUrl(chapter['asset']!).timeout(const Duration(seconds: 10));
      await audioPlayer.setPlaybackRate(playbackSpeed);
      await audioPlayer.setVolume(volume);
      await audioPlayer.resume();
      if (!mounted) return;
      setState(() => isPlaying = true);
    } catch (e) {
      debugPrint('⚠️ Error loading audio: $e');
      setState(() => isPlaying = false);
    }
  }

  void _startSleepTimer(int minutes) {
    sleepTimerMinutes = minutes;
    Future.delayed(Duration(minutes: minutes), () async {
      if (mounted && isPlaying) {
        await audioPlayer.pause();
        if (!mounted) return;
        setState(() => isPlaying = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Playback stopped after $minutes minute(s)")),
        );
      }
    });
  }

  void _showSleepTimerOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        final List<int> options = [5, 10, 15, 30, 45, 60];
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text('Sleep Timer', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            ...options.map((min) => ListTile(
              title: Text("Stop after $min minute(s)"),
              onTap: () {
                Navigator.pop(context);
                _startSleepTimer(min);
              },
            )),
            ListTile(
              title: const Text("Off"),
              onTap: () {
                Navigator.pop(context);
                if (!mounted) return;
                setState(() => sleepTimerMinutes = null);
              },
            ),
          ],
        );
      },
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }

  @override
  void dispose() {
    _positionSub?.cancel();
    _durationSub?.cancel();
    _completeSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final chapter = widget.chapters[currentIndex];

    return Scaffold(
      appBar: AppBar(title: Text(chapter['title']!)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                color: Colors.deepPurple.shade100,
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Padding(
                padding: EdgeInsets.all(24.0),
                child: Icon(Icons.graphic_eq, size: 120, color: Colors.deepPurple),
              ),
            ),
            const SizedBox(height: 30),
            Text(
              chapter['title']!,
              style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            Text(
              widget.podcast['topic'],
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 30),
            Slider(
              value: currentPosition.inSeconds.clamp(0, totalDuration.inSeconds).toDouble(),
              max: totalDuration.inSeconds > 0 ? totalDuration.inSeconds.toDouble() : 1.0,
              onChanged: (value) async {
                await audioPlayer.seek(Duration(seconds: value.toInt()));
              },
              activeColor: Colors.deepPurple,
              inactiveColor: Colors.deepPurple.shade100,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(_formatDuration(currentPosition), style: const TextStyle(fontSize: 14)),
                Text(_formatDuration(totalDuration), style: const TextStyle(fontSize: 14)),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                DropdownButton<double>(
                  value: playbackSpeed,
                  underline: const SizedBox(),
                  items: [0.5, 0.75, 1.0, 1.25, 1.5, 2.0]
                      .map((speed) => DropdownMenuItem(value: speed, child: Text("${speed}x")))
                      .toList(),
                  onChanged: (value) async {
                    if (value != null) {
                      await audioPlayer.setPlaybackRate(value);
                      if (!mounted) return;
                      setState(() => playbackSpeed = value);
                    }
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.replay_10, size: 32, color: Colors.deepPurple),
                  onPressed: () async {
                    final newPosition = currentPosition - const Duration(seconds: 10);
                    await audioPlayer.seek(newPosition >= Duration.zero ? newPosition : Duration.zero);
                  },
                ),
                IconButton(
                  icon: Icon(
                    isPlaying ? Icons.pause_circle_filled : Icons.play_circle_fill,
                    size: 64,
                    color: Colors.deepPurple,
                  ),
                  onPressed: () async {
                    if (isPlaying) {
                      await audioPlayer.pause();
                    } else {
                      await audioPlayer.resume();
                    }
                    if (!mounted) return;
                    setState(() => isPlaying = !isPlaying);
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.forward_10, size: 32, color: Colors.deepPurple),
                  onPressed: () async {
                    final newPosition = currentPosition + const Duration(seconds: 10);
                    await audioPlayer.seek(newPosition <= totalDuration ? newPosition : totalDuration);
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.bedtime, size: 28, color: Colors.deepPurple),
                  onPressed: _showSleepTimerOptions,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.volume_down, color: Colors.deepPurple),
                Expanded(
                  child: Slider(
                    value: volume.clamp(0.0, 1.0),
                    min: 0,
                    max: 1,
                    divisions: 10,
                    onChanged: (value) async {
                      if (!mounted) return;
                      setState(() => volume = value);
                      await audioPlayer.setVolume(volume);
                    },
                    activeColor: Colors.deepPurple,
                    inactiveColor: Colors.deepPurple.shade100,
                  ),
                ),
                const Icon(Icons.volume_up, color: Colors.deepPurple),
              ],
            ),
            const SizedBox(height: 20),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text("Transcript Preview", style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 8),
            Text(
              chapter['transcript']!,
              style: const TextStyle(color: Colors.black87, height: 1.5),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
