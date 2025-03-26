import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';

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
  String _difficulty = "Beginner";
  String _tone = "Educational";
  String _voice = "Danielle";

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

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode(payload),
      );

      if (response.statusCode == 200) {
        Fluttertoast.showToast(msg: "Topic stored successfully!");
      } else {
        Fluttertoast.showToast(msg: "Failed to store topic");
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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
            _buildDropdown(
              value: _category,
              items: ["Technical & Programming", "Science", "History"],
              onChanged: (val) => setState(() => _category = val!),
            ),
            _buildLabel("Difficulty"),
            _buildDropdown(
              value: _difficulty,
              items: ["Beginner", "Intermediate", "Advanced"],
              onChanged: (val) => setState(() => _difficulty = val!),
            ),
            _buildLabel("Number of Chapters"),
            _buildTextField(_chaptersController, "e.g. 1", keyboardType: TextInputType.number),
            _buildLabel("Tone"),
            _buildTextField(null, "e.g. Educational", initialValue: _tone, onChanged: (val) => _tone = val),
            _buildLabel("Voice"),
            _buildTextField(null, "e.g. Danielle", initialValue: _voice, onChanged: (val) => _voice = val),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: submitTopic,
                child: const Text("Submit", style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
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
