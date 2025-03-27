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

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await dotenv.load(fileName: ".env");
  // final secureStorage = AmplifySecureStorageDart();
  // Amplify.registerDependencies(secureStorage: secureStorage);
  try {
    await Amplify.addPlugin(AmplifyAuthCognito());
    await Amplify.configure(amplifyconfig);
  } catch (e) {
    safePrint("Amplify error: $e");
  }

  runApp(const EchoPodApp());
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
