import 'package:flutter/material.dart';
import 'package:cosmo_care/Pages/MyCart.dart';
import 'package:cosmo_care/Pages/MyProfile.dart';
import 'package:cosmo_care/Pages/Recommendation.dart';
import 'package:cosmo_care/Pages/BarCodeScanning.dart';
import 'package:cosmo_care/Pages/ChatBot.dart';
import 'package:cosmo_care/Pages/Home.dart';
import 'package:cosmo_care/Pages/Search.dart';

class SkinProblem extends StatefulWidget {
  const SkinProblem({super.key});

  @override
  _SkinProblemState createState() => _SkinProblemState();
}

class _SkinProblemState extends State<SkinProblem> {
  final List<String> _selectedConcerns = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD1C4E9),
      appBar: AppBar(
        backgroundColor: const Color(0xFFE1BEE7),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('Select Your Concern', style: TextStyle(color: Colors.black)),
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              'Please, Select your Concern(s)',
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: <Widget>[
                  buildCheckboxListTile('Acne'),
                  buildCheckboxListTile('Dark Spots'),
                  buildCheckboxListTile('Pigment Spots'),
                  buildCheckboxListTile('Under Eye Puffiness'),
                  buildCheckboxListTile('Eye Bags'),
                  buildCheckboxListTile('Dark Circles'),
                  buildCheckboxListTile('Dry Skin'),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Center(
              child: Column(
                children: [
                  const Text(
                    'To See The Suggested Products For You',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextButton(
                    onPressed: () {
                      if (_selectedConcerns.isEmpty) {
                        // Show alert if no concerns are selected
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Alert'),
                              content: const Text('Please Choose Your Problem.'),
                              actions: <Widget>[
                                TextButton(
                                  child: const Text('OK'),
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
                          MaterialPageRoute(
                            builder: (context) => Recommendation(concerns: _selectedConcerns),
                          ),
                        );
                      }
                    },
                    child: const Text(
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
        backgroundColor: const Color(0xFFE1BEE7),
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

  Widget buildCheckboxListTile(String title) {
    return CheckboxListTile(
      title: Text(title),
      value: _selectedConcerns.contains(title.toLowerCase()),
      onChanged: (value) {
        setState(() {
          if (value == true) {
            _selectedConcerns.add(title.toLowerCase());
          } else {
            _selectedConcerns.remove(title.toLowerCase());
          }
        });
      },
    );
  }
}
