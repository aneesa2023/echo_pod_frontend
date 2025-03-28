import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:echo_pod_frontend/screens/audio_player_screen.dart';
import 'package:echo_pod_frontend/screens/mini_audio_player.dart';
import 'package:echo_pod_frontend/screens/GlobalAudioController.dart';

class PodcastDetailScreen extends StatefulWidget {
  final Map<String, dynamic> podcast;

  const PodcastDetailScreen({super.key, required this.podcast});

  @override
  State<PodcastDetailScreen> createState() => _PodcastDetailScreenState();
}

class _PodcastDetailScreenState extends State<PodcastDetailScreen> {
  List<Map<String, String>> chapters = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchContentAndAudioFromS3();
  }

  Future<void> _fetchContentAndAudioFromS3() async {
    try {
      final topicId = widget.podcast['topic_id'];
      final contentBaseUrl = "https://echopod-content.s3.amazonaws.com/$topicId/";
      final audioBaseUrl = "https://echopod-audio.s3.amazonaws.com/$topicId/";

      List<Map<String, String>> chapterList = [];

      // Try fetching intro.json
      final introRes = await http.get(Uri.parse("${contentBaseUrl}intro.json"));
      print("🔍 Fetching intro.json => Status: ${introRes.statusCode}");
      if (introRes.statusCode == 200) {
        final introData = json.decode(introRes.body);
        print("✅ introData: $introData");
        chapterList.add({
          "title": "Introduction",
          "duration": "~1 min",
          "transcript": introData['content'].toString(),
          "asset": "${audioBaseUrl}intro.mp3",
        });
      }

      // Try fetching chapter_1.json, chapter_2.json... until 404
      int index = 1;
      while (true) {
        final chapterUrl = "${contentBaseUrl}chapter_$index.json";
        final chapterRes = await http.get(Uri.parse(chapterUrl));
        print("🔍 Fetching chapter_$index.json => Status: ${chapterRes.statusCode}");

        if (chapterRes.statusCode != 200) break;

        final chapterData = json.decode(chapterRes.body);
        print("✅ chapter_$index data: $chapterData");
        chapterList.add({
          "title": "Chapter $index",
          "duration": "~2 min",
          "transcript": chapterData['content'].toString(),
          "asset": "${audioBaseUrl}chapter_$index.mp3",
        });

        index++;
      }

      setState(() {
        chapters = chapterList;
        isLoading = false;
      });
      print("📘 Final chapter list: $chapterList");
    } catch (e) {
      print("❌ Error fetching content: $e");
      setState(() => isLoading = false);
    }
  }

  String get fullTranscript => chapters.map((c) => c['transcript']).join("\n\n");

  @override
  Widget build(BuildContext context) {
    final audioController = GlobalAudioController.instance;

    return Scaffold(
      backgroundColor: const Color(0xFFF6F0FA),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(widget.podcast['topic']),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildPodcastCard(),
                const SizedBox(height: 24),
                const Text("Chapters",
                    style: TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: chapters.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final chapter = chapters[index];
                    return ListTile(
                      tileColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      leading: const Icon(Icons.play_circle_fill,
                          color: Colors.deepPurple, size: 32),
                      title: Text(chapter['title']!,
                          style: const TextStyle(
                              fontWeight: FontWeight.w600)),
                      subtitle:
                      Text("Duration: ${chapter['duration']}"),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => AudioPlayerScreen(
                              podcast: widget.podcast,
                              chapters: chapters,
                              initialIndex: index,
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
                const SizedBox(height: 30),
                const Text("Course Transcript",
                    style: TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      fullTranscript,
                      style: const TextStyle(
                          fontSize: 14, color: Colors.black87),
                    ),
                  ),
                ),
                const SizedBox(height: 80),
              ],
            ),
          ),
          // if (audioController.isPlaying)
          //   Align(
          //     alignment: Alignment.bottomCenter,
          //     child: MiniAudioPlayer(
          //       currentTitle: widget.podcast['topic'],
          //       onExpand: () =>
          //           audioController.expandFullPlayer(context),
          //     ),
          //   )
        ],
      ),
    );
  }

  Widget _buildPodcastCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.podcast['topic'],
                style:
                const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text(widget.podcast['desc'],
                style: const TextStyle(fontSize: 15, color: Colors.black87)),
            const SizedBox(height: 20),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                Chip(
                    label: Text(
                        "🎯 Difficulty: ${widget.podcast['difficulty']}")),
                Chip(
                    label:
                    Text("📚 Chapters: ${widget.podcast['chapters']}")),
                Chip(
                    label: Text("🗣️ Voice: ${widget.podcast['voice']}")),
                if (widget.podcast.containsKey('Tone'))
                  Chip(label: Text("🧠 Tone: ${widget.podcast['Tone']}")),
                if (widget.podcast.containsKey('category'))
                  Chip(label: Text("📂 Category: ${widget.podcast['category']}")),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
