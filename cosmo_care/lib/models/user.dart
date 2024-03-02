import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import '../firebase_options.dart';

class user{
  String? email;
  String? password;
  String? username;
  String? first_name;
  String? last_name;
  String? skinType;
  int? telephone;

  FirebaseFirestore db = FirebaseFirestore.instance;

  user(this.email,this.password,this.username,this.first_name,this.last_name,this.skinType,this.telephone);

  factory user.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options,
      ) {
    final data = snapshot.data();
    return user(data?['email'],
      data?['password'],
      data?['username'],
      data?['first_name'],
      data?['last_name'],
      data?['skinType'],
      data?['telephone'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (email != null) "name": email,
      if (password != null) "state": password,
      if (username != null) "country": username,
      if (first_name != null) "capital": first_name,
      if (skinType != null) "population": skinType,
      if (telephone != null) "regions": telephone,
    };
  }

}