import 'package:cosmo_care/Pages/SkinProblem.dart';
import 'package:flutter/material.dart';
import 'package:cosmo_care/Pages/BarCodeScanning.dart';
import 'package:cosmo_care/Pages/ChatBot.dart';
import 'package:cosmo_care/Pages/Home.dart';
import 'package:cosmo_care/Pages/MyCart.dart';
import 'package:cosmo_care/Pages/Search.dart';

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
      backgroundColor: Color(0xFFCDB7EB),
      appBar: AppBar(
        backgroundColor: Color(0xFFE3CCE1),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Go back to the previous page
          },
        ),
        title: Text('Skin Type Test', style: TextStyle(color: Colors.black)),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: SingleChildScrollView(
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
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Center(
              child: ElevatedButton(
                onPressed: () {
                  // Check if at least one option is selected
                  if (!(isDry || isOily || isNormal || isCombination || isSensitive)) {
                    // Show alert if no options are selected
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Alert'),
                          content: Text('Please choose at least one skin type.'),
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
                  } else {
                    // Navigate to SkinProblem page if at least one option is selected
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const SkinProblem()),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFD9D9D9),
                  padding: EdgeInsets.symmetric(horizontal: 70.0, vertical: 20.0),
                ),
                child: Text('NEXT'),
              ),
            ),
          ),
        ],
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
