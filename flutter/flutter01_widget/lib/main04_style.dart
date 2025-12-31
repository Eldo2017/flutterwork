import 'package:flutter/material.dart';
// AppBar()

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MarketPage(),
    );
  }
}

class MarketPage extends StatelessWidget {
  const MarketPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xfff3edf7),
          leading: Icon(Icons.list), // 왼쪽
          title: Text('잠실6동'),
          actions: [
            Icon(Icons.search),
            SizedBox(width: 8),
            Icon(Icons.list),
            SizedBox(width: 8),
            Icon(Icons.notifications),
            SizedBox(width: 12),
            IconButton(
                onPressed: (){},
                icon: const Icon(Icons.search),
            ),
            IconButton(
                onPressed: (){},
                icon: const Icon(Icons.menu)),
          ], // 오른쪽
        ),
        body: ListView(
          padding: const EdgeInsets.all(12),
          children: const [
            ProductCard(

            )
          ],
        )
        )
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  const ProductCard ({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder(
    );
  }
}

