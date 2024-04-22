import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cosmo_care/Entities/Client.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // create client obj based on firebase user
  Client? _clientFromFirebaseUser(User? user) {
    return user != null ? Client(email: user.email) : null;
  }

  // auth change user stream
  Stream<Client?> get user {
    return _auth.authStateChanges().map(_clientFromFirebaseUser);
  }

  // to get currently signed in user id
  Future<String?> getUserId() async {
    User? user = _auth.currentUser;
    return user?.uid;
  }

  // sign in anon
  // Future<Client?> SignInAnon() async {
  //   try {
  //     UserCredential result = await _auth.signInAnonymously();
  //     User? user = result.user;
  //     return _clientFromFirebaseUser(user);
  //   } catch (e) {
  //     print(e.toString());
  //     return null;
  //   }
  // }

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

  // register with email and password
  Future<Client?> SignUpWithEmailAndPassword(String email, String password) async {
  try {
    UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
    User? user = result.user;
    // Create a new client
    Client newClient = Client(
      email: email,
    );
    // Write the client data to Firestore
    await FirebaseFirestore.instance
        .collection('clients')
        .doc(user?.uid)
        .withConverter<Client>(
          fromFirestore: Client.fromFirestore,
          toFirestore: (client, _) => client.toFirestore(),
        )
        .set(newClient);
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
}
