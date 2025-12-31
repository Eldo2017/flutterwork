import 'package:flutter/material.dart';

/*
 - state(변수)
    > 일반 변수와 다른 점 : 변경이 되면 재렌더링함
    > state를 쓰려면 StatefulWidget 내에서 사용
 */

void main() {
  runApp(MyApp());
}

/*
class MyApp extends StatelessWidget {
  MyApp({super.key});
  // const로 만들어진 위젯 내 모든 필드는 final이어야 한다
  // final x = 1;
  // 또는 const를 제외하고 일반 변수를 만들어도 상관없다
  var x = 1;
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        floatingActionButton: FloatingActionButton(
            onPressed: (){},
            child: Text('버튼'),
        ),
        appBar: AppBar(
          backgroundColor: Color(0xfff3edf7),
          leading: Icon(Icons.list),
          title: Text('주소록'),
          actions: [Icon(Icons.search),Icon(Icons.share)],
        ),
        body: ListView.builder(
            padding: EdgeInsets.all(10),
            itemCount: 5, // 반복 횟수
            itemBuilder: (context, index) {
              return ListTile(
                leading: Image.asset('assets/user2.png'),
                title: Text('김미라'),
              );
            }
        ),
        bottomNavigationBar: CustomBottom(),
      ),
    );
  }
}

class CustomBottom extends StatelessWidget {
  const CustomBottom({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Icon(Icons.phone),
            Icon(Icons.article_outlined),
            Icon(Icons.contact_page_outlined)
          ],
        )
    );
  }
}
 */

// state 사용하기 -> stful로 자동 생성하면 StatefulWidget 자동 생성
// 재렌더링 필요한 값은 setState(){} 내에 넣음 된다
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var x = 1;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: (){
            setState(() {
              x++;
            });
          },
          child: Text(x.toString(), style: TextStyle(fontSize: 25)),
        ),
        appBar: AppBar(
          backgroundColor: Color(0xfff3edf7),
          leading: Icon(Icons.list),
          title: Text('주소록'),
          actions: [Icon(Icons.search), Icon(Icons.share)],
        ),
        body: ListView.builder(
            padding: EdgeInsets.all(10),
            itemCount: 5, // 반복 횟수
            itemBuilder: (context, index) {
              return ListTile(
                leading: Image.asset('assets/user2.png'),
                title: Text('김미라'),
              );
            }
        ),
        bottomNavigationBar: CustomBottom(),
      ),
    );
  }
}

class CustomBottom extends StatelessWidget {
  const CustomBottom({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Icon(Icons.phone),
            Icon(Icons.article_outlined),
            Icon(Icons.contact_page_outlined)
          ],
        )
    );
  }
}