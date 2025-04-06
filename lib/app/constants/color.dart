import 'package:flutter/material.dart';

const appPurple = Color(0xFF431AA1);
const appPurpleDark = Color(0xFF1E0771);
const appPurpleLight1 = Color(0xFF9345F2);
const appPurpleLight2 = Color(0xFFB9A2D8);
const appWhite = Color(0xFFFAF8FC);
const appOrange = Color(0xFFE6704A);

ThemeData themeLight = ThemeData(
  tabBarTheme: TabBarTheme(
    labelColor: appPurpleDark,
    unselectedLabelColor: Colors.grey,
    indicator: UnderlineTabIndicator(
      borderSide: BorderSide(color: appPurpleDark, width: 2.0),
    ),
  ),
  brightness: Brightness.light,
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: appPurpleDark,
  ),
  primaryColor: appPurple,
  scaffoldBackgroundColor: Colors.white,
  appBarTheme: AppBarTheme(backgroundColor: appPurple, elevation: 4),
  textTheme: TextTheme(
    bodyLarge: TextStyle(color: appPurpleDark),
    bodyMedium: TextStyle(color: appPurpleDark),
  ),
  listTileTheme: ListTileThemeData(
    textColor: appPurpleDark,
  ),
);

ThemeData themeDark = ThemeData(
  tabBarTheme: TabBarTheme(
    labelColor: appWhite,
    unselectedLabelColor: Colors.grey,
    indicator: UnderlineTabIndicator(
      borderSide: BorderSide(color: appWhite, width: 2.0),
    ),
  ),
  brightness: Brightness.dark,
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: appWhite,
  ),
  primaryColor: appPurpleLight2,
  scaffoldBackgroundColor: appPurpleDark,
  appBarTheme: AppBarTheme(backgroundColor: appPurpleDark, elevation: 0),
  textTheme: TextTheme(
    bodyLarge: TextStyle(color: appWhite),
    bodyMedium: TextStyle(color: appWhite),
  ),
  listTileTheme: ListTileThemeData(
    textColor: appWhite,
  ),
);
