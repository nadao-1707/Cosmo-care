// ignore_for_file: prefer_const_constructors

import 'dart:io';
import 'package:cosmo_care/Entities/Client.dart';
import 'package:cosmo_care/Pages/MyCart.dart';
import 'package:cosmo_care/Services/ClientController.dart';
import 'package:flutter/material.dart';
import 'package:cosmo_care/Pages/BarCodeScanning.dart';
import 'package:cosmo_care/Pages/ChatBot.dart';
import 'package:cosmo_care/Pages/Home.dart';
import 'package:cosmo_care/Pages/Search.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  File? _image; // Variable to hold the selected image file
  late TextEditingController _emailController;
  late TextEditingController _usernameController;
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _skinTypeController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;
  late TextEditingController _cardNumberController;
  late TextEditingController _cvvController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _usernameController = TextEditingController();
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _skinTypeController = TextEditingController();
    _phoneController = TextEditingController();
    _addressController = TextEditingController();
    _cardNumberController = TextEditingController();
    _cvvController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _usernameController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _skinTypeController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _cardNumberController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  Future<Client?> _fetchClientData() async {
    ClientController clientController = ClientController();
    return await clientController.getClientData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFD1C4E9), // Background color
      appBar: AppBar(
        backgroundColor: Color(0xFFE1BEE7),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Go back to the previous page
          },
        ),
        title: Text('Edit Profile', style: TextStyle(color: Colors.black)),
      ),
      body: FutureBuilder<Client?>(
        future: _fetchClientData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return Center(child: Text('No data found'));
          } else {
            Client client = snapshot.data!;
            _emailController.text = client.email ?? '';
            _usernameController.text = client.username ?? '';
            _firstNameController.text = client.first_name ?? '';
            _lastNameController.text = client.last_name ?? '';
            _skinTypeController.text = client.skinType ?? '';
            _phoneController.text = client.phoneNumber?.toString() ?? '';
            _addressController.text = client.address ?? '';
            _cardNumberController.text = client.cardNumber ?? '';
            _cvvController.text = client.CVV?.toString() ?? '';

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: 20),
                    GestureDetector(
                      onTap: () {
                        _selectImage(); // Call function to select image
                      },
                      child: _image != null
                          ? CircleAvatar(
                              radius: 50,
                              backgroundImage: FileImage(_image!),
                            )
                          : Icon(Icons.photo, size: 150, color: Colors.black54),
                    ),
                    SizedBox(height: 20),
                    buildInputField(Icons.email, 'CHANGE EMAIL', _emailController, false),
                    SizedBox(height: 20),
                    buildInputField(Icons.person, 'CHANGE USERNAME', _usernameController, false),
                    SizedBox(height: 20),
                    buildInputField(Icons.person, 'FIRST NAME', _firstNameController, false),
                    SizedBox(height: 20),
                    buildInputField(Icons.person, 'LAST NAME', _lastNameController, false),
                    SizedBox(height: 20),
                    buildInputField(Icons.texture, 'SKIN TYPE', _skinTypeController, false),
                    SizedBox(height: 20),
                    buildInputField(Icons.phone, 'CHANGE PHONE', _phoneController, false),
                    SizedBox(height: 20),
                    buildInputField(Icons.home, 'ADDRESS', _addressController, false),
                    SizedBox(height: 20),
                    buildInputField(Icons.credit_card, 'CARD NUMBER', _cardNumberController, false),
                    SizedBox(height: 20),
                    buildInputField(Icons.security, 'CVV', _cvvController, false),
                    SizedBox(height: 40),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFFE1BEE7),
                          ),
                          onPressed: () {
                            Navigator.pop(context); // Go back to the previous page
                          },
                          child: Text('Cancel', style: TextStyle(color: Colors.black)),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFFE1BEE7),
                          ),
                          onPressed: () {
                            _saveProfileChanges(client);
                          },
                          child: Text('Save', style: TextStyle(color: Colors.black)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.black54,
        unselectedItemColor: Colors.black54,
        backgroundColor: Color(0xFFE1BEE7),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Chatbot',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.qr_code_scanner),
            label: 'Scan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
        ],
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Home()),
              );
              break;
            case 1:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ChatBot()),
              );
              break;
            case 2:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => BarCodeScanning()),
              );
              break;
            case 3:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MyCart()),
              );
              break;
            case 4:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Search()),
              );
              break;
          }
        },
      ),
    );
  }

  Widget buildInputField(
      IconData icon, String label, TextEditingController controller, bool obscureText) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          label,
          style: TextStyle(
            color: Colors.black54,
            fontSize: 12,
          ),
        ),
        SizedBox(height: 5),
        Container(
          decoration: BoxDecoration(
            color: Color(0xFFEDE7F6),
            borderRadius: BorderRadius.circular(10.0),
          ),
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          child: Row(
            children: <Widget>[
              Icon(icon, color: Colors.black54),
              SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: controller,
                  obscureText: obscureText,
                  decoration: InputDecoration(
                    hintText: label,
                    border: InputBorder.none,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

 void _saveProfileChanges(Client client) async {
  ClientController clientController = ClientController();
  await clientController.updateClientData(client); // Wait for update to complete
  
  _showSaveSuccessDialog();
}


  void _showSaveSuccessDialog() {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Success'),
        content: Text('Your profile changes have been saved successfully.'),
        actions: <Widget>[
          TextButton(
            child: Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

  void _selectImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _image = File(image.path);
      });
    }
  }
}
