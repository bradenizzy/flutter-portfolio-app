// custom_nav_bar.dart

import 'package:flutter/material.dart';

class CustomBottomNavBar extends StatelessWidget {
  final Function(int) onItemSelected;
  final List<BottomNavigationBarItem> items;

  const CustomBottomNavBar({
    Key? key,
    required this.onItemSelected,
    required this.items,
  }) : super(key: key);

   Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: items,
      onTap: onItemSelected,
      type: BottomNavigationBarType.fixed, 
      selectedFontSize: 12.0,
      unselectedFontSize: 12.0,
      iconSize: 24.0,
      backgroundColor: Colors.black,
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white
    );
  }
}

// anywhere this is used in the app, you need these also...

// int _selectedIndex = 0;

// bottomNavigationBar: CustomBottomNavBar(
//   currentIndex: _selectedIndex,
//   onItemSelected: _onItemTapped,
//   items: const [
//     BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
//     BottomNavigationBarItem(icon: Icon(Icons.gamepad), label: 'Blackjack'),
//     BottomNavigationBarItem(icon: Icon(Icons.camera), label: 'Insta'),
//     BottomNavigationBarItem(icon: Icon(Icons.spoon), label: 'Recipies'),
//   ],
// ),

//void _onItemTapped(int index) {
    // setState(() {
    //   _selectedIndex = index;
    // });
    // switch (index) {
    //   case 0:
    //     Navigator.pushReplacementNamed(context, '/');
    //     break;
    //   case 1:
    //     // Navigator.pushReplacementNamed(context, '/');
    //     break;
    //   case 2:
    //     // Navigator.pushReplacementNamed(context, '/');
    //     break;
    // }