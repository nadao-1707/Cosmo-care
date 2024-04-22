import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cosmo_care/pages/SignIn.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import '../firebase_options.dart';
import '../controllers/AuthService.dart';

class Client{

  final String? email;
  final String? username;
  final String? first_name;
  final String? last_name;
  final String? skinType;
  final int? telephone;
  final String? address;

  Client({this.email, this.username, this.first_name, this.last_name, this.skinType, this.telephone, this.address});

  factory Client.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options,) {
    final data = snapshot.data();
    return Client (
      email: data?['email'],
      username: data?['username'],
      first_name: data?['first_name'],
      last_name: data?['last_name'],
      skinType: data?['skinType'],
      telephone: data?['telephone'],
      address: data?['address'],
    );
  }
  
  Map<String, dynamic> toFirestore() {
    return {
      if (email != null) "email": email,
      if (username != null) "username": username,
      if (first_name != null) "first_name": first_name,
      if (last_name != null) "last_name": last_name,
      if (skinType != null) "skinType": skinType,
      if (telephone != null) "telephone": telephone,
      if (address != null) "address": address,
    };
  }

}