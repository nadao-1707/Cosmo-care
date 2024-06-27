import 'package:flutter/material.dart';
import 'package:cosmo_care/Pages/Home.dart';
import 'package:cosmo_care/Pages/SignUp.dart';

class LogIn extends StatefulWidget {
  const LogIn({super.key});

  @override
  _LoginDemoState createState() => _LoginDemoState();
}

class _LoginDemoState extends State<LogIn> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Function to navigate to the home page
  void navigateToHome() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const Home()),
    );
  }

  // Function to navigate to the sign-up page
  void navigateToSignUp() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SignUp()),
    );
  }

  // Function to validate inputs and show alert if needed
  void _validateAndLogin() {
    String username = _usernameController.text;
    String password = _passwordController.text;

    if (username.isEmpty) {
      _showAlertDialog('Alert', 'Please enter your username');
    } else if (password.isEmpty) {
      _showAlertDialog('Alert', 'Please enter your password');
    } else {
      navigateToHome();
    }
  }

  // Function to show an alert dialog
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFCDB7EB), // Background color
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
                color: const Color(0xfffecdcdd), // Light rose color
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
                        labelText: 'User name',
                        hintText: 'Enter your user name',
                        prefixIcon: Icon(Icons.person),
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
                  const SizedBox(
                    height: 30,
                  ),
                  SizedBox(
                    height: 50,
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFAE94D1), // Button color
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
                        onTap: navigateToSignUp, // Call navigateToSignUp function
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