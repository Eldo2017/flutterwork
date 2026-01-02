import 'package:flutter/material.dart';
import './style.dart' as style;

void main() {
  runApp(
      MaterialApp(
        theme: style.theme,
        home: const MyApp(),
      )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Instagram'), actions: [Icon(Icons.heart_broken_sharp)]),
      body: Column(
        children: [
          Icon(Icons.star),
          Text('이것은 수류탄이여!')
        ],
      ),
    );
  }
}


