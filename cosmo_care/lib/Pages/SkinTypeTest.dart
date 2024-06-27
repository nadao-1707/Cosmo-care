import 'package:flutter/material.dart';
import 'package:cosmo_care/Pages/BarCodeScanning.dart';
import 'package:cosmo_care/Pages/ChatBot.dart';
import 'package:cosmo_care/Pages/Home.dart';
import 'package:cosmo_care/Pages/MyCart.dart';
import 'package:cosmo_care/Pages/Recommendation.dart';
import 'package:cosmo_care/Pages/Search.dart';
import 'package:cosmo_care/Pages/MyProfile.dart';

class SkinTypeTest extends StatefulWidget {
  const SkinTypeTest({super.key});

  @override
  _SkinTypeTestState createState() => _SkinTypeTestState();
}

class _SkinTypeTestState extends State<SkinTypeTest> {
  bool isDry = false;
  bool isOily = false;
  bool isNormal = false;
  bool isCombination = false;
  bool isSensitive = false;

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
                });
              },
            ),
            CheckboxListTile(
              title: const Text("OILY"),
              value: isOily,
              onChanged: (bool? value) {
                setState(() {
                  isOily = value!;
                });
              },
            ),
            CheckboxListTile(
              title: const Text("NORMAL"),
              value: isNormal,
              onChanged: (bool? value) {
                setState(() {
                  isNormal = value!;
                });
              },
            ),
            CheckboxListTile(
              title: const Text("COMBINATION"),
              value: isCombination,
              onChanged: (bool? value) {
                setState(() {
                  isCombination = value!;
                });
              },
            ),
            CheckboxListTile(
              title: const Text("SENSITIVE"),
              value: isSensitive,
              onChanged: (bool? value) {
                setState(() {
                  isSensitive = value!;
                });
              },
            ),
            Center(
              child: ElevatedButton(
                onPressed: () {
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
