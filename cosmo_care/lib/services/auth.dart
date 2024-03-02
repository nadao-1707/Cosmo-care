import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import '../firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';


//firebase authentication
class authService {
  FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> signUpWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      return credential.user;
    }
    catch (e) {
      print(e.toString());
      return null;
    }
    // if (e.code == 'email-already-in-use') {
    //   showToast(message: 'The email address is already in use.');
    // } else {
    //   showToast(message: 'An error occurred: ${e.code}');
    // }
    //return null;
  }

  Future<User?> signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(email: email, password: password);
      return credential.user;
    }
    catch (e) {
      print(e.toString());
      return null;
    }
    //   if (e.code == 'user-not-found' || e.code == 'wrong-password') {
    //     showToast(message: 'Invalid email or password.');
    //   } else {
    //     showToast(message: 'An error occurred: ${e.code}');
    //   }
    // }
    // return null;
  }

  Future signOut() async {
    try {
      return await _auth.signOut();
    }
    catch (e) {
      print(e.toString());
      return null;
    }
  }

}