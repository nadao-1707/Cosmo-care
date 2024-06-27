import 'package:flutter/material.dart';
import 'package:flutter_application_2/Pages/Loading.dart';
import 'package:flutter_application_2/Pages/Questionnaire.dart'; 
import 'package:flutter_application_2/Pages/SkinTypeTest.dart';
import 'package:flutter_application_2/Pages/UploadImage.dart'; 

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/loading', // Set the initial route to the loading screen
      routes: {
        '/loading': (context) => Loading(), // Define loading screen route
        '/': (context) => Questionnaire(), // Define root route
        '/skinTypeTest': (context) => SkinTypeTest(), // Define SkinTypeTest route
        '/uploadImage': (context) => UploadImage(), // Define UploadImage route
      },
      theme: ThemeData(
        primarySwatch: Colors.purple, // Example theme customization
        hintColor: Colors.pink, // Example theme customization
      ),
    );
  }
}
