import 'package:cosmo_care/Controllers/Authenticate.dart';
import 'package:cosmo_care/Entities/Client.dart';
import 'package:cosmo_care/Pages/Home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<Client?>(context);
    print(user);

    // Return either the Home or Authenticate widget
    return user == null ? Home() : Authenticate() ;
  }
}
