import 'package:echo_pod_frontend/screens/about.dart';
import 'package:echo_pod_frontend/screens/explore.dart';
import 'package:echo_pod_frontend/screens/home.dart';
import 'package:echo_pod_frontend/screens/login.dart';
import 'package:echo_pod_frontend/screens/menu.dart';
import 'package:echo_pod_frontend/screens/signup.dart';
import 'package:echo_pod_frontend/utils/amplifyconfiguration.dart';
import 'package:echo_pod_frontend/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_datastore/amplify_datastore.dart';
import 'package:amplify_api/amplify_api.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Amplify.addPlugin(AmplifyAuthCognito());
    await Amplify.configure(amplifyconfig);
    await _configureAmplify();
  } catch (e) {
    safePrint("Amplify error: $e");
  }

  final isLoggedIn = await checkUserLoggedIn();

  runApp(EchoPodApp(isLoggedIn: isLoggedIn));
}


Future<void> _configureAmplify() async {
  // final datastorePlugin =
  // AmplifyDataStore(modelProvider: ModelProvider.instance);
  final apiPlugin = AmplifyAPI();
  final authPlugin = AmplifyAuthCognito();

  await Amplify.addPlugins([ apiPlugin, authPlugin]);

  try {
    await Amplify.configure(amplifyconfig);
  } catch (e) {
    print('An error occurred configuring Amplify: $e');
  }
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
        '/home': (context) => HomeScreen(),
        // '/profile': (context) => ProfileScreen(),
      },
    );
  }
}
