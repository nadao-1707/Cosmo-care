import 'package:flutter/material.dart';
import 'package:flutter_application_2/Pages/BarCodeScanning.dart';
import 'package:flutter_application_2/Pages/ChatBot.dart';
import 'package:flutter_application_2/Pages/Home.dart';
import 'package:flutter_application_2/Pages/MyCart.dart';
import 'package:flutter_application_2/Pages/Recommendation.dart';
import 'package:flutter_application_2/Pages/Search.dart';
import 'package:flutter_application_2/Pages/MyProfile.dart';

class SkinTypeTest extends StatefulWidget {
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
      backgroundColor: Color(0xFFCDB7EB), // Background color
      appBar: AppBar(
        backgroundColor: Color(0xFFE3CCE1),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Go back to the previous page
          },
        ),
        title: Text('Skin Type Test', style: TextStyle(color: Colors.black)),
        actions: [
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MyProfile()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
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
              title: Text("DRY"),
              value: isDry,
              onChanged: (bool? value) {
                setState(() {
                  isDry = value!;
                });
              },
            ),
            CheckboxListTile(
              title: Text("OILY"),
              value: isOily,
              onChanged: (bool? value) {
                setState(() {
                  isOily = value!;
                });
              },
            ),
            CheckboxListTile(
              title: Text("NORMAL"),
              value: isNormal,
              onChanged: (bool? value) {
                setState(() {
                  isNormal = value!;
                });
              },
            ),
            CheckboxListTile(
              title: Text("COMBINATION"),
              value: isCombination,
              onChanged: (bool? value) {
                setState(() {
                  isCombination = value!;
                });
              },
            ),
            CheckboxListTile(
              title: Text("SENSITIVE"),
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
                    MaterialPageRoute(builder: (context) => Recommendation()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFD9D9D9),
                  padding: EdgeInsets.symmetric(horizontal: 50.0, vertical: 15.0),
                ),
                child: Text('NEXT'),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.black54,
        unselectedItemColor: Colors.black54,
        backgroundColor: Color(0xFFE3CCE1),
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
}
