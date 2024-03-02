import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import '../firebase_options.dart';

class user{
  String email;
  String password;
  String username;
  String? first_name;
  String? last_name;
  String? skinType;
  int? telephone;

  user(this.email,this.password,this.username,this.first_name,this.last_name,this.skinType,this.telephone);

}