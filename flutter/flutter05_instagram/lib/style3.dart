import 'package:flutter/material.dart';

var theme = ThemeData(
    textTheme: TextTheme(
      bodyMedium: TextStyle(
        color: Colors.lightBlueAccent,
        fontSize: 30
      ),
      bodyLarge: TextStyle(
        color: Colors.orangeAccent
      )
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Color(0xfff3edf7),
      actionsIconTheme: IconThemeData(color: Colors.black),
      titleTextStyle: TextStyle(color: Colors.black),
    ),
);