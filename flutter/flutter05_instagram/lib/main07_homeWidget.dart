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

  /*
  @override
  void initState() async { // initState는 async를 쓸 수 없게 막아놨다
    super.initState();
    var result = await http.get(Uri.parse('https://itwon.store/flutter/data/data.json'));
    print('웹상의 json 출력 : ${result.body}');
  }
   */

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    var result = await http.get(Uri.parse('https://itwon.store/flutter/data/data.json'));
    // print('웹상의 json 출력 : ${result.body}');

    // [{},{},{}] -> json 타입 -> list 객체로 변환[{map으로 들어온다},...]
    // print(jsonDecode(result.body));

    var feedItems = jsonDecode(result.body);
    print(feedItems);
    print(feedItems[0]['user']);
    print(feedItems[1]['content']);
    print(feedItems[2]['likes']);
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
      body: [Home(), Text('Shop Page')][tab],
        bottomNavigationBar: BottomNavigationBar(
          // label의 글씨를 안보이게 하는 방법
          // showSelectedLabels: false,
          // showUnselectedLabels: false,
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

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 3,
      itemBuilder: (c,i) {
      return Column(
        children: [
          // Image.asset('assets/shoma.png'),
          // 웹 상의 이미지 사용하려면?
          Image.network('https://static.zerochan.net/Shoma.Stomach.1024.4282195.webp'),
          Container(
            padding: EdgeInsets.all(20),
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('좋아요: 200'),
                SizedBox(height: 8),

                Text('글쓴이: 이군밤'),
                SizedBox(height: 8),

                Text('글내용'),
                SizedBox(height: 8),
              ],
            ),
          ),
        ],
      );
    },
    );
  }
}