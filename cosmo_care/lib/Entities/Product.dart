import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String? name;
  final String? category;
  final String? requiredSkinType;
  final int? price;
  final String? description;
  final int? code;
  final List<String>? ingredients;
  double? averageRating; // Average rating of the product
  int? totalRatings; // Total number of ratings
  List<String>? reviews; // List of reviews


  Product({
    required this.name,
    required this.category,
    required this.requiredSkinType,
    required this.price,
    required this.description,
    required this.code,
    required this.ingredients,
    this.averageRating,
    this.totalRatings,
    this.reviews,
  });

  factory Product.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data();
    return Product(
      name: data?['name'],
      category : data?['category'],
      requiredSkinType : data?['requiredSkinType'],
      price: data?['price'],
      description: data?['description'],
      code: data?['code'],
      ingredients: data?['ingredients'] is List ? List<String>.from(data?['ingredients']) : null,
      averageRating: (data?['averageRating'] ?? 0.0).toDouble(),
      totalRatings: data?['totalRatings'],
      reviews: data?['reviews'] is List ? List<String>.from(data?['reviews']) : null,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (name != null) "name": name,
      if (category != null) "category": category,
      if (requiredSkinType != null) "requiredSkinType": requiredSkinType,
      if (price != null) "price": price,
      if (description != null) "description": description,
      if (code != null) "code": code,
      if (ingredients != null) "ingredients": ingredients,
      "averageRating": averageRating ?? 0.0, 
      "totalRatings": totalRatings ?? 0,
      if (reviews != null) "reviews": reviews,
    };
  }
}
