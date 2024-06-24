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
  Future<String> deleteUser(String UserId) async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  DocumentReference documentReference = firestore.collection('clients').doc(UserId);
  try {
    await documentReference.delete();
    return 'User deleted successfully';
  } catch (e) {
    return 'Error deleting User: $e';
  }
}
Future<List<Map<String, dynamic>>> fetchRecommendations() async {
    List<Map<String, dynamic>> recommendationsList = [];
    FirebaseFirestore firestore = FirebaseFirestore.instance;
     try {
      QuerySnapshot querySnapshot = await firestore
          .collection('recommendations')
          .where('status', isEqualTo: 'pending')
          .get();

      for (var doc in querySnapshot.docs) {
        String recommendationName = doc['recommendationName'];
        String username = doc['username'];

        recommendationsList.add({
          'recommendationName': recommendationName,
          'username': username,
        });
      }
    } catch (e) {
      print('Error fetching pending recommendations: $e');
    }
    return recommendationsList;
  }

  //Accept reccomendation
   Future<String> acceptRecommendation(String docId, {required Product product, required File imageFile}) async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  try {
    DocumentReference docRef = firestore.collection('recommendations').doc(docId);
    await docRef.update({
      'status': 'accepted',
    });

    // Call the addProduct function and await its result
    String productId = await addProduct(product: product, imageFile: imageFile);
    return 'Document updated successfully to accepted status for docId: $docId. Product added with id: $productId';
  } catch (e) {
    return 'Error updating document status: $e';
  }
}

  //Reject reccomendation
   Future<String> rejectRecommendation(String docId) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    try {
      DocumentReference docRef = firestore.collection('recommendations').doc(docId);
      await docRef.update({
        'status': 'not accepted',
      });

      return 'Document updated successfully to not accepted status for docId: $docId';
    } catch (e) {
      return 'Error updating document status: $e';
    }
  }
  

//update product info
Future<String> updateProductName(String productId, String newName) async {
  try {
    DocumentReference productRef = FirebaseFirestore.instance.collection('Products').doc(productId);

    await productRef.update({'name': newName});
    return 'Product name updated successfully.';
  } catch (e) {
    return 'Failed to update product name: $e';
  }
}

Future<String> updateProductCategory(String productId, String newCategory) async {
  try {
    DocumentReference productRef = FirebaseFirestore.instance.collection('Products').doc(productId);

    await productRef.update({'category': newCategory});
    return 'Product category updated successfully.';
  } catch (e) {
    return 'Failed to update product category: $e';
  }
}

Future<String> updateRequiredSkinType(String productId, String newSkinType) async {
  try {
    DocumentReference productRef = FirebaseFirestore.instance.collection('Products').doc(productId);

    await productRef.update({'requiredSkinType': newSkinType});
    return 'Product required skin type updated successfully.';
  } catch (e) {
    return 'Failed to update product required skin type: $e';
  }
}

Future<String> updateProductPrice(String productId, int newPrice) async {
  try {
    DocumentReference productRef = FirebaseFirestore.instance.collection('Products').doc(productId);

    await productRef.update({'price': newPrice});
    return 'Product price updated successfully.';
  } catch (e) {
    return 'Failed to update product price: $e';
  }
}

Future<String> updateDescription(String productId, String newDescription) async {
    try {
      DocumentReference productRef = FirebaseFirestore.instance.collection('Products').doc(productId);

      await productRef.update({'description': newDescription});
      return 'Product description updated successfully.';
    } catch (e) {
      return 'Failed to update product description: $e';
    }
}

Future<String> updateProductCode(String productId, int newCode) async {
  try {
    DocumentReference productRef = FirebaseFirestore.instance.collection('Products').doc(productId);

    await productRef.update({'code': newCode});
    return 'Product code updated successfully.';
  } catch (e) {
    return 'Failed to update product code: $e';
  }
}

Future<String> updateIngredients(String productId, List<String> newIngredients) async {
    try {
      DocumentReference productRef = FirebaseFirestore.instance.collection('Products').doc(productId);

      await productRef.update({'ingredients': newIngredients});
      return 'Ingredients updated successfully.';
    } catch (e) {
      return 'Failed to update ingredients: $e';
    }
}
static Future<List<Product>> listAllProducts() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot =
          await firestore.collection('Products').get();

      List<Product> products = snapshot.docs.map((doc) => Product.fromFirestore(doc)).toList();
      return products;
    } catch (e) {
      // Handle error if any
      return [];
    }
  }
  static Future<List<String>?> getProductInfoById(String productId) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot = await firestore
          .collection('Products')
          .doc(productId)
          .get();

      if (snapshot.exists) {
        Map<String, dynamic>? data = snapshot.data();
        if (data != null) {
          String name = data['name'] ?? '';
          String category = data['category'] ?? '';
          String requiredSkinType = data['requiredSkinType'] ?? '';
          int price = data['price'] ?? 0;
          String description = data['description'] ?? '';
          int code = data['code'] ?? 0;
          List<String>? ingredients = data['ingredients'] is List ? List<String>.from(data['ingredients']) : null;
          double averageRating = (data['averageRating'] ?? 0.0).toDouble();
          int totalRatings = data['totalRatings'] ?? 0;
          List<String>? reviews = data['reviews'] is List ? List<String>.from(data['reviews']) : null;

          List<String> productInfo = [
            'Name: $name',
            'Category: $category',
            'Required Skin Type: $requiredSkinType',
            'Price: $price',
            'Description: $description',
            'Code: $code',
            'Ingredients: ${ingredients ?? []}',
            'Average Rating: $averageRating',
            'Total Ratings: $totalRatings',
            'Reviews: ${reviews ?? []}',
          ];

          return productInfo;
        } else {
          print('Error: Data is null for product with ID $productId.');
          return null;
        }
      } else {
        print('Product with ID $productId does not exist.');
        return null;
      }
    } catch (e) {
      // Handle error if any
      print('Error fetching product: $e');
      return null;
    }
  }
  //list user info
  Future<Map<String, dynamic>?> getClientFieldsByUsername(String username) async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  try {
    DocumentSnapshot<Map<String, dynamic>> snapshot = await firestore
        .collection('Clients')
        .doc(username)
        .get();

    if (snapshot.exists) {
      Map<String, dynamic> data = snapshot.data()!;
      
      // Remove 'password' field from data
      data.remove('password');

      return data;
    } else {
      print('Client with username $username does not exist.');
      return null;
    }
  } catch (e) {
    print('Error fetching client fields: $e');
    return null;
  }
}

}