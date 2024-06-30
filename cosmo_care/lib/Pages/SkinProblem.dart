import 'package:flutter/material.dart';
import 'package:flutter_application_2/Pages/BarCodeScanning.dart';
import 'package:flutter_application_2/Pages/ChatBot.dart';
import 'package:flutter_application_2/Pages/Home.dart';
import 'package:flutter_application_2/Pages/MyCart.dart';
import 'package:flutter_application_2/Pages/Search.dart';
import 'package:flutter_application_2/Pages/MyProfile.dart';
import 'package:flutter_application_2/Pages/Recommendation.dart';

class SkinProblem extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<SkinProblem> {
  List<String> _selectedConcerns = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFD1C4E9),
      appBar: AppBar(
        backgroundColor: Color(0xFFE1BEE7),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('Select Your Concern', style: TextStyle(color: Colors.black)),
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Please, Select your Concern(s)',
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: <Widget>[
                  buildCheckboxListTile('Acne'),
                  buildCheckboxListTile('Dark Spots'),
                  buildCheckboxListTile('Fine Lines'),
                  buildCheckboxListTile('Dull Skin'),
                  buildCheckboxListTile('Atopic Dermatitis'),
                  buildCheckboxListTile('Alopecia Areata'),
                  buildCheckboxListTile('Pemphigus'),
                ],
              ),
            ),
            SizedBox(height: 10),
            Center(
              child: Column(
                children: [
                  Text(
                    'To See The Suggested Products For You',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 10),
                  TextButton(
                    onPressed: () {
                      if (_selectedConcerns.isEmpty) {
                        // Show alert if no concerns are selected
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Alert'),
                              content: Text('Please Choose Your Problem.'),
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Recommendation()),
                        );
                      }
                    },
                    child: Text(
                      'CLICK HERE',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
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

  Widget buildCheckboxListTile(String title) {
    return CheckboxListTile(
      title: Text(title),
      value: _selectedConcerns.contains(title),
      onChanged: (value) {
        setState(() {
          if (value != null && value) {
            _selectedConcerns.add(title);
          } else {
            _selectedConcerns.remove(title);
          }
        });
      },
    );
  }
}
