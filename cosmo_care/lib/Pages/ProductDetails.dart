// ignore_for_file: prefer_const_constructors

import 'package:cosmo_care/Services/AuthService.dart';
import 'package:flutter/material.dart';
import 'package:cosmo_care/Entities/Product.dart';
import 'package:cosmo_care/Services/ClientController.dart';
import 'package:cosmo_care/Pages/BarCodeScanning.dart';
import 'package:cosmo_care/Pages/ChatBot.dart';
import 'package:cosmo_care/Pages/Home.dart';
import 'package:cosmo_care/Pages/MyCart.dart';
import 'package:cosmo_care/Pages/Search.dart';
import 'package:cosmo_care/Pages/MyProfile.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

Future<void> addProductToCart(String productName) async {
  ClientController controller = ClientController();
  String id = await controller.fetchProductIdByName(productName); 
  await controller.addToCart(id);
}

Future<void> addReview(String productName, String review) async {
  ClientController controller = ClientController();
  String id = await controller.fetchProductIdByName(productName); 
  String? username = await fetchUsername(); 
  await controller.addReview(id, 'Review by $username: $review');
}

Future<void> addRating(String productName, int rating) async {
  ClientController controller = ClientController();
  String id = await controller.fetchProductIdByName(productName); 
  await controller.addRating(id, rating);
}

Future<String?> fetchUsername() async {
  try {
    AuthService auth = AuthService();
    return await auth.getUserUsername();
  } catch (e) {
    print('Error fetching username: $e');
    return null;
  }
}

class ProductDetails extends StatelessWidget {
  final Product product;

  const ProductDetails({super.key, required this.product});

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
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              backgroundImage: AssetImage('assets/images/login_image-removebg-preview.png'),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
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
              child: ElevatedButton.icon(
                onPressed: () async {
                  await addProductToCart(product.name);
                  // Show a SnackBar when the product is added to the cart
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${product.name} has been added to the cart'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
                  minimumSize: const Size(200, 36), // Fixed minimum size
                  backgroundColor: const Color(0xFFB39DDB),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                icon: const Icon(Icons.shopping_cart), // Cart icon added
                label: const Text(
                  'ADD TO CART',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
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
                MaterialPageRoute(builder: (context) => BarCodeScanning()),
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
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}


// ignore: must_be_immutable  
class ProductDetailCard extends StatefulWidget {
  final String name;
  final String imgURL;
  final String? category;
  final List<String>? requiredSkinType;
  final int price;
  final String? description;
  final String? ingredients;
  double? averageRating;
  int? totalRatings;
  final List<String>? reviews;
  final String? howToUse;
  final List<String>? problems;

  ProductDetailCard({
    super.key,
    required this.name,
    required this.imgURL,
    this.category,
    this.requiredSkinType,
    required this.price,
    this.description,
    this.ingredients,
    this.averageRating,
    this.totalRatings,
    this.reviews,
    this.howToUse,
    this.problems,
  });

  @override
  _ProductDetailCardState createState() => _ProductDetailCardState();
}

class _ProductDetailCardState extends State<ProductDetailCard> {
  int selectedIndex = 0;
  final TextEditingController reviewController = TextEditingController();
  final TextEditingController ratingController = TextEditingController();

  @override
  void dispose() {
    reviewController.dispose();
    ratingController.dispose();
    super.dispose();
  }

  Widget getContent() {
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
            RatingBar.builder(
              initialRating: widget.averageRating ?? 0,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) => Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (rating) {
                print(rating);
              },
              ignoreGestures: true,
            ),
            Text(
              '${widget.averageRating?.toStringAsFixed(1) ?? '0.0'} (${widget.totalRatings ?? 0} reviews)',
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
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: widget.problems?.map((problem) => Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: Text('- $problem'),
              )).toList() ?? [Text('No problems listed')],
            ),
          ],
        );
      case 3:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.reviews != null && widget.reviews!.isNotEmpty)
              ListView(
                shrinkWrap: true,
                children: widget.reviews!.map((review) => ListTile(title: Text(review))).toList(),
              )
            else
              Center(child: Text('No reviews until now')),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: reviewController,
                    decoration: InputDecoration(
                      labelText: 'Add a Review',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () async {
                    if (reviewController.text.isNotEmpty) {
                      await addReview(widget.name, reviewController.text);
                      setState(() {
                        widget.reviews?.add(reviewController.text);
                        reviewController.clear();
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFB39DDB),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                    child: Text(
                      'SUBMIT',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: ratingController,
                    decoration: InputDecoration(
                      labelText: 'Add a Rating (1-5)',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () async {
                    if (ratingController.text.isNotEmpty) {
                      int? rating = int.tryParse(ratingController.text);
                      if (rating != null && rating > 0 && rating <= 5) {
                        await addRating(widget.name, rating);
                        setState(() {
                          widget.averageRating = (widget.averageRating! * widget.totalRatings! + rating) / (widget.totalRatings! + 1);
                          widget.totalRatings = widget.totalRatings! + 1;
                          ratingController.clear();
                        });
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFB39DDB),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                    child: Text(
                      'SUBMIT',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      default:
        return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      color: Colors.white,
      child: Container(
        height: 600, // Fixed height for the card
        child: SingleChildScrollView(
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
                    fit: BoxFit.contain, // Ensure the image fits within the container
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
                        'Overview',
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
        ),
      ),
    );
  }
}
