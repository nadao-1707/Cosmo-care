// ignore_for_file: unnecessary_null_comparison

import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String name;
  final String imgURL;
  final String? category;
  final List<String>? requiredSkinType;
  final int price;
  final String? description;
  final String? howToUse;
  final String? code;
  final String? ingredients;
  double? averageRating; // Average rating of the product
  int? totalRatings; // Total number of ratings
  List<String>? reviews; // List of reviews
  final List<String>? problems;


  Product({
    required this.name,
    required this.imgURL,
    required this.category,
    required this.howToUse,
    required this.requiredSkinType,
    required this.price,
    required this.description,
    required this.code,
    required this.ingredients,
    required this.problems,
    this.averageRating,
    this.totalRatings,
    this.reviews,
  });

  factory Product.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data();
    return Product(
      name: data?['name'],
      imgURL: data?['imgURL'],
      howToUse: data?['howToUse'],
      category : data?['category'],
      requiredSkinType: data?['requiredSkinType'] is List ? List<String>.from(data?['requiredSkinType']) : null,
      price: data?['price'],
      description: data?['description'],
      code: data?['code'],
      ingredients: data?['ingredients'] ,
      problems: data?['problems'] is List ? List<String>.from(data?['problems']) : null,
      averageRating: (data?['averageRating'] ?? 0.0).toDouble(),
      totalRatings: data?['totalRatings'],
      reviews: data?['reviews'] is List ? List<String>.from(data?['reviews']) : null,
    );
  }
  Map<String, dynamic> toFirestoreForE() {
    return {
      if (name != null) "name": name,
      if (imgURL != null) "imgURL": imgURL,
      if (howToUse != null) "howToUse": howToUse,
      if (category != null) "category": category,
      if (requiredSkinType != null) "requiredSkinType": requiredSkinType,
      if (price != null) "price": price,
      if (description != null) "description": description,
      if (code != null) "code": code,
      if (ingredients != null) "ingredients": ingredients,
      if (problems != null) "problems": problems,
    };
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (name != null) "name": name,
      if (imgURL != null) "imgURL": imgURL,
      if (howToUse != null) "howToUse": howToUse,
      if (category != null) "category": category,
      if (requiredSkinType != null) "requiredSkinType": requiredSkinType,
      if (price != null) "price": price,
      if (description != null) "description": description,
      if (code != null) "code": code,
      if (ingredients != null) "ingredients": ingredients,
      "averageRating": averageRating ?? 0.0, 
      "totalRatings": totalRatings ?? 0,
      if (reviews != null) "reviews": reviews,
      if (problems != null) "problems": problems,
    };
  }
  
}
