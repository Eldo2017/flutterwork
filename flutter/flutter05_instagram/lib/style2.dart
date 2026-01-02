import 'package:flutter/material.dart';

var theme = ThemeData(
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        backgroundColor: Colors.purpleAccent,
        foregroundColor: Colors.lightBlue,
        textStyle: TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.bold
        )
      )
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.yellow,
        foregroundColor: Colors.lightBlue,
        textStyle: TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.bold
        )
      )
    ),
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
      titleTextStyle: TextStyle(color: Colors.black, fontSize: 20),
    ),
);