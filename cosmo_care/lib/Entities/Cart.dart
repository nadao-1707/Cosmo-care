import 'package:cloud_firestore/cloud_firestore.dart';

class Cart {
  final Map<String, int> productQuantities;

  Cart({required this.productQuantities});

  Map<String, dynamic> toFirestore() {
    return {
      'productQuantities': productQuantities,
    };
  }

  static Cart fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data()!;
    return Cart(
      productQuantities: Map<String, int>.from(data['productQuantities']),
    );
  }
}
