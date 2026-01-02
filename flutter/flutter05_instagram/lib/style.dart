import 'package:flutter/material.dart';

var theme = ThemeData(
    iconTheme: IconThemeData(color: Colors.red),
    appBarTheme: AppBarTheme(
      color: Colors.pinkAccent,
      actionsIconTheme: IconThemeData(color: Colors.black),
      titleTextStyle: TextStyle(color: Colors.black, fontSize: 25),
    ),
    textTheme: TextTheme(
        bodyMedium: TextStyle(color: Colors.deepPurpleAccent, fontSize: 15)
    )
);