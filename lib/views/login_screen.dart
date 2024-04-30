import 'package:flutter/material.dart';

import '../controllers/auth_controller.dart';
import '../helper/session.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _email;
  late String _password;
  final AuthController _authController = AuthController();

  bool isLoading = false;

  // check for login
  _checkLog() async {
    await Session().getLog().then((logged) {
      if (logged == true) {
        Navigator.pushNamed(context, '/home');
      }
    });
  }

  @override
  void initState() {
    _checkLog();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: SingleChildScrollView(
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/background.gif"),
              fit: BoxFit.cover,
            ),
          ),
          child: Container(
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.9)),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Image.asset(
                        'assets/images/logo.png',
                        color: Colors.black,
                        height: 150,
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Email'),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your email';
                        }
                        // You can add more sophisticated email validation here if needed
                        return null;
                      },
                      onSaved: (value) {
                        _email = value!;
                      },
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Password'),
                      obscureText: true,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your password';
                        }
                        // You can add more password validation rules here if needed
                        return null;
                      },
                      onSaved: (value) {
                        _password = value!;
                      },
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        _submitForm();
                      },
                      child: isLoading
                          ? const CircularProgressIndicator()
                          : const Text('Login'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _submitForm() async {
    setState(() {
      isLoading = true;
    });

    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      String? result = await _authController.login(_email, _password);
      if (result != null) {
        // Login successful, navigate to another screen or perform desired action
        // For example, navigate to the home screen
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        // Show error message to the user
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(result!),
          backgroundColor: Colors.red,
        ));
      }
    }

    setState(() {
      isLoading = false;
    });
  }
}
