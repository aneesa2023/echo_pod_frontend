import 'package:echo_pod_frontend/screens/about.dart';
import 'package:echo_pod_frontend/screens/create_podcast.dart';
import 'package:echo_pod_frontend/screens/explore.dart';
import 'package:echo_pod_frontend/screens/login.dart';
import 'package:echo_pod_frontend/screens/menu.dart';
import 'package:echo_pod_frontend/screens/signup.dart';
import 'package:echo_pod_frontend/utils/theme.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(EchoPodApp());
}

class EchoPodApp extends StatelessWidget {
  const EchoPodApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EchoPod',
      theme: echoPodTheme,
      debugShowCheckedModeBanner: false,
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginScreen(),
        '/signup': (context) => SignupScreen(),
        '/menu': (context) => MenuScreen(),
        '/explore': (context) => ExploreScreen(),
        '/about': (context) => AboutScreen(),
        // '/profile': (context) => ProfileScreen(),
      },
    );
  }
}
