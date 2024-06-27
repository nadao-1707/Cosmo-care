import 'package:flutter/material.dart';
import 'package:cosmo_care/Pages/LogIn.dart';

class Loading extends StatefulWidget {
  const Loading({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<Loading> {
  final PageController _controller = PageController(initialPage: 0);
  final List<String> imagePaths = [
    'assets/images/image1.jpg',
    'assets/images/image2.jpg',
    'assets/images/image3.jpg',
  ];

  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    // Automatically swipe images every 2 seconds
    _startAutoSwipe();
  }

  void _startAutoSwipe() {
    // Delay the first swipe and subsequent swipes using recursive function
    Future.delayed(const Duration(seconds: 2), () {
      if (_currentPage < imagePaths.length - 1) {
        _currentPage++;
        _controller.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
        // Call _startAutoSwipe recursively for the next image
        _startAutoSwipe();
      } else {
        // Redirect to login page after swiping the last image
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LogIn()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFCDB7EB), // Background color
      body: PageView.builder(
        controller: _controller,
        itemCount: imagePaths.length,
        itemBuilder: (context, index) {
          return Center(
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(imagePaths[index]),
                  fit: BoxFit.fill, 
                ),
              ),
            ),
          );
        },
        onPageChanged: (index) {
          setState(() {
            _currentPage = index;
          });
        },
      ),
    );
  }
}
