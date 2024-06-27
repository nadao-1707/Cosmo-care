import 'package:flutter/material.dart';
import 'package:cosmo_care/Pages/BarCodeScanning.dart';
import 'package:cosmo_care/Pages/ChatBot.dart';
import 'package:cosmo_care/Pages/Home.dart';
import 'package:cosmo_care/Pages/PayementMethod.dart';
import 'package:cosmo_care/Pages/Search.dart';
import 'package:cosmo_care/Pages/MyProfile.dart';

class MyCart extends StatefulWidget {
  const MyCart({super.key});

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<MyCart> {
  int _selectedIndex = 3; // Set the initial selected index to 3 for the "Cart" item

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
        // Stay on the same page if 'Cart' is tapped
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
      backgroundColor: const Color(0xFFD1C4E9), // Background color
      appBar: AppBar(
        backgroundColor: const Color(0xFFE1BEE7),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Go back to the previous page
          },
        ),
        title: const Text('Checkout'),
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
          children: [
            Expanded(
              child: ListView(
                children: const [
                  ProductCheckoutCard(
                    imagePath: 'assets/images/RecommendedProduct1.png',
                    productName: 'Yunnisa Face Oil',
                    price: 'EGP 420',
                  ),
                  ProductCheckoutCard(
                    imagePath: 'assets/images/RecommendedProduct2.png',
                    productName: 'Ginger Mud Clay Mask',
                    price: 'EGP 500',
                  ),
                  ProductCheckoutCard(
                    imagePath: 'assets/images/RecommendedProduct3.png',
                    productName: 'CeraVe Antiseptic and Cleanser',
                    price: 'EGP 637',
                  ),
                ],
              ),
            ),
            const Divider(
              color: Colors.black,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'EGP 1,557',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const PaymentMethod()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFB39DDB), // Button color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                  child: Text(
                    'CHECK OUT',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black54,
        backgroundColor: const Color(0xFFE1BEE7),
        currentIndex: _selectedIndex, // Set the selected index to Cart
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

class ProductCheckoutCard extends StatelessWidget {
  final String imagePath;
  final String productName;
  final String price;

  const ProductCheckoutCard({super.key, 
    required this.imagePath,
    required this.productName,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            imagePath,
            width: 80,
            height: 80,
            fit: BoxFit.cover,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  productName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  price,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
