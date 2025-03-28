import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:echo_pod_frontend/screens/podcast_detail.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  List<Map<String, dynamic>> _podcasts = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchCoursesFromS3();
  }

  Future<void> _fetchCoursesFromS3() async {
    try {
      final url = Uri.parse("https://echopod-content.s3.amazonaws.com/courses/index.json");
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> courses = data['courses'];

        setState(() {
          _podcasts = courses.map<Map<String, dynamic>>((e) => Map<String, dynamic>.from(e)).toList();
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to fetch course list');
      }
    } catch (e) {
      debugPrint("❌ Error fetching courses: $e");
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F0FA),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: _podcasts.length,
        padding: const EdgeInsets.all(16),
        itemBuilder: (context, index) {
          final podcast = _podcasts[index];
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
                    Text(
                      podcast['topic'],
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
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
