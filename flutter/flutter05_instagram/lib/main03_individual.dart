import 'package:flutter/material.dart';
import 'package:flutter05_instagram/style.dart';
import './style3.dart' as style;

/*
 ★ 탭 제작(Tab widget이 있다. 단, 나주에 커스터마이징을 하는 경우 필수)
    1) state에 tab의 현재 상태 저장
    2) state에 따라 tab이 어떻게 보일지를 작성
    3) 유저가 쉽게 state를 조작할 수 있게 조작
 */
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
  var tab = 1;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Instagram'),
          actions: [
            IconButton(
                onPressed: (){

                },
                icon: Icon(Icons.add_box_outlined)
            )
          ],
      ),
      body: [Text('Home Page'), Text('Shop Page')][tab],
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


