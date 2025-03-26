import 'package:flutter/material.dart';

class PodcastDetailScreen extends StatelessWidget {
  final Map<String, dynamic> podcast;

  const PodcastDetailScreen({super.key, required this.podcast});

  @override
  Widget build(BuildContext context) {
    // Generate dummy chapters
    final List<Map<String, String>> chapters = List.generate(
      podcast['chapters'],
          (index) => {
        "title": "Chapter ${index + 1}",
        "duration": "${(index + 1) * 2} min",
        "transcript": "Transcript for chapter ${index + 1} will appear here."
      },
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF6F0FA),
      appBar: AppBar(
        title: Text(podcast['topic']),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🟣 Overview
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(podcast['topic'],
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    Text(podcast['desc'],
                        style: const TextStyle(fontSize: 15, color: Colors.black87)),
                    const SizedBox(height: 20),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: [
                        Chip(label: Text("🎯 Difficulty: ${podcast['difficulty']}")),
                        Chip(label: Text("📚 Chapters: ${podcast['chapters']}")),
                        Chip(label: Text("🗣️ Voice: ${podcast['voice']}")),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // 🎧 Chapter List
            const Text(
              "Chapters",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
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
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  leading: const Icon(Icons.play_circle_fill, color: Colors.deepPurple, size: 32),
                  title: Text(chapter['title']!, style: const TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: Text("Duration: ${chapter['duration']}"),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: Text(chapter['title']!),
                        content: Text(chapter['transcript']!),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text("Close"),
                          )
                        ],
                      ),
                    );
                  },
                );
              },
            ),

            const SizedBox(height: 30),

            // 📜 Transcript Placeholder
            const Text(
              "Course Transcript",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  "This is where the full transcript or summary of the podcast will be displayed once available.",
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
