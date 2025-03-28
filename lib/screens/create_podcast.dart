import 'package:echo_pod_frontend/screens/GlobalAudioController.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:echo_pod_frontend/utils/websocket_manager.dart';
import 'package:echo_pod_frontend/screens/podcast_detail.dart';
import 'package:echo_pod_frontend/screens/mini_audio_player.dart';

class CreatePodcast extends StatefulWidget {
  const CreatePodcast({super.key});

  @override
  State<CreatePodcast> createState() => _CreatePodcastState();
}

class _CreatePodcastState extends State<CreatePodcast> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _topicController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _chaptersController = TextEditingController();

  String _category = "Technical & Programming";
  String _difficulty = "BEGINNER";
  String _tone = "Educational";
  String _voice = "Danielle";
  bool _isLoading = false;

  final List<String> _categories = [
    "Technical & Programming",
    "Mathematics and Algorithms",
    "Science & Engineering",
    "History & Social Studies",
    "Creative Writing & Literature",
    "Health & Medicine"
  ];

  final List<String> _difficultyLevels = [
    "BEGINNER",
    "INTERMEDIATE",
    "ADVANCED"
  ];

  final List<String> _tones = [
    "Conversational",
    "Educational",
    "Formal",
    "Storytelling",
    "Case Studies",
    "Step-by-Step",
    "Engaging Narrative"
  ];

  Future<void> submitTopic() async {
    final url = Uri.parse("https://2vyfajwiq2.execute-api.us-east-1.amazonaws.com/dev/store-topic");

    final payload = {
      "category": _category,
      "topic": _topicController.text.trim(),
      "desc": _descController.text.trim(),
      "level_of_difficulty": _difficulty,
      "chapters": int.tryParse(_chaptersController.text) ?? 1,
      "Tone": _tone,
      "Voice": _voice,
    };

    setState(() => _isLoading = true);

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode(payload),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final topicId = json.decode(data['body'])['topic_id'];
        final requestId = json.decode(data['body'])['request_id'];

        final ws = WebSocketManager(
          topicId: topicId,
          onMessage: (msg) {
            print("\u{1F4E5} Notification received: $msg");
            final decoded = json.decode(msg);
            if (decoded['message'] == 'Content generation completed successfully') {
              Fluttertoast.showToast(msg: "Podcast ready! Fetching content...");
            }
          },
          onDone: () {
            print("\u2705 All 3 messages received. WebSocket closed.");
            setState(() => _isLoading = false);

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => PodcastDetailScreen(
                  podcast: {
                    "topic": _topicController.text.trim(),
                    "desc": _descController.text.trim(),
                    "difficulty": _difficulty,
                    "chapters": _chaptersController.text.trim(),
                    "voice": _voice,
                    "Tone": _tone,
                    "category": _category,
                    "topic_id": topicId,
                    "request_id": requestId
                  },
                ),
              ),
            );
          },
        );

        ws.connect();

        Fluttertoast.showToast(msg: "Podcast generation started!");
      } else {
        Fluttertoast.showToast(msg: "Failed to store topic");
        setState(() => _isLoading = false);
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Error: $e");
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final audioController = GlobalAudioController.instance;

    return Stack(
      children: [
        SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildLabel("Topic"),
                _buildTextField(_topicController, "Enter your topic"),
                _buildLabel("Description"),
                _buildTextField(_descController, "Write a short description", maxLines: 3),
                _buildLabel("Category"),
                _buildDropdown(value: _category, items: _categories, onChanged: (val) => setState(() => _category = val!)),
                _buildLabel("Difficulty"),
                _buildDropdown(value: _difficulty, items: _difficultyLevels, onChanged: (val) => setState(() => _difficulty = val!)),
                _buildLabel("Number of Chapters"),
                _buildTextField(_chaptersController, "e.g. 1", keyboardType: TextInputType.number),
                _buildLabel("Tone"),
                _buildDropdown(value: _tone, items: _tones, onChanged: (val) => setState(() => _tone = val!)),
                _buildLabel("Voice"),
                _buildTextField(null, "e.g. Danielle", initialValue: _voice, onChanged: (val) => _voice = val),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : submitTopic,
                    child: const Text("Submit", style: TextStyle(fontSize: 16)),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (_isLoading)
          Container(
            color: Colors.black.withOpacity(0.5),
            child: const Center(child: CircularProgressIndicator()),
          ),
        if (audioController.isPlaying)
          Align(
            alignment: Alignment.bottomCenter,
            child: MiniAudioPlayer(
              onExpand: () => audioController.expandFullPlayer(context),
              currentTitle: '',
            ),
          ),
      ],
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 8),
      child: Text(
        text,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.deepPurple),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController? controller,
      String hint, {
        int maxLines = 1,
        TextInputType keyboardType = TextInputType.text,
        String? initialValue,
        void Function(String)? onChanged,
      }) {
    return TextFormField(
      controller: controller,
      initialValue: initialValue,
      onChanged: onChanged,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required String value,
    required List<String> items,
    required void Function(String?) onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      onChanged: onChanged,
      items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
