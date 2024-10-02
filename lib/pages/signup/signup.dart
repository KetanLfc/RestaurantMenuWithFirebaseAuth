import 'package:flutter/material.dart';
import '../../services/auth_service.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final AuthService _auth = AuthService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String error = '';

  void clearFields() {
    _emailController.clear();
    _passwordController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
      ),
      body: Stack(
        children: [
          Opacity(
            opacity: 0.1,
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/menu.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    filled: true,
                    fillColor: Colors.white70,
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    filled: true,
                    fillColor: Colors.white70,
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () async {
                    dynamic result = await _auth.registerWithEmailAndPassword(
                      _emailController.text,
                      _passwordController.text,
                    );
                    if (result == null) {
                      setState(() {
                        error = 'Could not sign up with those credentials';
                      });
                    } else {
                      Navigator.pushReplacementNamed(context, '/home');
                    }
                    clearFields();
                  },
                  child: const Text('Sign Up'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/');
                  },
                  child: const Text('Already have an account? Login'),
                ),
                Text(error, style: const TextStyle(color: Colors.red)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
