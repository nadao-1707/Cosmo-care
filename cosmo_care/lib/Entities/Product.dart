import 'package:cloud_firestore/cloud_firestore.dart';

class Product{

  final String? name;
  final int? price;
  final String? description;
  final int? code;
  final List<String>? ingrediants;

  Product({required this.name,required this.price,required this.description,required this.code,required this.ingrediants});

  factory Product.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options,) {
    final data = snapshot.data();
    return Product (
      name: data?['name'],
      price: data?['price'],
      description: data?['description'],
      code: data?['code'],
      ingrediants:
          data?['ingrediants'] is Iterable ? List.from(data?['ingrediants']) : null,
    );
  }
  
  Map<String, dynamic> toFirestore() {
    return {
      if (name != null) "name": name,
      if (price != null) "price": price,
      if (description != null) "description": description,
      if (code != null) "code": code,
      if (ingrediants != null) "ingrediants": ingrediants, 
    };
  }
}