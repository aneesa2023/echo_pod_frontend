import 'package:echo_pod_frontend/screens/about.dart';
import 'package:echo_pod_frontend/screens/explore.dart';
import 'package:echo_pod_frontend/screens/login.dart';
import 'package:echo_pod_frontend/screens/menu.dart';
import 'package:echo_pod_frontend/screens/signup.dart';
import 'package:echo_pod_frontend/utils/amplifyconfiguration.dart';
import 'package:echo_pod_frontend/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Amplify.addPlugin(AmplifyAuthCognito());
    await Amplify.configure(amplifyconfig);
  } catch (e) {
    safePrint("Amplify error: $e");
  }

  final isLoggedIn = await checkUserLoggedIn();

  runApp(EchoPodApp(isLoggedIn: isLoggedIn));
}

Future<bool> checkUserLoggedIn() async {
  try {
    final session = await Amplify.Auth.fetchAuthSession();
    return session.isSignedIn;
  } catch (e) {
    safePrint("Session fetch error: $e");
    return false;
  }
}


class EchoPodApp extends StatelessWidget {
  final bool isLoggedIn;
  const EchoPodApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EchoPod',
      theme: echoPodTheme,
      debugShowCheckedModeBanner: false,
      initialRoute: isLoggedIn ? '/menu' : '/login',
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
