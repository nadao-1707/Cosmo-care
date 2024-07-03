import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cosmo_care/Entities/Cart.dart';
import 'package:cosmo_care/Entities/Client.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // create client obj based on firebase user
  Client? _clientFromFirebaseUser(User? user) {
    return user != null ? Client(email: user.email) : null;
  }

  // to get currently signed in user id
  Future<String?> getUserId() async {
    User? user = _auth.currentUser;
    return user?.uid;
  }
  
  // to get currently signed in user's email
  Future<String?> getUserEmail() async {
  try {
    String? uid = await getUserId();
    if (uid != null) {
      DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance
          .collection('clients')
          .doc(uid)
          .get();

      if (snapshot.exists) {
        Client client = Client.fromFirestore(snapshot);
        return client.email;
      }
    }
    return null;
  } catch (error) {
    print(error.toString());
    return null;
  }
  }

  // to get currently signed in user's first name
  Future<String?> getUserName() async {
  try {
    String? uid = await getUserId();
    if (uid != null) {
      DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance
          .collection('clients')
          .doc(uid)
          .get();

      if (snapshot.exists) {
        Client client = Client.fromFirestore(snapshot);
        return client.first_name;
      }
    }
    return null;
  } catch (error) {
    print(error.toString());
    return null;
  }
  }

  Future<String?> getUserSkinType() async {
  try {
    String? uid = await getUserId();

    if (uid != null) {
      DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance
          .collection('clients')
          .doc(uid)
          .get();

      if (snapshot.exists) {
        Client client = Client.fromFirestore(snapshot);
        return client.skinType;
      }
    }
    return null;
  } catch (error) {
    print('Error fetching user skin type: $error');
    return null;
  }
}


  Future<String?> getUserUsername() async {
  try {
    String? uid = await getUserId(); // Assuming getUserId() fetches the user's ID correctly.
    if (uid != null) {
      print('Fetching document for UID: $uid');
      DocumentSnapshot<Map<String, dynamic>> snapshot =
          await FirebaseFirestore.instance.collection('clients').doc(uid).get();

      if (snapshot.exists) {
        Client client = Client.fromFirestore(snapshot);
        String? username = client.username;
        if (username != null) {
          print('Username found: $username');
          return username;
        } else {
          print('Username not found for user ID: $uid');
          throw Exception('Username not found for user ID: $uid');
        }
      } else {
        print('Document does not exist for user ID: $uid');
        throw Exception('Snapshot does not exist for user ID: $uid');
      }
    } else {
      print('User ID is null');
      throw Exception('User ID is null');
    }
  } catch (error) {
    print('Failed to fetch username: $error');
    throw Exception('Failed to fetch username');
  }
}
  

  // get current user
  Future<Client?> getCurrentUser() async {
    try {
      String? uid = await getUserId();
      if (uid != null) {
        DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance
            .collection('clients')
            .doc(uid)
            .get();

        if (snapshot.exists) {
          return Client.fromFirestore(snapshot);
        }
      }
      return null;
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  // sign in with email and password
  Future<Client?> SignInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User? user = result.user;
      return _clientFromFirebaseUser(user);
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

Future<Client?> SignUp(String email, String password, String username, String firstName, String lastName) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User? user = result.user;

      Client newClient = Client(
        email: email,
        username: username,
        first_name: firstName,
        last_name: lastName,
      );

      // Save client data to Firestore
      await FirebaseFirestore.instance
          .collection('clients')
          .doc(user?.uid)
          .withConverter<Client>(
            fromFirestore: (snapshot, _) => Client.fromFirestore(snapshot),
            toFirestore: (client, _) => client.toFirestore(),
          )
          .set(newClient);

      // Initialize a new cart for the user
      Cart newCart = Cart(
        productIds: [],
      );

      // Save cart data to Firestore
      await FirebaseFirestore.instance
          .collection('carts')
          .doc(user?.uid)
          .withConverter<Cart>(
            fromFirestore: (snapshot, _) => Cart.fromFirestore(snapshot),
            toFirestore: (cart, _) => cart.toFirestore(),
          )
          .set(newCart);

      return newClient;
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  // sign out
  Future<void> SignOut() async {
    try {
      return await _auth.signOut();
    } catch (error) {
      print(error.toString());
    }
  }

  Future<void> updatePass(String currentPassword ,String newPassword)
  async {
    User? user = _auth.currentUser;
    try {
      // Re-authenticate the user
      AuthCredential credential = EmailAuthProvider.credential(
        email: user!.email!,
        password: currentPassword,
      );
      await user.reauthenticateWithCredential(credential);

      // Update the password
      await user.updatePassword(newPassword);
      print('Password updated successfully');
    
    } catch (e) {
      print('Error updating password: $e');
      
    }
  }

}
