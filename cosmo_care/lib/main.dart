import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cosmo_care/Pages/Loading.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
     options: const FirebaseOptions(
      apiKey: "AIzaSyD7NIeFArQ_vBqNx5vTirVACVR3Lq_YPRE",
      appId: "1:863362114183:android:7f7b51437c3452e903ce22",
      messagingSenderId: "863362114183",
      projectId: "cosmo-care-db4b9",
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Loading(),
      debugShowCheckedModeBanner: false,
      initialRoute: '/loading', // Set the initial route to the loading screen
      routes: {
        '/loading': (context) => const Loading(), // Define loading screen route
      },
      theme: ThemeData(
        primarySwatch: Colors.purple, // Example theme customization
        hintColor: Colors.purple, // Example theme customization
      ),
    );
  }
}