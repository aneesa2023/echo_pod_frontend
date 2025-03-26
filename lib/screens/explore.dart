import 'package:echo_pod_frontend/screens/podcast_detail.dart';
import 'package:flutter/material.dart';

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  final List<Map<String, dynamic>> _dummyPodcasts = const [
    {
      "topic": "Binary Trees",
      "desc": "Learn how to traverse and manipulate binary trees.",
      "difficulty": "Beginner",
      "chapters": 1,
      "voice": "Danielle"
    },
    {
      "topic": "Deep Learning",
      "desc": "Understand the foundations of neural networks and backpropagation.",
      "difficulty": "Advanced",
      "chapters": 3,
      "voice": "Matthew"
    },
    {
      "topic": "World War II",
      "desc": "A podcast on the key events and impact of World War II.",
      "difficulty": "Intermediate",
      "chapters": 2,
      "voice": "Brian"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F0FA),
      body: ListView.builder(
        itemCount: _dummyPodcasts.length,
        padding: const EdgeInsets.all(16),
        itemBuilder: (context, index) {
          final podcast = _dummyPodcasts[index];
          return InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => PodcastDetailScreen(podcast: podcast),
                ),
              );
            },
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 3,
              margin: const EdgeInsets.only(bottom: 16),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      podcast['topic'],
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Description
                    Text(
                      podcast['desc'],
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 12),

                    // Tags: Difficulty, Chapters, Voice
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        Chip(
                          label: Text("🎯 ${podcast['difficulty']}"),
                          backgroundColor: Colors.deepPurple.shade50,
                        ),
                        Chip(
                          label: Text("📚 ${podcast['chapters']} chapters"),
                          backgroundColor: Colors.deepPurple.shade50,
                        ),
                        Chip(
                          label: Text("🗣️ ${podcast['voice']}"),
                          backgroundColor: Colors.deepPurple.shade50,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
