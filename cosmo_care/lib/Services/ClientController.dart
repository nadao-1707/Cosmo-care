import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cosmo_care/Entities/Cart.dart';
import 'package:cosmo_care/Entities/Client.dart';
import 'package:cosmo_care/Entities/Product.dart';
import 'package:cosmo_care/Services/AuthService.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ClientController {
  late AuthService _authService;

  ClientController() {
    _authService = AuthService();
  }

  // update client data
  Future<String> updateClientData({required Client client}) async {
  final uid = await _authService.getUserId();
  if (uid != null) {
    try {
      await FirebaseFirestore.instance.collection('clients').doc(uid).update(client.toFirestore());
      return "Client data updated successfully.";
    } catch (error) {
      return "Failed to update client data.";
    }
  } else {
    return "User ID not found.";
  }
  }

  // get client data for the profile
  Future<Client?> getClientData() async {
    try {
      final uid = await _authService.getUserId();
      if (uid != null) {
         DocumentSnapshot<Map<String, dynamic>> doc = await FirebaseFirestore.instance.collection('clients').doc(uid).get();
        if (doc.exists) {
          Client client = Client.fromFirestore(doc);
          return client;
        } else {
          print("Client data not found.");
          return null;
        }
      } else {
        print("User ID not found.");
        return null;
      }
    } catch (error) {
      print("Error getting client data: $error");
      return null;
    }
  }

  //list cart contents by user id
  static Future<List<Product>> listCartContents(String userId) async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  try {
    DocumentSnapshot<Map<String, dynamic>> snapshot = await firestore
        .collection('carts')
        .doc(userId)
        .get();

    if (snapshot.exists) {
      Cart cart = Cart.fromFirestore(snapshot);
      List<String> productIds = cart.productIds;
      List<Product> products = [];

      for (String productId in productIds) {
        DocumentSnapshot<Map<String, dynamic>> productSnapshot = await firestore
            .collection('products')
            .doc(productId)
            .get();

        if (productSnapshot.exists) {
          Product product = Product.fromFirestore(productSnapshot);
          products.add(product);
        } else {
          print('Product document with ID $productId does not exist.');
        }
      }

      return products;
    } else {
      print('Cart document with ID does not exist.');
      return [];
    }
  } catch (e) {
    print('Error fetching cart: $e');
    return [];
  }
}

  Future<String> getProductID(String name) async {
  try {
    CollectionReference productsCollection = FirebaseFirestore.instance.collection('products');
    QuerySnapshot querySnapshot = await productsCollection.where('name', isEqualTo: name).get();
    if (querySnapshot.size == 1) {
      return querySnapshot.docs[0].id;
    } else {
      throw 'Error: Found ${querySnapshot.size} documents with name $name';
    }
  } catch (error) {
    print('Error getting product ID: $error');
    rethrow;
  }
}

  // add to cart
  Future<void> addToCart(String productId) async {
  try {
    final uid = await _authService.getUserId();
    DocumentReference<Cart> cartRef = FirebaseFirestore.instance
        .collection('carts')
        .doc(uid)
        .withConverter<Cart>(
          fromFirestore: (snapshot, _) => Cart.fromFirestore(snapshot),
          toFirestore: (cart, _) => cart.toFirestore(),
        );

    DocumentSnapshot<Cart> snapshot = await cartRef.get();

    if (!snapshot.exists) {
      Cart newCart = Cart(productIds: [productId]);
      await cartRef.set(newCart);
    } else {
      Cart cart = snapshot.data()!;
      if (!cart.productIds.contains(productId)) {
        cart.productIds.add(productId);
        await cartRef.set(cart);
      }
    }
  } catch (error) {
    print("Failed to add product to cart: $error");
  }
  }

  // remove from cart
  Future<void> removeFromCart(String productId) async {
  try {
    final uid = await _authService.getUserId();
    DocumentReference<Cart> cartRef = FirebaseFirestore.instance
        .collection('carts')
        .doc(uid)
        .withConverter<Cart>(
          fromFirestore: (snapshot, _) => Cart.fromFirestore(snapshot),
          toFirestore: (cart, _) => cart.toFirestore(),
        );

    DocumentSnapshot<Cart> snapshot = await cartRef.get();

    if (snapshot.exists) {
      Cart cart = snapshot.data()!;
      if (cart.productIds.contains(productId)) {
        cart.productIds.remove(productId);
        await cartRef.set(cart);
      }
    }
  } catch (error) {
    print("Failed to remove product from cart: $error");
  }
  }

  Future<void> emptyCart() async {
    try {
      String? userId = await _authService.getUserId();
      if (userId != null) {
        // Create an empty cart object
        Cart emptyCart = Cart(
          productIds: [],
        );

        // Update Firestore with the empty cart
        await FirebaseFirestore.instance
            .collection('carts')
            .doc(userId)
            .withConverter<Cart>(
              fromFirestore: (snapshot, _) => Cart.fromFirestore(snapshot),
              toFirestore: (cart, _) => cart.toFirestore(),
            )
            .set(emptyCart);
      } else {
        throw Exception('User ID is null');
      }
    } catch (error) {
      print('Error emptying cart: $error');
      rethrow; // Propagate the error to handle it in UI if needed
    }
  }

  Future<List<Product>> fetchProductsBySkinType() async {
  try {
    String? skinType = await _authService.getUserSkinType();

    // Fetch products from Firestore where skinType matches
    QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance
        .collection('products')
        .where('requiredSkinType', isEqualTo: skinType)
        .get();

    QuerySnapshot<Map<String, dynamic>> snapshotAll = await FirebaseFirestore.instance
        .collection('products')
        .where('requiredSkinType', isEqualTo: 'All')
        .get();

    // Combine both snapshots into a single list of DocumentSnapshot
    List<QueryDocumentSnapshot<Map<String, dynamic>>> combinedList =
        [...snapshot.docs, ...snapshotAll.docs];

    // Convert QueryDocumentSnapshot to a list of Product objects
    List<Product> products = combinedList.map((doc) => Product.fromFirestore(doc)).toList();

    return products;
  } catch (e) {
    print('Error fetching products: $e');
    return [];
  }
}


  // add review and rating (update average and total rating)
  Future<void> addRatingAndReview(String productId, int rating, String review) async {
    try {
      final CollectionReference<Product> productsRef = FirebaseFirestore.instance
      .collection('products')
      .withConverter<Product>(
      fromFirestore: (snapshot, _) => Product.fromFirestore(snapshot),
      toFirestore: (product, _) => product.toFirestore(),
      );
      DocumentReference<Product> productDocRef = productsRef.doc(productId);

      DocumentSnapshot<Product> snapshot = await productDocRef.get();

      if (snapshot.exists) {
        Product product = snapshot.data()!;
        product.reviews ??= [];
        product.reviews!.add(review);

        double newAverageRating = ((product.averageRating ?? 0) * (product.totalRatings ?? 0) + rating) /
            ((product.totalRatings ?? 0) + 1);

        product.averageRating = newAverageRating;
        product.totalRatings = (product.totalRatings ?? 0) + 1;

        await productDocRef.set(product);
      } else {
        throw Exception('Product not found.');
      }
    } catch (error) {
      print('Failed to add rating and review: $error');
      rethrow;
    }
  }

  // retrieve all the product info
  Future<Product?> getProduct(String productId) async {
    try {
      final CollectionReference<Product> productsRef =
      FirebaseFirestore.instance.collection('products').withConverter<Product>(
            fromFirestore: (snapshot, _) => Product.fromFirestore(snapshot),
            toFirestore: (product, _) => product.toFirestore(),
          );
      DocumentReference<Product> productDocRef = productsRef.doc(productId);
      DocumentSnapshot<Product> snapshot = await productDocRef.get();
      if (snapshot.exists) {
        return snapshot.data();
      } else {
        print('Product not found');
        return null;
      }
    } catch (error) {
      print('Failed to fetch product: $error');
      return null;
    }
  }

  //client controller
  //return products pictures from storage
  Future<List<String>> listPhotosByCategory(String category) async {
    final FirebaseStorage storage = FirebaseStorage.instance;
    List<String> photoUrls = [];
    final ListResult result = await storage.ref('/product_images').listAll();
    
    for (var item in result.items) {
      if (item.name.contains(category)) {
        final String downloadUrl = await item.getDownloadURL();
        photoUrls.add(downloadUrl);
      }
    }
    return photoUrls;
  }

  //get products by category
  Future<List<Map<String, dynamic>>> listProductsByCategory(String category) async {
  FirebaseFirestore firestore = FirebaseFirestore.instance; 
  List<String> photos = listPhotosByCategory(category) as List<String>;
  List<Map<String, dynamic>> products = [];

  QuerySnapshot querySnapshot = await firestore
      .collection('products')
      .where('category', isEqualTo: category)
      .get();

  for (var doc in querySnapshot.docs) {
    String productName = doc['name'];
    // Find a photo that matches the product name (assuming photo file names are product names)
    String? productPhoto = photos.firstWhere(
      (photo) => photo.contains(productName),
      orElse: () => "null",
    );
    
    products.add({
      'name': productName,
      'price': doc['price'],
      'photo': productPhoto, // Add a default photo URL if no match is found
    });
  }
  return products;
}

