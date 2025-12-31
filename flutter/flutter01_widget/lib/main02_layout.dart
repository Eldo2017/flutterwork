import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
            title: Text('예제'),
            backgroundColor: Color(0xfff3edf7)
        ),
        body: Center(child: Text('본문 내용')),
        bottomNavigationBar: BottomAppBar(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Icon(Icons.thumb_up),
              Icon(Icons.emoji_events),
              Icon(Icons.shopping_cart)
            ],
          ),
        ),
      )
    );
  }
}
