# 🎧 EchoPod – Smart Audio Learning on the Go

EchoPod is an AI-powered podcast learning app that transforms complex topics into structured audio courses. Built using **Flutter** and backed by powerful AWS services, EchoPod lets users generate and explore personalized learning content — all in audio format.

---

## ✨ Features

- 🎙️ Compose AI-generated audio courses from any topic
- 🧠 Choose category, difficulty, tone, and voice
- 📝 Generated content includes intro, chapters, transcripts, and audio
- 🔁 Seamless playback with speed control, volume, and sleep timer
- 📚 Explore a growing library of ready-to-listen podcasts
- 💬 Real-time generation status updates via WebSockets
- 🔐 User authentication with **Amazon Cognito**

---

## 🚀 Tech Stack

### 🖥️ Frontend
- **Flutter** (cross-platform mobile app)
- **Provider** (audio playback controller)
- **http** (API requests)
- **audioplayers** (audio playback)
- **Fluttertoast** (notifications and messages)

### ☁️ AWS Backend Services
- **Amazon Bedrock (Claude)** – AI-generated course content
- **Amazon Polly** – Text-to-speech for lifelike audio
- **AWS Lambda** – Stateless, serverless processing
- **API Gateway** – REST endpoints and WebSocket API
- **Amazon S3** – Stores audio files and transcript JSON
- **Amazon DynamoDB** – Stores podcast metadata
- **Amazon Cognito** – Email-based user authentication
- **Amplify Flutter** – Integrates frontend with AWS services

---

## 🛠️ Setup Instructions

1. **Clone the repo**
```bash
git clone https://github.com/your-username/echopod-frontend.git
cd echopod-frontend

1. **Install dependencies**

```bash
flutter pub get
Amplify configuration Make sure you have amplifyconfiguration.dart and models generated:

```bash
amplify pull
amplify codegen models
Run the app

```bash
flutter run
🔐 Auth Configuration
EchoPod uses Amazon Cognito for secure, email-based authentication:

Amplify.Auth.signUp(...)

Amplify.Auth.confirmSignUp(...)

Amplify.Auth.signIn(...)

Amplify.Auth.signOut(...)

📦 Project Structure
bash
Copy
Edit
lib/
├── screens/
│   ├── home.dart
│   ├── explore_screen.dart
│   ├── create_podcast.dart
│   ├── podcast_detail.dart
│   └── audio_player_screen.dart
├── utils/
│   ├── websocket_manager.dart
│   └── global_audio_controller.dart
├── models/
│   └── ModelProvider.dart
├── amplifyconfiguration.dart

🧠 Key Concepts
AI-Generated Learning: Users input a topic → AI generates a full audio curriculum using Claude and Polly.

Real-Time Feedback: WebSocket connections notify users when each generation stage completes.

Cloud Native: The stack uses scalable, stateless, and cost-effective AWS services.

Mobile-First UX: Clean UI built in Flutter with intuitive interactions and minimal navigation.

📈 Roadmap / TODO
 Support for offline playback

 User history and bookmarks

 Admin panel for course moderation

 Add rating/review system for generated courses

 Share podcasts with friends

👨‍💻 Author
EchoPod Team: Aneesa Shaik, Rashmi Subhash
📫 DM for collaboration, feedback, or feature requests!

