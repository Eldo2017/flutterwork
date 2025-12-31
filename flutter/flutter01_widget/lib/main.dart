import 'package:flutter/material.dart';
// container 정렬
// margin, padding, 정렬위젯(Align())
void main() {
  runApp(const MyApp());
}

/*
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // home: Text('어우야'),

      // home: Image.asset('assets/grenade.png'),
      // home: Image.asset('grenade.png'),
      // width: height가 적용이 안되는 이유 : 박스 기준이 없어서다
      
      // alt + enter : Wrap Center를 넣을 수 있다
      // home: Center(child: Container(width: 50, height: 50, color: Colors.yellowAccent,)),

      home: Center(
        child: Container(
          child: Text('섹'),
          width: 500,
          height: 100,
          color: Colors.cyan,
        ),
      )
    );
  }
}
*/

/*
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
          body: Container(
            width: 100,
            height: 100,
            color: Colors.cyan,
            // margin: EdgeInsets.all(20),
            margin: EdgeInsets.fromLTRB(10, 20, 0, 0),
            padding: EdgeInsets.all(15),
            child: Text('안티 니에미'),
          ),
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
*/

/*
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
          body: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black87),
              borderRadius: BorderRadius.all(Radius.circular(13))
            ),
            // margin: EdgeInsets.fromLTRB(20,30,0,0),
            padding: EdgeInsets.all(10),
            child: Text('안티 니에미'),
          ),
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
*/

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
          body: Align(
            alignment: Alignment.bottomRight,
            child: Container(
              // width: 100,
              width: double.infinity, // 폭의 전체 자리차지
              height: 100,
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.black87),
                  borderRadius: BorderRadius.all(Radius.circular(13))
              ),
              padding: EdgeInsets.all(10),
              child: Text('안티 니에미'),
            ),
          ),
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