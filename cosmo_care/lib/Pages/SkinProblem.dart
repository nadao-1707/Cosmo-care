import 'package:flutter/material.dart';
import 'package:cosmo_care/Pages/MyCart.dart';
import 'package:cosmo_care/Pages/MyProfile.dart';
import 'package:cosmo_care/Pages/Recommendation.dart';
import 'package:cosmo_care/Pages/BarCodeScanning.dart';
import 'package:cosmo_care/Pages/ChatBot.dart';
import 'package:cosmo_care/Pages/Home.dart';
import 'package:cosmo_care/Pages/Search.dart';

class SkinProblem extends StatefulWidget {
  const SkinProblem({Key? key}) : super(key: key);

  @override
  _SkinProblemState createState() => _SkinProblemState();
}

class _SkinProblemState extends State<SkinProblem> {
  final List<String> _selectedConcerns = [];
  String? _selectedPrice;
  bool _showBudgetOptions = false;

  final List<String> _priceOptions = [
    'Under EGP 500',
    'EGP 500 - EGP 1000',
    'EGP 1000 - EGP 2000',
    'Above EGP 2000',
  ];

  Map<String, List<int>> _priceRangeMap = {
    'Under EGP 500': [0, 500],
    'EGP 500 - EGP 1000': [500, 1000],
    'EGP 1000 - EGP 2000': [1000, 2000],
    'Above EGP 2000': [2000, 10000],
  };

  Map<String, bool> _expandedInfo = {
    'Acne': false,
    'Dark Circles': false,
    'Under Eye Wrinkles': false,
    'Under Eye Puffiness': false,
    'Eye Bags': false,
    'Dry Skin': false,
    'Dark Spots': false,
    'Pigment Spots': false,
  };

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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              'PLEASE, SELECT YOUR CONCERNS',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: <Widget>[
                  buildCheckboxListTile('Acne'),
                  buildCheckboxListTile('Dark Circles'),
                  buildCheckboxListTile('Under Eye Wrinkles'),
                  buildCheckboxListTile('Under Eye Puffiness'),
                  buildCheckboxListTile('Eye Bags'),
                  buildCheckboxListTile('Dry Skin'),
                  buildCheckboxListTile('Dark Spots'),
                  buildCheckboxListTile('Pigment Spots'),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Select Budget',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
                Switch(
                  value: _showBudgetOptions,
                  onChanged: (bool value) {
                    setState(() {
                      _showBudgetOptions = value;
                    });
                  },
                ),
              ],
            ),
            if (_showBudgetOptions) // Show budget options if selected
Padding(
  padding: const EdgeInsets.only(top: 10.0),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: _priceOptions.map((String value) {
      String label = value;
      // Adjust label to show range inside button
      if (value.startsWith('EGP')) {
        List<int> range = _priceRangeMap[value]!;
        label = '$value (${range[0]} - ${range[1]})';
      }
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: SizedBox(
          width: double.infinity, // Ensures buttons expand to fill width
          child: ElevatedButton(
            onPressed: () {
              setState(() {
                _selectedPrice = value;
              });
            },
            style: ElevatedButton.styleFrom(
              foregroundColor: _selectedPrice == value ? Colors.white : Colors.black, backgroundColor: _selectedPrice == value ? Colors.purple : Colors.grey[200],
              padding: const EdgeInsets.all(16.0), // Adjust padding here
            ),
            child: Text(label),
          ),
        ),
      );
    }).toList(),
  ),
),

            const SizedBox(height: 20),
            Center(
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      if (_selectedConcerns.isEmpty ||
                          (_showBudgetOptions && _selectedPrice == null)) {
                        // Show alert if no concerns or budget selected (if budget is required)
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              content: const Text(
                                  'Please Choose Your Concerns.'),
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
                        int lowPrice = _showBudgetOptions
                            ? _priceRangeMap[_selectedPrice!]![0]
                            : 0;
                        int highPrice = _showBudgetOptions
                            ? _priceRangeMap[_selectedPrice!]![1]
                            : 10000;

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Recommendation(
                              concerns: _selectedConcerns,
                              lowPrice: lowPrice,
                              highPrice: highPrice,
                            ),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFD9D9D9),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 50.0, vertical: 15.0),
                    ),
                    child: const Text(
                        'TAP HERE TO SEE YOUR SUGGESTED PRODUCTS'),
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
    );
  }

  Widget buildCheckboxListTile(String title) {
    return Column(
      children: [
        ListTile(
          leading: IconButton(
            icon: _expandedInfo[title] ?? false
                ? Icon(Icons.arrow_drop_up)
                : Icon(Icons.arrow_drop_down),
            onPressed: () {
              setState(() {
                _expandedInfo[title] = !_expandedInfo[title]!;
              });
            },
          ),
          title: Text(title),
          trailing: Checkbox(
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
          ),
        ),
        if (_expandedInfo[title] ?? false) // Show more info if expanded
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              getMoreInfo(title), // Replace with your actual info fetching method
              style: TextStyle(fontSize: 14.0),
            ),
          ),
      ],
    );
  }

  // Dummy method to fetch more info
  String getMoreInfo(String concern) {
    switch (concern) {
      case 'Acne':
        return 'Acne is a common skin condition that occurs when hair follicles become clogged with oil and dead skin cells. It can cause whiteheads, blackheads or pimples. Acne is most common among teenagers, though it affects people of all ages.';
      case 'Dark Circles':
        return 'Dark circles under the lower eyelids are common in men and women. Often accompanied by bags, dark circles can make you appear older than you are. They are usually caused by fatigue.';
      case 'Under Eye Wrinkles':
        return 'Under-eye wrinkles are a common sign of aging caused by the thinning of the skin and loss of collagen. Factors such as sun exposure, smoking, and facial expressions can contribute to their formation.';
      case 'Under Eye Puffiness':
        return 'Under-eye puffiness can be caused by fluid retention, lack of sleep, allergies, and aging. It can make the eyes appear swollen and tired.';
      case 'Eye Bags':
        return 'Eye bags can result from fluid retention, fat moving to a different area below the eye, and occasionally, from certain medical conditions. As you age, you may notice bags forming around your eyes, which is quite common. Bags under the eyes do not usually signify a serious condition.';
      case 'Dry Skin':
        return "Dry skin is skin that doesn't have enough moisture in it to keep it feeling soft. The medical term for dry skin is xeroderma (pronounced “ze-ROW-derm-ah”). Xerosis (pronounced “ze-ROW-sis”) is severely dry skin. Dry skin feels like rough patches of your skin that can flake or look scaly.";
      case 'Dark Spots':
        return 'Dark spots on the skin, or hyperpigmentation, occur due to an overproduction of melanin. Melanin gives the eyes, skin, and hair their color. Depending on the cause, people may call some types of dark spots on the skin age spots or sunspots. These spots can vary in size and amount from person to person';
      case 'Pigment Spots':
        return 'Hyperpigmentation is a common condition that makes some areas of the skin darker than others. “Hyper” means more, and “pigment” means color. Hyperpigmentation can appear as brown, black, gray, red or pink spots or patches. The spots are sometimes called age spots, sun spots or liver spots.';
      default:
        return '';
    }
  }
}
