import 'package:flutter/material.dart';
import 'package:cosmo_care/Pages/LogIn.dart';
import 'package:cosmo_care/Services/AuthService.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  _SignUpDemoState createState() => _SignUpDemoState();
}

class _SignUpDemoState extends State<SignUp> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();

  final AuthService _authService = AuthService();

  // Function to navigate to the login page
  void navigateToLogIn() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LogIn()),
    );
  }

  // Function to show an alert dialog
  void _showAlertDialog(String title, String message, [VoidCallback? onPressed]) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            ElevatedButton(
              onPressed: onPressed ?? () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  // Function to validate inputs and show alert if needed
  void _validateAndSignUp() async {
    String email = _emailController.text;
    String username = _usernameController.text;
    String password = _passwordController.text;
    String firstName = _firstNameController.text;
    String lastName = _lastNameController.text;

    if (email.isEmpty) {
      _showAlertDialog('Alert', 'Please enter your Email');
    } else if (username.isEmpty) {
      _showAlertDialog('Alert', 'Please enter your Username');
    } else if (password.isEmpty) {
      _showAlertDialog('Alert', 'Please enter your Password');
    } else if (password.length < 6) {
      _showAlertDialog('Alert', 'Password must be at least 6 characters long');
    } else if (firstName.isEmpty) {
      _showAlertDialog('Alert', 'Please enter your First Name');
    } else if (lastName.isEmpty) {
      _showAlertDialog('Alert', 'Please enter your Last Name');
    } else {
      // Call the sign-up method from AuthService
      var result = await _authService.signUp(email, password, username, firstName, lastName);
      if (result != null) {
        _showAlertDialog(
          'Success',
          'You have successfully signed up! You can now log in with your email.',
          () {
            Navigator.of(context).pop(); // Close the alert dialog
            navigateToLogIn(); // Navigate to the login page
          },
        );
      } else {
        _showAlertDialog('Error', 'Failed to sign up. Please try again.');
      }
    }
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
                      controller: _firstNameController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'First Name',
                        hintText: 'Enter your first name',
                        prefixIcon: Icon(Icons.person),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: TextField(
                      controller: _lastNameController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Last Name',
                        hintText: 'Enter your last name',
                        prefixIcon: Icon(Icons.person),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: TextField(
                      controller: _emailController,
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
                      onPressed: _validateAndSignUp,
                      child: const Text(
                        'SignUp',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Do you already have an account?'),
                      const SizedBox(height: 5),
                      InkWell(
                        onTap: navigateToLogIn, // Call navigateToLogIn function
                        child: const Text(
                          'LogIn',
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
