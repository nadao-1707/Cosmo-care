import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cosmo_care/Entities/Product.dart';

class AdminController {

  AdminController() {}

  // add a new Product data
  Future<String> addProduct({required Product product}) async {
  try {
    await FirebaseFirestore.instance.collection('Products').doc().set(product.toFirestore());
    return "Product added successfully.";
  } catch (error) {
    return "Failed to add product.";
  }
  }


  // delete a product using the product name
  Future<String> deleteProduct(String name) async {
  try {
    FirebaseFirestore db = FirebaseFirestore.instance;
    final productCollection = db.collection("products");
    var snapshot = await productCollection.where("name", isEqualTo: name).get();
    if (snapshot.docs.isNotEmpty) {
      for (var doc in snapshot.docs) {
        await productCollection.doc(doc.id).delete();
      }
      return "Product deleted successfully.";
    } else {
      return "No product found with the given name.";
    }
  } catch (e) {
    print("Error deleting product: $e");
    return "Failed to delete product.";
  }
  }


}