import 'package:flutter/material.dart';
import 'package:cosmo_care/Entities/Client.dart';
import 'package:cosmo_care/Pages/Home.dart';
import 'package:cosmo_care/Pages/SignUp.dart';
import 'package:cosmo_care/Services/AuthService.dart';

class LogIn extends StatefulWidget {
  const LogIn({super.key});

  @override
  _LoginDemoState createState() => _LoginDemoState();
}

class _LoginDemoState extends State<LogIn> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _authService = AuthService();

  void navigateToHome() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const Home()),
    );
  }

  void navigateToSignUp() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SignUp()),
    );
  }

  void _validateAndLogin() async {
    String email = _usernameController.text;
    String password = _passwordController.text;

    if (email.isEmpty) {
      _showAlertDialog('Alert', 'Please enter your email');
    } else if (password.isEmpty) {
      _showAlertDialog('Alert', 'Please enter your password');
    } else {
      Client? client = await _authService.SignInWithEmailAndPassword(email, password);

      if (client != null) {
        navigateToHome();
      } else {
        _showAlertDialog('Error', 'Failed to sign in. Please check your credentials.');
      }
    }
  }

  void _showAlertDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            ElevatedButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _forgetPassword() async {
    String email = _usernameController.text;

    if (email.isEmpty) {
      _showAlertDialog('Alert', 'Please enter your email to reset password');
    } else {
      try {
        await _authService.updatePass(email);
        _showAlertDialog('Email Sent', 'Instructions have been sent to your email.');
      } catch (e) {
        _showAlertDialog('Error', 'Failed to send reset email. Please try again.');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFCDB7EB),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 60.0),
              child: Center(
                child: SizedBox(
                  width: 200,
                  height: 200,
                  child: Image.asset('assets/images/login_image-removebg-preview.png'),
                ),
              ),
            ),
            const Text(
              'Cosmo Care',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 20),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 30),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xfffecdcdd),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: TextField(
                      controller: _usernameController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Email',
                        hintText: 'Enter your email',
                        prefixIcon: Icon(Icons.email),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Password',
                        hintText: 'Enter your password',
                        prefixIcon: Icon(Icons.lock),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  InkWell(
                    onTap: _forgetPassword,
                    child: const Text(
                      'Forget Password?',
                      style: TextStyle(
                        color: Colors.black,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    height: 50,
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFAE94D1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                        ),
                      ),
                      onPressed: _validateAndLogin,
                      child: const Text(
                        'Login',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Create new account?'),
                      const SizedBox(height: 5),
                      InkWell(
                        onTap: navigateToSignUp,
                        child: const Text(
                          'Sign up',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