Future<List<List<String>>> SearchProductByName(String name) async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseStorage storage = FirebaseStorage.instance;
  List<List<String>> listOfsearchedProducts = [];

  // Fetch products with the specified name from Firestore
  QuerySnapshot querySnapshot = await firestore
      .collection('products')
      .where('name', isEqualTo: name)
      .get();

  // Fetch all items (photos) from the specified folder in Firebase Storage
  final ListResult result = await storage.ref('/product_images').listAll();

  // Loop over each product from Firestore
  for (var doc in querySnapshot.docs) {
    String productName = doc['name'];
    String productPrice = doc['price'].toString(); 

    // Loop over each photo from Firebase Storage
    for (var item in result.items) {
      if (item.name.contains(productName)) {
        final String downloadUrl = await item.getDownloadURL();
        listOfsearchedProducts.add([productName, productPrice, downloadUrl]);
      }
    }
  }
  return listOfsearchedProducts;
  }
  
   // get product info
  Future<List<List<String>>> listProductInfoByName(String name) async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseStorage storage = FirebaseStorage.instance;
  List<List<String>> listOfsearchedProducts = [];

  QuerySnapshot querySnapshot = await firestore
      .collection('products')
      .where('name', isEqualTo: name)
      .get();

  final ListResult result = await storage.ref('/product_images').listAll();

  for (var doc in querySnapshot.docs) {
    String productName = doc['name'];
    String productPrice = doc['price'].toString();
    String category = doc['category'];
    String requiredSkinType = doc['requiredSkinType'];
    String description = doc['description'];
    String code = doc['code'];
    String ingredients = doc['ingredients'];
    String reviews = doc['reviews'];
    String averageRating = doc['averageRating'].toString();

    for (var item in result.items) {
      if (item.name.contains(productName)) {
        final String downloadUrl = await item.getDownloadURL();
        listOfsearchedProducts.add([
          productName,
          productPrice,
          category,
          requiredSkinType,
          description,
          code,
          ingredients,
          reviews,
          averageRating,
          downloadUrl
        ]);
      }
    }
  }
  return listOfsearchedProducts;
}
  
