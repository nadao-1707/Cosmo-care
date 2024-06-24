import 'package:cosmo_care/Entities/Client.dart';
import 'package:cosmo_care/Services/Wrapper.dart';
import 'package:cosmo_care/Services/AuthService.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
     options: FirebaseOptions(
      apiKey: "AIzaSyD7NIeFArQ_vBqNx5vTirVACVR3Lq_YPRE",
      appId: "1:863362114183:android:7f7b51437c3452e903ce22",
      messagingSenderId: "863362114183",
      projectId: "cosmo-care-db4b9",
    ),
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<Client?>.value(
      value: AuthService().user, 
      initialData: null,
      child: MaterialApp(
        home: Wrapper(),
      ),
    );
  }
}
