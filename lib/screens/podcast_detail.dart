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
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(podcast['topic'],
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    Text(podcast['desc'],
                        style: const TextStyle(
                            fontSize: 15, color: Colors.black87)),
                    const SizedBox(height: 20),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: [
                        Chip(
                            label: Text(
                                "🎯 Difficulty: ${podcast['difficulty']}")),
                        Chip(
                            label: Text("📚 Chapters: ${podcast['chapters']}")),
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
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  leading: const Icon(Icons.play_circle_fill,
                      color: Colors.deepPurple, size: 32),
                  title: Text(
                    chapter['title']!,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text("Duration: ${chapter['duration']}"),
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      shape: const RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(20)),
                      ),
                      builder: (_) {
                        double _playbackSpeed = 1.0;

                        return StatefulBuilder(
                          builder: (context, setModalState) => Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 24),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // Handle
                                Container(
                                  height: 4,
                                  width: 40,
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade300,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                const SizedBox(height: 20),

                                // Title
                                Text(
                                  chapter['title']!,
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 12),

                                // Audio Icon
                                Icon(Icons.play_circle_fill,
                                    size: 64, color: Colors.deepPurple),
                                const SizedBox(height: 10),

                                // Static slider
                                Slider(
                                  value: 0.3,
                                  onChanged: (_) {},
                                  activeColor: Colors.deepPurple,
                                  inactiveColor: Colors.deepPurple.shade100,
                                ),
                                const Text("00:36 / 02:00",
                                    style: TextStyle(color: Colors.grey)),

                                const SizedBox(height: 10),

                                // Playback Speed Dropdown
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text("Speed: ",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500)),
                                    DropdownButton<double>(
                                      value: _playbackSpeed,
                                      underline: const SizedBox(),
                                      items:
                                          [0.5, 0.75, 1.0, 1.25, 1.5, 1.75, 2.0]
                                              .map((speed) => DropdownMenuItem(
                                                    value: speed,
                                                    child: Text("${speed}x"),
                                                  ))
                                              .toList(),
                                      onChanged: (value) {
                                        if (value != null) {
                                          setModalState(
                                              () => _playbackSpeed = value);
                                          // TODO: Implement playback speed in real player
                                        }
                                      },
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 20),

                                // Transcript
                                const Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text("Transcript Preview",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  chapter['transcript']!,
                                  style: const TextStyle(color: Colors.black87),
                                ),

                                const SizedBox(height: 30),
                              ],
                            ),
                          ),
                        );
                      },
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
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
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
