import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cosmo_care/Entities/Product.dart';

class AdminController {

  AdminController() {}

  // to add a new Product data
  Future<void> addProduct({required Product product}) async {
    try {
      await FirebaseFirestore.instance.collection('Products').doc().set(product.toFirestore());
      return; 
    } catch (error) {
      print(error.toString());
      return;
    }
  }


  // to delete a product using the product name
  Future<void> deleteProduct(String name) async {
    try {
      FirebaseFirestore db = FirebaseFirestore.instance;
      final productCollection = db.collection("products");
      var snapshot = await productCollection.where("name", isEqualTo: name).get();
      if (snapshot.docs.isNotEmpty) {
        for (var doc in snapshot.docs) {
          await productCollection.doc(doc.id).delete();
        }
        print("Product deleted successfully.");
      } else {
        print("No product found with the given name.");
      }
    } catch (e) {
      print("Error deleting product: $e");
    }
  }


}
