import 'package:cloud_firestore/cloud_firestore.dart';

class Cart {
  final List<String> productIds;

  Cart({required this.productIds});

  Map<String, dynamic> toFirestore() {
    return {
      'productIds': productIds,
    };
  }

  static Cart fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data()!;
    return Cart(
      productIds: List<String>.from(data['productIds']),
    );
  }
}
