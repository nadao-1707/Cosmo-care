import 'dart:io';
import 'package:cosmo_care/Entities/Client.dart';
import 'package:cosmo_care/Pages/SkinProblem.dart';
import 'package:cosmo_care/Services/AuthService.dart';
import 'package:cosmo_care/Services/ClientController.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cosmo_care/Pages/Home.dart';
import 'package:cosmo_care/Pages/ChatBot.dart';
import 'package:cosmo_care/Pages/MyCart.dart';
import 'package:cosmo_care/Pages/Search.dart';
import 'package:cosmo_care/Pages/MyProfile.dart';
import 'package:cosmo_care/Pages/BarCodeScanning.dart';

class Model extends StatefulWidget {
  const Model({Key? key}) : super(key: key);

  @override
  _ModelState createState() => _ModelState();
}

class _ModelState extends State<Model> {
  final AuthService _authService = AuthService();
  final ClientController _controller = ClientController();
  File? _imageFile;
  String _prediction = '';
  final String baseUrl = 'http://10.0.2.2:5001'; // Adjust for your server's IP and port

  Future<void> _getImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png'],
    );

    if (result != null) {
      setState(() {
        _imageFile = File(result.files.single.path!);
      });
    }
  }

  Future<void> _predictSkinType() async {
    if (_imageFile == null) {
      _showImageRequiredAlert();
      return;
    }

    try {
      final prediction = await uploadImage(_imageFile!);
      var userId = await _authService.getUserId();
      if (userId?.isNotEmpty ?? false) {
        await _controller.updateClientData(
          client: Client(skinType: prediction),
        );
      }
      setState(() {
        _prediction = 'Predicted Skin Type: $prediction';
      });
    } catch (e) {
      setState(() {
        _prediction = 'Error: $e';
      });
    }
  }

  void _showImageRequiredAlert() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Upload Image Required'),
          content: Text('Please upload an image before predicting.'),
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

  void _showPredictFirstAlert() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Predict Skin Type First'),
          content: Text('Please upload your image and press "Predict Skin Type" first.'),
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

  Future<String> uploadImage(File imageFile) async {
    final url = Uri.parse('$baseUrl/predict');
    final request = http.MultipartRequest('POST', url)
      ..files.add(await http.MultipartFile.fromPath('file', imageFile.path));

    final response = await request.send();
    final responseBody = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(responseBody);
      return jsonResponse['prediction']; // Ensure this key matches the Flask response
    } else {
      throw Exception('Failed to predict skin type');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD1C4E9),
      appBar: AppBar(
        backgroundColor: const Color(0xFFE1BEE7),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Go back to the previous page
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              backgroundImage: AssetImage('assets/images/login_image-removebg-preview.png'), 
            ),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Upload Your Image Here',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ElevatedButton(
                  onPressed: _getImage,
                  child: const Text('Select Image'),
                ),
                const SizedBox(height: 16.0),
                _imageFile != null
                    ? Image.file(
                        _imageFile!,
                        height: 200,
                      )
                    : const SizedBox(),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: _predictSkinType,
                  child: const Text('Predict Skin Type'),
                ),
                const SizedBox(height: 16.0),
                Text(_prediction),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () {
                    if (_imageFile == null || _prediction.isEmpty) {
                      _showPredictFirstAlert();
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SkinProblem()),
                      );
                    }
                  },
                  child: const Text('Specify Your Skin Problem'),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.black54,
        unselectedItemColor: Colors.black54,
        backgroundColor: const Color(0xFFE3CCE1),
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
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Home()),
              );
              break;
            case 1:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ChatBot()),
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
                MaterialPageRoute(builder: (context) => const MyCart()),
              );
              break;
            case 4:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Search()),
              );
              break;
            case 5:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MyProfile()),
              );
              break;
          }
        },
      ),
    );
  }
}
