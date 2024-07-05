import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../Services/ClientController.dart';
import 'ChatBot.dart';
import 'Home.dart';
import 'MyCart.dart';
import 'MyProfile.dart';
import 'ProductDetails.dart'; // Ensure this import is correct
import 'Search.dart';

class BarCodeScanning extends StatefulWidget {
  @override
  _BarCodeScanningPageState createState() => _BarCodeScanningPageState();
}

class _BarCodeScanningPageState extends State<BarCodeScanning> {
  String barcode = "";
  final ClientController clientController = ClientController();
  var fetchedProduct;
  bool showMessage = false; // Variable to control the visibility of the message

  void _onBarcodeDetect(BarcodeCapture capture) {
    final List<Barcode> barcodes = capture.barcodes;
    if (barcodes.isNotEmpty) {
      setState(() {
        barcode = barcodes.first.rawValue ?? 'Failed to get barcode';
      });
      print('Scanned Barcode: $barcode');
      clientController.fetchProductByCode(barcode).then((product) {
        if (product != null) {
          setState(() {
            fetchedProduct = product; // Store the fetched product
            showMessage = false; // Hide the message if a product is found
          });
        } else {
          setState(() {
            fetchedProduct = null; // Ensure fetchedProduct is set to null
            showMessage = true; // Show the message if no product is found
          });
        }
      });
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
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              "Scan product's BarCode here for more info",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            flex: 2,
            child: MobileScanner(
              onDetect: _onBarcodeDetect,
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Scanned Barcode:',
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(height: 10),
                  Text(
                    barcode,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  if (fetchedProduct != null) // Only show the button if a product is fetched
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProductDetails(product: fetchedProduct),
                          ),
                        );
                      },
                      child: Text("Go to Product Details Page"),
                    ),
                  if (showMessage) // Only show the message if `showMessage` is true
                    Text(
                      'No product found for the scanned barcode.',
                      style: TextStyle(color: Colors.red, fontSize: 16),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black54,
        backgroundColor: const Color(0xFFE1BEE7),
        currentIndex: 2,
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
            // Scan page already present
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
