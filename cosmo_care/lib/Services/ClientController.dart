import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cosmo_care/Entities/Client.dart';
import 'package:cosmo_care/Services/AuthService.dart';

class ClientController {
  late AuthService _authService;

  ClientController() {
    _authService = AuthService();
  }

  // to update client data
  Future<void> updateClientData({required Client client}) async {
    final uid = await _authService.getUserId();
    if (uid != null) {
      try {
        await FirebaseFirestore.instance.collection('clients').doc(uid).update(client.toFirestore());
      } catch (error) {
        print(error.toString());
      }
    } else {
      print('User ID not found');
    }
  }

}
