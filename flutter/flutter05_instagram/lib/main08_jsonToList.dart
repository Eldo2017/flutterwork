import 'package:flutter/material.dart';
import './style.dart' as style;
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(
      MaterialApp(
        theme: style.theme,
        home: const MyApp(),
      )
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var tab = 0;

  var feedItems = [];
  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    await Future.delayed(Duration(seconds: 2));
    var result = await http.get(Uri.parse('https://raw.githubusercontent.com/Eldo2017/flutterwork/main/flutter/data/MyData1.json'));

    if(result.statusCode == 200) {
      setState(() {
        feedItems = jsonDecode(result.body);
      });
    } else {
      throw Exception('서버에서 가져오지 못했음');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Instagram'),
        actions: [
          IconButton(
              onPressed: () {

              },
              icon: Icon(Icons.add_box_outlined)
          )
        ],
      ),
      body: [Home(feedItems: feedItems), Text('Shop Page')][tab],
        bottomNavigationBar: BottomNavigationBar(
            onTap: (i){
              print(i);
              setState(() {
                tab = i;
              });
            },
            items: [
              BottomNavigationBarItem(icon: Icon(Icons.home_outlined),label: 'Home',),
              BottomNavigationBarItem(icon: Icon(Icons.shopping_cart_checkout_sharp), label: 'Shop'),
            ]
        )
    );
  }
}

class Home extends StatelessWidget {
  const Home({super.key, required this.feedItems});
  final feedItems;

  @override
  Widget build(BuildContext context) {
    if(feedItems.isNotEmpty) {
      return ListView.builder(
        itemCount: 3,
        itemBuilder: (c, i) {
          return Column(
            children: [
              Image.network(feedItems[i]['image']),
              Container(
                padding: EdgeInsets.all(20),
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(feedItems[i]['date']),
                    SizedBox(height: 8),

                    Text(feedItems[i]['user']),
                    SizedBox(height: 8),

                    Text(feedItems[i]['content']),
                    SizedBox(height: 8),
                  ],
                ),
              ),
            ],
          );
        },
      );
    } else {
      return Center(child: CircularProgressIndicator());
    }
  }
}