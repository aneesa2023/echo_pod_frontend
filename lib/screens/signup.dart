import 'package:flutter/material.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
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
        const SnackBar(content: Text("Signup successful. Check your email for confirmation code.")),
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
        Navigator.pushReplacementNamed(context, '/login');
      }
    } catch (e) {
      safePrint("Confirm error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Confirmation failed: ${e.toString()}")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F0FA),
      appBar: AppBar(title: const Text("Sign Up")),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const Text("Create Your EchoPod Account",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                const SizedBox(height: 30),

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
                const SizedBox(height: 20),

                if (showConfirmation) ...[
                  TextField(
                    controller: codeController,
                    decoration: const InputDecoration(labelText: "Confirmation Code"),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: confirmSignUp,
                    child: const Text("Confirm Sign Up"),
                  ),
                  const SizedBox(height: 12),
                ] else
                  ElevatedButton(
                    onPressed: signUp,
                    child: const Text("Sign Up"),
                  ),

                const SizedBox(height: 10),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Already have an account? Log in"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
