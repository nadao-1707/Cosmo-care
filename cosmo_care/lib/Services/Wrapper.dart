
import 'package:cosmo_care/Pages/AdminHome.dart';
import 'package:cosmo_care/Pages/Home.dart';
import 'package:cosmo_care/Services/AuthService.dart';
import 'package:cosmo_care/Services/Authenticate.dart';
import 'package:flutter/material.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final AuthService _auth = AuthService();

    return FutureBuilder<String?>(
      future: _auth.getUserId(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else {
          if (snapshot.hasData) {
            if (snapshot.data == "qiVz5dEYVxM1z2LZBR4lGCQ3QnS2") {
              return AdminHome();
            } else {
              return Home();
            }
          } else {
            return Authenticate();
          }
        }
      },
    );
  }
}
