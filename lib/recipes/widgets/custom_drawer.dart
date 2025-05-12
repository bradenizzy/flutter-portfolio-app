// custom_drawer.dart

import 'package:flutter/material.dart';
import 'package:flutter_portfolio_app/recipes/services/custom_drawer_service.dart';

class CustomDrawer extends StatelessWidget {
  final CustomDrawerService _drawerService = CustomDrawerService();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Color(0xFFF9728C),
            ),
            child: Text(
              'Menu',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          // TODO: SET UP EACH OF THESE ROUTES
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Home'),
            onTap: () {
              Navigator.pop(context); // Close the drawer
              Navigator.pushNamed(context, '/recipe');
            },
          ),
          ListTile(
            leading: Icon(Icons.account_circle),
            title: Text('My Account'),
            onTap: () {
              Navigator.pushNamed(context, '/profile');
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
            onTap: () {
              //TODO: IMPLEMENT SETTINGS!
             //Navigator.pushNamed(context, '/settings');
            },
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Sign Out'),
            onTap: () => _drawerService.signOut(context),
          ),
        ],
      ),
    );
  }
}