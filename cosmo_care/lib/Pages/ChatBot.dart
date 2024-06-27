import 'package:flutter/material.dart';
import 'package:cosmo_care/Pages/BarCodeScanning.dart';
import 'package:cosmo_care/Pages/Home.dart';
import 'package:cosmo_care/Pages/MyCart.dart';
import 'package:cosmo_care/Pages/Search.dart';
import 'package:cosmo_care/Pages/MyProfile.dart';

class ChatBot extends StatefulWidget {
  const ChatBot({super.key});

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatBot> {
  int _selectedIndex = 1; 

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    switch (index) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Home()),
        );
        break;
      case 1:
        // Stay on the same page 
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
        title: const Text('Chat with Cosmo Care', style: TextStyle(color: Colors.black)),
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
      body: Column(
        children: <Widget>[
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Container(
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE3CCE1),
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: const Text(
                        'Hello, how can I help you?',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Type a reply...',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    print('Send icon tapped');
                  },
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black54,
        backgroundColor: const Color(0xFFE1BEE7),
        currentIndex: _selectedIndex, // Set the selected index
        onTap: _onItemTapped, // Handle item tap
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
