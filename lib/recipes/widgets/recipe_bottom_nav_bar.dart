// recipe_bottom_nav_bar.dart

import 'package:flutter/material.dart';

class RecipeBottomNavBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
     return BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'My Recipes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
        ],
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushNamed(context, '/recipe');
              break;
            case 1:
              // TODO: implement bottom nav bar options
              // Navigator.pushNamed(context, '/my_recipes');
              break;
            case 2:
              // TODO: implement bottom nav bar options
              // Navigator.pushNamed(context, '/favorites');
              break;
          }
        },
      );
  }
}