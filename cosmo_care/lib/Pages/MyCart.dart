import 'package:flutter/material.dart';
import 'package:cosmo_care/Entities/Product.dart';
import 'package:cosmo_care/Services/ClientController.dart';
import 'package:cosmo_care/Pages/BarCodeScanning.dart';
import 'package:cosmo_care/Pages/ChatBot.dart';
import 'package:cosmo_care/Pages/Home.dart';
import 'package:cosmo_care/Pages/Search.dart';
import 'package:cosmo_care/Pages/MyProfile.dart';
import 'package:cosmo_care/Services/AuthService.dart';
import 'package:cosmo_care/Pages/PayementMethod.dart';

class MyCart extends StatefulWidget {
  const MyCart({super.key});

  @override
  _MyCartState createState() => _MyCartState();
}

class _MyCartState extends State<MyCart> {
  late ClientController _controller;
  int _selectedIndex = 3;
  Map<Product, int> _cartProductsWithQuantities = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _controller = ClientController();
    _fetchCartContents();
  }

  Future<void> _fetchCartContents() async {
    String? userId = await AuthService().getUserId();

    if (userId != null) {
      Map<Product, int> productsWithQuantities = await ClientController.listCartContents(userId);
      setState(() {
        _cartProductsWithQuantities = productsWithQuantities;
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
      print('User ID is null. Unable to fetch cart contents.');
    }
  }

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
          MaterialPageRoute(builder: (context) => BarCodeScanning()),
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

  void _increaseQuantity(Product product) {
    setState(() {
      int currentQuantity = _cartProductsWithQuantities[product] ?? 1;
      _cartProductsWithQuantities[product] = currentQuantity + 1;
    });
  }

  void _decreaseQuantity(Product product) {
    setState(() {
      int currentQuantity = _cartProductsWithQuantities[product] ?? 1;
      if (currentQuantity > 1) {
        _cartProductsWithQuantities[product] = currentQuantity - 1;
      } else {
        _removeFromCart(product);
      }
    });
  }

  void _removeFromCart(Product product) {
    setState(() {
      _cartProductsWithQuantities.remove(product);
    });

    _controller.getProductID(product.name).then((docId) {
      // Call the method to remove from Firestore cart using the docId
      ClientController().removeFromCart(docId).then((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${product.name} removed from cart')),
        );
      }).catchError((error) {
        print('Failed to remove from cart: $error');
        setState(() {
          _cartProductsWithQuantities[product] = 1; 
        });
      });
    }).catchError((error) {
      print('Error getting product ID: $error');
      setState(() {
        _cartProductsWithQuantities[product] = 1;
      });
    });
  }

  void _checkout() {
  if (_cartProductsWithQuantities.isEmpty) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Cart is Empty'),
          content: const Text('Please add products to your cart before checkout.'),
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
    double totalPrice = _cartProductsWithQuantities.entries.fold(
      0,
      (total, entry) => total + entry.value * entry.key.price,
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentMethod(totalPrice: totalPrice),
      ),
    );
  }
}


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
  title: const Text('My cart'),
  centerTitle: true, // Center align the title
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
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    child: ListView.builder(
                      itemCount: _cartProductsWithQuantities.length,
                      itemBuilder: (context, index) {
                        final product = _cartProductsWithQuantities.keys.elementAt(index);
                        final quantity = _cartProductsWithQuantities[product]!;
                        return ProductCheckoutCard(
                          product: product,
                          quantity: quantity,
                          onIncrease: () => _increaseQuantity(product),
                          onDecrease: () => _decreaseQuantity(product),
                          onRemove: () => _removeFromCart(product),
                        );
                      },
                    ),
                  ),
                  const Divider(
                    color: Colors.black,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total:',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'EGP ${_cartProductsWithQuantities.entries.fold(0, (total, entry) => total + entry.value * entry.key.price)}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Center(
                      child: ElevatedButton(
                        onPressed: _checkout,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFD9D9D9),
                          padding: const EdgeInsets.symmetric(horizontal: 50.0, vertical: 15.0),
                        ),
                        child: const Text('CHECK OUT'),
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


class ProductCheckoutCard extends StatelessWidget {
  final Product product;
  final int quantity;
  final VoidCallback onRemove;
  final VoidCallback onIncrease;
  final VoidCallback onDecrease;

  const ProductCheckoutCard({
    super.key,
    required this.product,
    required this.quantity,
    required this.onRemove,
    required this.onIncrease,
    required this.onDecrease,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade300, width: 1),
      ),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                product.imgURL,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'EGP ${product.price}',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed: onDecrease,
                        color: Colors.black,
                      ),
                      Text(
                        '$quantity',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: onIncrease,
                        color: Colors.black,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: onRemove,
              color: const Color.fromARGB(255, 2, 2, 2),
            ),
          ],
        ),
      ),
    );
  }
}
