import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cosmo_care/Entities/Product.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AdminController {

  Future<String> addProduct({required Product product, required File imageFile}) async {
    try {
      DocumentReference docRef = await FirebaseFirestore.instance.collection('Products').add(product.toFirestore());
      String fileName = '${docRef.id}.png';
      Reference storageRef = FirebaseStorage.instance.ref().child('product_images').child(fileName);
      await storageRef.putFile(imageFile);
      String imageUrl = await storageRef.getDownloadURL();
      await docRef.update({'imageUrl': imageUrl});
      return docRef.id;
    } catch (error) {
      print("Failed to add product: $error");
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