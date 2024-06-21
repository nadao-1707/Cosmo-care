import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cosmo_care/Entities/Cart.dart';
import 'package:cosmo_care/Entities/Client.dart';
import 'package:cosmo_care/Services/AuthService.dart';

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


  
}