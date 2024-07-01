// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:cosmo_care/Entities/Product.dart';
import 'package:cosmo_care/Services/ClientController.dart';
import 'package:cosmo_care/Pages/BarCodeScanning.dart';
import 'package:cosmo_care/Pages/ChatBot.dart';
import 'package:cosmo_care/Pages/Home.dart';
import 'package:cosmo_care/Pages/MyCart.dart';
import 'package:cosmo_care/Pages/Search.dart';
import 'package:cosmo_care/Pages/MyProfile.dart';

Future<void> addProductToCart(String productName) async {
  ClientController controller = ClientController();
  String id = await controller.fetchProductIdByName(productName); 
  await controller.addToCart(id);
}

class Productdetails extends StatelessWidget {
  final Product product;
  const Productdetails({Key? key, required this.product});

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
        title: const Text('Products Details'),
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
            ProductDetailCard(
              name: product.name,
              imgURL: product.imgURL,
              category: product.category,
              requiredSkinType: product.requiredSkinType,
              price: product.price,
              description: product.description,
              ingredients: product.ingredients,
              averageRating: product.averageRating,
              totalRatings: product.totalRatings,
              reviews: product.reviews,
              howToUse: product.howToUse,
              problems: product.problems,
            ),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  await addProductToCart(product.name);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFB39DDB), 
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                  child: Text(
                    'ADD TO CART',
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
        currentIndex: 3, // Set the selected index to Cart
        onTap: (index) {
          // Add navigation logic based on the selected index here
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

class ProductDetailCard extends StatefulWidget {
  final String name;
  final String imgURL;
  final String? category;
  final List<String>? requiredSkinType;
  final int price;
  final String? description;
  final String? ingredients; // Updated to String
  final double? averageRating;
  final int? totalRatings;
  final List<String>? reviews;
  final String? howToUse;
  final List<String>? problems;

  ProductDetailCard({
    Key? key,
    required this.name,
    required this.imgURL,
    this.category,
    this.requiredSkinType,
    required this.price,
    this.description,
    this.ingredients, // Updated to String
    this.averageRating,
    this.totalRatings,
    this.reviews,
    this.howToUse,
    this.problems,
  }) : super(key: key);

  @override
  _ProductDetailCardState createState() => _ProductDetailCardState();
}

class _ProductDetailCardState extends State<ProductDetailCard> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    Widget getContent() {
      print("Reviews: ${widget.reviews}"); // Debugging line
      switch (selectedIndex) {
        case 0:
          return Text(
            widget.description ?? 'No description available',
            textAlign: TextAlign.justify,
          );
        case 1:
          return Text(
            widget.ingredients ?? 'No ingredients available',
            textAlign: TextAlign.justify,
          );
        case 2:
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Category:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 1),
              Text(
              widget.category ?? 'N/A',
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 1),

              Text(
                'Required Skin Type:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: widget.requiredSkinType?.map((SkinType) => Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Text('- $SkinType'),
                )).toList() ?? [Text('N/A')],
              ),
              Row(
                children: [
                  Text(
                    'Price:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(width: 3), 
                  Text(
                    '${widget.price} EGP',
                    textAlign: TextAlign.justify,
                  ),
                ],
              ),

              Text(
                'Rating:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 1),
              Text(
                '${widget.averageRating} (${widget.totalRatings} reviews)',
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 1),

              Text(
                'How To Use:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 1),
              Text(
                widget.howToUse ?? 'No usage instructions available',
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 1),

              Text(
                'Problems:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: widget.problems?.map((problem) => Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Text('- $problem'),
                )).toList() ?? [Text('No problems listed')],
              ),
            ],
          );
        case 3:
          if (widget.reviews != null && widget.reviews!.isNotEmpty) {
            return ListView(
              shrinkWrap: true,
              children: widget.reviews!.map((review) => ListTile(title: Text(review))).toList(),
            );
          } else {
            return Center(child: Text('No reviews available'));
          }
        default:
          return Container();
      }
    }

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.network(
                widget.imgURL,
                width: 200,
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: Text(
                widget.name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                InkWell(
                  onTap: () {
                    setState(() {
                      selectedIndex = 0;
                    });
                  },
                  child: Text(
                    'OverView',
                    style: TextStyle(
                      color: selectedIndex == 0 ? Colors.green : Colors.grey,
                      fontWeight: selectedIndex == 0 ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      selectedIndex = 1;
                    });
                  },
                  child: Text(
                    'Ingredients',
                    style: TextStyle(
                      color: selectedIndex == 1 ? Colors.green : Colors.grey,
                      fontWeight: selectedIndex == 1 ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      selectedIndex = 2;
                    });
                  },
                  child: Text(
                    'Details',
                    style: TextStyle(
                      color: selectedIndex == 2 ? Colors.green : Colors.grey,
                      fontWeight: selectedIndex == 2 ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      selectedIndex = 3;
                    });
                  },
                  child: Text(
                    'Reviews',
                    style: TextStyle(
                      color: selectedIndex == 3 ? Colors.green : Colors.grey,
                      fontWeight: selectedIndex == 3 ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
              ],
            ),
            const Divider(),
            getContent(),
          ],
        ),
      ),
    );
  }
}
