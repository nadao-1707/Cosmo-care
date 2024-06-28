import 'package:cosmo_care/Entities/Client.dart';
import 'package:cosmo_care/Services/AuthService.dart';
import 'package:flutter/material.dart';
import 'package:cosmo_care/Services/ClientController.dart';
import 'package:cosmo_care/Pages/Recommendation.dart';
import 'package:cosmo_care/Pages/Home.dart';
import 'package:cosmo_care/Pages/ChatBot.dart';
import 'package:cosmo_care/Pages/BarCodeScanning.dart';
import 'package:cosmo_care/Pages/MyCart.dart';
import 'package:cosmo_care/Pages/Search.dart';
import 'package:cosmo_care/Pages/MyProfile.dart';

class SkinTypeTest extends StatefulWidget {
  const SkinTypeTest({super.key});

  @override
  _SkinTypeTestState createState() => _SkinTypeTestState();
}

class _SkinTypeTestState extends State<SkinTypeTest> {
  late ClientController _clientController;
  late AuthService _authService;
  bool isDry = false;
  bool isOily = false;
  bool isNormal = false;
  bool isCombination = false;
  bool isSensitive = false;

  @override
  void initState() {
    super.initState();
    _clientController = ClientController();
    _authService = AuthService();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFCDB7EB), // Background color
      appBar: AppBar(
        backgroundColor: const Color(0xFFE3CCE1),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Go back to the previous page
          },
        ),
        title: const Text('Skin Type Test', style: TextStyle(color: Colors.black)),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MyProfile()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'SKIN TYPE TEST',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            CheckboxListTile(
              title: const Text("DRY"),
              value: isDry,
              onChanged: (bool? value) {
                setState(() {
                  isDry = value!;
                  if (isDry) {
                    isOily = false;
                    isNormal = false;
                    isCombination = false;
                    isSensitive = false;
                  }
                });
              },
            ),
            CheckboxListTile(
              title: const Text("OILY"),
              value: isOily,
              onChanged: (bool? value) {
                setState(() {
                  isOily = value!;
                  if (isOily) {
                    isDry = false;
                    isNormal = false;
                    isCombination = false;
                    isSensitive = false;
                  }
                });
              },
            ),
            CheckboxListTile(
              title: const Text("NORMAL"),
              value: isNormal,
              onChanged: (bool? value) {
                setState(() {
                  isNormal = value!;
                  if (isNormal) {
                    isDry = false;
                    isOily = false;
                    isCombination = false;
                    isSensitive = false;
                  }
                });
              },
            ),
            CheckboxListTile(
              title: const Text("COMBINATION"),
              value: isCombination,
              onChanged: (bool? value) {
                setState(() {
                  isCombination = value!;
                  if (isCombination) {
                    isDry = false;
                    isOily = false;
                    isNormal = false;
                    isSensitive = false;
                  }
                });
              },
            ),
            CheckboxListTile(
              title: const Text("SENSITIVE"),
              value: isSensitive,
              onChanged: (bool? value) {
                setState(() {
                  isSensitive = value!;
                  if (isSensitive) {
                    isDry = false;
                    isOily = false;
                    isNormal = false;
                    isCombination = false;
                  }
                });
              },
            ),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  // Determine selected skin type
                  String? skinType;
                  if (isDry) {
                    skinType = "dry";
                  } else if (isOily) {
                    skinType = "oily";
                  } else if (isNormal) {
                    skinType = "normal";
                  } else if (isCombination) {
                    skinType = "combination";
                  } else if (isSensitive) {
                    skinType = "sensitive";
                  }

                  // Update client data
                  var userId = await _authService.getUserId();
                  if (userId?.isNotEmpty ?? false) {
                    await _clientController.updateClientData(
                      client: Client(skinType: skinType),
                    );
                  }

                  // Navigate to Recommendations page
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Recommendation()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD9D9D9),
                  padding: const EdgeInsets.symmetric(horizontal: 50.0, vertical: 15.0),
                ),
                child: const Text('NEXT'),
              ),
            ),
          ],
        ),
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
                MaterialPageRoute(builder: (context) => const BarCodeScanning()),
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
          }
        },
      ),
    );
  }
}
