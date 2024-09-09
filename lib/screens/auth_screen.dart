import 'package:flutter/material.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:logging/logging.dart';

final log = Logger('AuthScreen');

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() =>
      _AuthScreenState(); // Changed to State<AuthScreen>
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isSignUp = false;

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      try {
        if (_isSignUp) {
          await Amplify.Auth.signUp(
            username: _usernameController.text,
            password: _passwordController.text,
          );
          log.info('Sign up successful');
        } else {
          await Amplify.Auth.signIn(
            username: _usernameController.text,
            password: _passwordController.text,
          );
          log.info('Sign in successful');
        }
        // Navigate to main screen
        if (mounted) {
          await Navigator.of(context).pushReplacementNamed('/home');
        }
      } catch (e) {
        log.severe('Authentication error: $e');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Authentication failed: $e')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_isSignUp ? 'Sign Up' : 'Sign In')),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: _usernameController,
              decoration: const InputDecoration(labelText: 'Username'),
              validator: (value) =>
                  value!.isEmpty ? 'Username is required' : null,
            ),
            TextFormField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
              validator: (value) =>
                  value!.isEmpty ? 'Password is required' : null,
            ),
            ElevatedButton(
              onPressed: _submitForm,
              child: Text(_isSignUp ? 'Sign Up' : 'Sign In'),
            ),
            TextButton(
              onPressed: () => setState(() => _isSignUp = !_isSignUp),
              child: Text(_isSignUp
                  ? 'Already have an account? Sign In'
                  : 'Need an account? Sign Up'),
            ),
          ],
        ),
      ),
    );
  }
}
