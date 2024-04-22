import 'package:cosmo_care/Services/AuthService.dart';
import 'package:flutter/material.dart';
import 'package:cosmo_care/Services/Authenticate.dart';

class Home extends StatelessWidget {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    //dummy code for trial pruposes
    return Scaffold(
      backgroundColor: Colors.brown[50],
      appBar: AppBar(
        title: Text(''),
        backgroundColor: Colors.brown[400],
        elevation: 0.0,
        actions: <Widget>[
          TextButton.icon(
            icon: Icon(Icons.person),
            label: Text('logout'),
            onPressed: () async {
              await _auth.SignOut();
              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Authenticate()));
            },
          ),
        ],
      ),
      body: Container(),
    );
  }
}
