import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("About EchoPod")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          "EchoPod is an AI-powered podcast generator where users can create and explore audio content by providing topics, tone, and voice preferences.",
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
