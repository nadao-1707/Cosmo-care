import 'package:flutter/material.dart';
import 'package:flutter_application_2/Pages/BarCodeScanning.dart';
import 'package:flutter_application_2/Pages/ChatBot.dart';
import 'package:flutter_application_2/Pages/Home.dart';
import 'package:flutter_application_2/Pages/MyCart.dart';
import 'package:flutter_application_2/Pages/Search.dart';
import 'package:flutter_application_2/Pages/MyProfile.dart';

class Final extends StatefulWidget {
  @override
  _FinalPageState createState() => _FinalPageState();
}

class _FinalPageState extends State<Final> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFCDB7EB),
      appBar: AppBar(
        backgroundColor: Color(0xFFE1BEE7),
        title: Text('Order Confirmation', style: TextStyle(color: Colors.black)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Home()),
            );
          },
        ),
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.check_circle,
              size: 80,
              color: Colors.black,
            ),
            SizedBox(height: 20),
            Text(
              'Your order is confirmed',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Home()),
                );
              },
              child: Text(
                'IF you like to go to home page again please\nCLICK HERE',
                style: TextStyle(
                  fontSize: 16,
                  color: Color.fromARGB(255, 112, 181, 238), // Changed color to blue to indicate a link
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline, // Added underline for link style
                ),
                textAlign: TextAlign.center,
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
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
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
      ),
    );
  }
}
