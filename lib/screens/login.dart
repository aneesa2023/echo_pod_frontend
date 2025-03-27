import 'package:flutter/material.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final codeController = TextEditingController();

  bool showConfirmation = false;

  Future<void> signUp() async {
    try {
      final email = emailController.text.trim();
      final password = passwordController.text.trim();

      await Amplify.Auth.signUp(
        username: email,
        password: password,
        options: SignUpOptions(userAttributes: {
          AuthUserAttributeKey.email: email,
        }),
      );

      setState(() => showConfirmation = true);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
                "Signup successful. Check your email for the confirmation code.")),
      );
    } catch (e) {
      safePrint("Signup error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Signup failed: ${e.toString()}")),
      );
    }
  }

  Future<void> confirmSignUp() async {
    try {
      final email = emailController.text.trim();
      final code = codeController.text.trim();

      final result = await Amplify.Auth.confirmSignUp(
        username: email,
        confirmationCode: code,
      );

      if (result.isSignUpComplete) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Email confirmed. Please log in.")),
        );
        setState(() => showConfirmation = false);
      }
    } catch (e) {
      safePrint("Confirm error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Confirmation failed: ${e.toString()}")),
      );
    }
  }

  Future<void> signIn() async {
    try {
      final session = await Amplify.Auth.fetchAuthSession();

      if (session.isSignedIn) {
        await Amplify.Auth.signOut();
      }

      final result = await Amplify.Auth.signIn(
        username: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      if (result.isSignedIn) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Login Successful")),
        );
        Navigator.pushReplacementNamed(context, '/menu');
      }
    } catch (e) {
      safePrint("Login error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Login failed: ${e.toString()}")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F0FA),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("EchoPod Login",
                    style:
                        TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                const SizedBox(height: 32),
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(labelText: "Email"),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: passwordController,
                  decoration: const InputDecoration(labelText: "Password"),
                  obscureText: true,
                ),
                const SizedBox(height: 24),
                if (showConfirmation) ...[
                  TextField(
                    controller: codeController,
                    decoration:
                        const InputDecoration(labelText: "Confirmation Code"),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: confirmSignUp,
                    child: const Text("Confirm Code"),
                  ),
                  const SizedBox(height: 12),
                ],
                ElevatedButton(
                  onPressed: signIn,
                  child: const Text("Login"),
                ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/signup');
                  },
                  child: const Text("Don't have an account? Sign up"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    try {
                      await Amplify.Auth.signOut();
                      Navigator.pushReplacementNamed(context, '/login');
                    } catch (e) {
                      safePrint("Logout error: $e");
                    }
                  },
                  child: const Text("Logout"),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
