import 'package:flutter/material.dart';

void main() {
  runApp(const MyProfile());
}

class MyProfile extends StatelessWidget {
  const MyProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.purple, // Example theme customization
        hintColor: Colors.pink, // Example theme customization
      ),
    );
  }
}