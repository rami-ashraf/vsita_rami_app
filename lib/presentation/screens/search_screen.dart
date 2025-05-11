import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../widgets/custom_bottom_nav_bar.dart'; // Import the CustomBottomNavBar widget

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Screen'),
      ),
      body: const Center(
        child: Text('This is the Search Screen'),
      ),
      bottomNavigationBar: CustomBottomNavBar(currentIndex: 2), // Set current index to 2 (for Search tab)
    );
  }
}
