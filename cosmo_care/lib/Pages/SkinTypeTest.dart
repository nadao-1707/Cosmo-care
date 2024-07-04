import 'package:flutter/material.dart';
import 'package:cosmo_care/Entities/Client.dart';
import 'package:cosmo_care/Pages/SkinProblem.dart';
import 'package:cosmo_care/Services/AuthService.dart';
import 'package:cosmo_care/Services/ClientController.dart';
import 'package:cosmo_care/Pages/Home.dart';
import 'package:cosmo_care/Pages/ChatBot.dart';
import 'package:cosmo_care/Pages/BarCodeScanning.dart';
import 'package:cosmo_care/Pages/MyCart.dart';
import 'package:cosmo_care/Pages/Search.dart';
import 'package:cosmo_care/Pages/MyProfile.dart';

class SkinTypeTest extends StatefulWidget {
  const SkinTypeTest({Key? key}) : super(key: key);

  @override
  _SkinTypeTestState createState() => _SkinTypeTestState();
}

class _SkinTypeTestState extends State<SkinTypeTest> {
  late ClientController _clientController;
  late AuthService _authService;
  Set<String> selectedSkinTypes = {};
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _clientController = ClientController();
    _authService = AuthService();
  }

  void _showAlert() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Please select at least one skin type'),
        actions: <Widget>[
          TextButton(
            child: const Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
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
        title: const Text('Skin Type Test', style: TextStyle(color: Colors.black)),
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
      body: Expanded(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'SKIN TYPE TEST',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              CheckboxListTile(
                title: const Text("DRY"),
                value: selectedSkinTypes.contains("dry"),
                onChanged: (bool? value) {
                  setState(() {
                    if (value != null && value) {
                      selectedSkinTypes.add("dry");
                    } else {
                      selectedSkinTypes.remove("dry");
                    }
                  });
                },
              ),
              CheckboxListTile(
                title: const Text("OILY"),
                value: selectedSkinTypes.contains("oily"),
                onChanged: (bool? value) {
                  setState(() {
                    if (value != null && value) {
                      selectedSkinTypes.add("oily");
                    } else {
                      selectedSkinTypes.remove("oily");
                    }
                  });
                },
              ),
              CheckboxListTile(
                title: const Text("NORMAL"),
                value: selectedSkinTypes.contains("normal"),
                onChanged: (bool? value) {
                  setState(() {
                    if (value != null && value) {
                      selectedSkinTypes.add("normal");
                    } else {
                      selectedSkinTypes.remove("normal");
                    }
                  });
                },
              ),
              CheckboxListTile(
                title: const Text("COMBINATION"),
                value: selectedSkinTypes.contains("combination"),
                onChanged: (bool? value) {
                  setState(() {
                    if (value != null && value) {
                      selectedSkinTypes.add("combination");
                    } else {
                      selectedSkinTypes.remove("combination");
                    }
                  });
                },
              ),
              CheckboxListTile(
                title: const Text("SENSITIVE"),
                value: selectedSkinTypes.contains("sensitive"),
                onChanged: (bool? value) {
                  setState(() {
                    if (value != null && value) {
                      selectedSkinTypes.add("sensitive");
                    } else {
                      selectedSkinTypes.remove("sensitive");
                    }
                  });
                },
              ),
            ],
          ),
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
          }
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: ElevatedButton(
        onPressed: selectedSkinTypes.isNotEmpty ? () async {
          // Update client data
          var userId = await _authService.getUserId();
          if (userId?.isNotEmpty ?? false) {
            await _clientController.updateClientData(
              client: Client(skinType: selectedSkinTypes.toList().join(",")),
            );
          }

          // Navigate to Recommendations page
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SkinProblem()),
          );
        } : _showAlert,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFD9D9D9),
          padding: const EdgeInsets.symmetric(horizontal: 50.0, vertical: 15.0),
        ),
        child: isLoading
            ? const CircularProgressIndicator(color: Colors.white)
            : const Text('NEXT'),
      ),
    );
  }
}
