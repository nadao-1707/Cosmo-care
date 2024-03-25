import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cosmo_care/pages/SignIn.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import '../firebase_options.dart';
import '../controllers/AuthService.dart';

class Client{

  final String uid;
  // String? email;
  // String? username;
  // String? first_name;
  // String? last_name;
  // String? skinType;
  // int? telephone;

  //FirebaseFirestore db = FirebaseFirestore.instance;

  Client(this.uid);

  // factory User.fromFirestore(
  //     DocumentSnapshot<Map<String, dynamic>> snapshot,
  //     SnapshotOptions? options,
  //     ) {
  //   final data = snapshot.data();
  //   return User(data?['email'],
  //     data?['username'],
  //     data?['first_name'],
  //     data?['last_name'],
  //     data?['skinType'],
  //     data?['telephone'],
  //   );
  // }
  //
  // Map<String, dynamic> toFirestore() {
  //   return {
  //     if (email != null) "name": email,
  //     if (username != null) "country": username,
  //     if (first_name != null) "capital": first_name,
  //     if (skinType != null) "population": skinType,
  //     if (telephone != null) "regions": telephone,
  //   };
  //}

}