// themes.dart

import 'package:flutter/material.dart';

final ThemeData blackjackTheme = ThemeData(
  primarySwatch: Colors.green,
  brightness: Brightness.light,
  scaffoldBackgroundColor: Color.fromARGB(255, 25, 104, 28),
  appBarTheme: AppBarTheme(
    color: Color.fromARGB(255, 25, 104, 28), // Set AppBar background color
    titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
  ),
);

final ThemeData otherModeTheme = ThemeData(
  primarySwatch: Colors.blue,
  brightness: Brightness.dark,
);

final ThemeData thirdModeTheme = ThemeData(
  primarySwatch: Colors.red,
  brightness: Brightness.light,
);
