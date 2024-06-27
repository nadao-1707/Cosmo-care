import 'package:flutter/material.dart';
import 'package:cosmo_care/Pages/BarCodeScanning.dart';
import 'package:cosmo_care/Pages/ChatBot.dart';
import 'package:cosmo_care/Pages/Home.dart';
import 'package:cosmo_care/Pages/MyCart.dart';
import 'package:cosmo_care/Pages/Search.dart';
import 'package:cosmo_care/Pages/MyProfile.dart';

class Recommendation extends StatelessWidget {
  const Recommendation({super.key});

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
        title: const Text('Suggested Products'),
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
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Suggested products for you',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 3,
                mainAxisSpacing: 3,
                children: const [
                  ProductCard(
                    imagePath: 'assets/images/RecommendedProduct1.png',
                    productName: 'CeraVe Antiseptic and Cleanser',
                    price: 'EGP 637',
                  ),
                  ProductCard(
                    imagePath: 'assets/images/RecommendedProduct2.png',
                    productName: 'Yunnisa Face Oil',
                    price: 'EGP 420',
                  ),
                  ProductCard(
                    imagePath: 'assets/images/RecommendedProduct3.png',
                    productName: 'Ginger Mud Clay',
                    price: 'EGP 500',
                  ),
                  ProductCard(
                    imagePath: 'assets/images/RecommendedProduct4.png',
                    productName: 'Garnier Exfoliating Scrub',
                    price: 'EGP 200',
                  ),
                  ProductCard(
                    imagePath: 'assets/images/RecommendedProduct5.png',
                    productName: 'Laneige Water Sleeping Mask',
                    price: 'EGP 300',
                  ),
                  ProductCard(
                    imagePath: 'assets/images/RecommendedProduct6.png',
                    productName: 'L\'Oréal Night Cream',
                    price: 'EGP 280',
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

class ProductCard extends StatelessWidget {
  final String imagePath;
  final String productName;
  final String price;

  const ProductCard({super.key, 
    required this.imagePath,
    required this.productName,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(4.0), // Reduced padding size
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  imagePath,
                  width: double.infinity,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            const SizedBox(height: 4), // Reduced spacing
            Text(
              productName,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 2), // Reduced spacing
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  price,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.shopping_cart),
                  onPressed: () {
                    print('Add to cart tapped');
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