//get by barcode
Future<List<List<String>>> listProductInfoByCode(String code) async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseStorage storage = FirebaseStorage.instance;
  List<List<String>> listOfsearchedProducts = [];

  // Fetch products with the specified code from Firestore
  QuerySnapshot querySnapshot = await firestore
      .collection('products')
      .where('code', isEqualTo: code)
      .get();

  // Fetch all items (photos) from the specified folder in Firebase Storage
  final ListResult result = await storage.ref('/product_images').listAll();

  // Loop over each product from Firestore
  for (var doc in querySnapshot.docs) {
    String productName = doc['name'];
    String productPrice = doc['price'].toString();
    String category = doc['category'];
    String requiredSkinType = doc['requiredSkinType'];
    String description = doc['description'];
    String ingredients = doc['ingredients'];
    String reviews = doc['reviews'];
    String averageRating = doc['averageRating'].toString();

    // Loop over each photo from Firebase Storage
    for (var item in result.items) {
      if (item.name.contains(productName)) {
        final String downloadUrl = await item.getDownloadURL();
        listOfsearchedProducts.add([
          productName,
          productPrice,
          category,
          requiredSkinType,
          description,
          code,
          ingredients,
          reviews,
          averageRating,
          downloadUrl
        ]);
      }
    }
  }
  return listOfsearchedProducts;
}

//filter by categories
 static Future<List<List<String>>> feltirProductsByCategories(List<String> categories) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot = await firestore
          .collection('Products')
          .where('category', whereIn: categories)
          .get();

      List<List<String>> productsArray = snapshot.docs.map((doc) {
        Product product = Product.fromFirestore(doc);
        return [
          product.name ?? '',
          product.category ?? '',
          product.requiredSkinType ?? '',
          product.price.toString() ?? '',
          product.description ?? '',
          product.code?.toString() ?? '',
          product.ingredients?.join(', ') ?? '',
          product.averageRating?.toString() ?? '',
          product.totalRatings?.toString() ?? '',
          product.reviews?.join(', ') ?? '',
        ];
      }).toList();

      return productsArray;
    } catch (e) {
      // Handle error if any
      return [];
    }
  }
}