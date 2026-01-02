import 'package:flutter/material.dart';
import 'package:flutter05_instagram/style.dart';

/*
 ★ 탭 제작(Tab widget이 있다. 단, 나주에 커스터마이징을 하는 경우 필수)
    1) state에 tab의 현재 상태 저장
    2) state에 따라 tab이 어떻게 보일지를 작성
    3) 유저가 쉽게 state를 조작할 수 있게 조작
 */
void main() {
  runApp(
      MaterialApp(
        home: const MyApp(),
      )
  );
}

/*
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var tab = 1;
  
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
      body: ListView(
          children: [
            ListView.builder(
                itemCount: 1,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return sameWidget();
                }
            )
          ]
      ),
    );
  }
}

// 사진과 같이 분리
Widget sameWidget() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // 진짜 이미지
      Image.asset(
        'assets/shoma.png',
        width: double.infinity,
        height: 300,
        fit: BoxFit.cover,
      ),

      const SizedBox(height: 8),

      // 좋아요
      const Padding(
        padding: EdgeInsets.symmetric(horizontal: 12),
        child: Text(
          '좋아요 200',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),

      const SizedBox(height: 4),

      // 글쓴이
      const Padding(
        padding: EdgeInsets.symmetric(horizontal: 12),
        child: Text(
          '글쓴이 : 이군밤',
        ),
      ),

      const SizedBox(height: 4),

      // 글 내용
      const Padding(
        padding: EdgeInsets.symmetric(horizontal: 12),
        child: Text(
          '글 내용',
        ),
      ),

      const SizedBox(height: 16),
    ],
  );
}
 */

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var tab = 1;

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