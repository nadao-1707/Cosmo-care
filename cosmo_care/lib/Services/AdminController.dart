import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cosmo_care/Entities/Product.dart';

class AdminController {

  AdminController() {}

  // to add a new Product data
  Future<void> addProduct({required Product product}) async {
    try {
      await FirebaseFirestore.instance
          .collection('Products')
          .doc()
          .set(product.toFirestore());
      return; 
    } catch (error) {
      print(error.toString());
      return;
    }
  }
}
