import 'package:cloud_firestore/cloud_firestore.dart';

class Client {
  final String? email;
  final String? password;
  final String? username;
  final String? first_name;
  final String? last_name;
  final String? skinType;
  final int? telephone;
  final String? address;

  Client({
    this.email,
    this.password,
    this.username,
    this.first_name,
    this.last_name,
    this.skinType,
    this.telephone,
    this.address,
  });

  factory Client.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot, {
    SnapshotOptions? options,
  }) {
    final data = snapshot.data();
    return Client(
      email: data?['email'],
      password: data?['password'],
      username: data?['username'],
      first_name: data?['first_name'],
      last_name: data?['last_name'],
      skinType: data?['skinType'],
      telephone: data?['telephone'],
      address: data?['address'],
    );
  }
  
  Map<String, dynamic> toFirestore() {
    return {
      if (email != null) "email": email,
      if (password != null) "password": password,
      if (username != null) "username": username,
      if (first_name != null) "first_name": first_name,
      if (last_name != null) "last_name": last_name,
      if (skinType != null) "skinType": skinType,
      if (telephone != null) "telephone": telephone,
      if (address != null) "address": address,
    };
  }
  Future<List<String>> getClientUsernames() async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  List<String> usernames = [];

  try {
    QuerySnapshot<Map<String, dynamic>> snapshot = await firestore.collection('Clients').get();

    for (var doc in snapshot.docs) {
      final client = Client.fromFirestore(doc);
      if (client.username != null) {
        usernames.add(client.username!);
      }
    }

    return usernames;
  } catch (e) {
    print('Error fetching client usernames: $e');
    return [];
  }
}

}
