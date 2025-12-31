import 'package:flutter/material.dart';
/*
* ListView() 위젯
  : 같은 위젯이 반복적으로 들어갈 때(반복문을 써도 되지만 좋은 위젯이 있음)
  - 스크롤바 생김
  - 스크롤의 위치 감시 기능
  - 메모리 절약기능(ListView.builder 일때) : 스크롤을 아래로 내리면 위쪽의 가려지는 부분은 메모리에서 삭제
 */
void main() {
  runApp(const MyApp());
}

/*
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(),
        body: Column(
          children: [
            Text('안녕', style: TextStyle(fontSize: 100)),
            Text('안녕', style: TextStyle(fontSize: 100)),
            Text('안녕', style: TextStyle(fontSize: 100)),
            Text('안녕', style: TextStyle(fontSize: 100)),
            Text('안녕', style: TextStyle(fontSize: 100)),
            Text('안녕', style: TextStyle(fontSize: 100)),
            Text('안녕', style: TextStyle(fontSize: 100)),
            Text('안녕', style: TextStyle(fontSize: 100)),
            Text('안녕', style: TextStyle(fontSize: 100)),
            Text('안녕', style: TextStyle(fontSize: 100)),
          ],
        )
      ),
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
        appBar: AppBar(backgroundColor: Color(0xfff3edf7)),
        body: ListView(
          children: [
            Column(
              children: [
                Row(
                  children: [
                    Image.asset('assets/user1.png', width: 100),
                    SizedBox(width: 20),
                    Text('김여성', style: TextStyle(fontSize: 30))
                  ],
                ),
                Row(
                  children: [
                    Image.asset('assets/user2.png', width: 100),
                    SizedBox(width: 20),
                    Text('이남성', style: TextStyle(fontSize: 30))
                  ],
                ),
              ],
            ),
          ],
        )
      ),
    );
  }
}
*/

/*

// ListTitle : 아이콘, 제목, 부제목 등을 손쉽게 배치
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(backgroundColor: Color(0xfff3edf7)),
        body: ListView(
          children: [
            ListTile(
              leading: Image.asset('assets/user1.png'),
              title: Text('김여성')
            ),
            ListTile(
                leading: Image.asset('assets/user2.png'),
                title: Text('이남성')
            )
          ],
        ),
      ),
    );
  }
}
*/

// ListView.builder() : ListView를 반복해줌
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(backgroundColor: Color(0xfff3edf7)),
        body: ListView.builder(
            itemCount: 100,  // 반복 횟수
            itemBuilder: (context, index) {
              // return Text('반복됨');
              // return Text(index.toString());  // Text() 문자만 가능. 숫자->문자로 변환
              // return Text('반복횟수 : ' + index.toString());
              // return Text('반복횟수 : $index');
              return ListTile(
                  leading: Image.asset('assets/user1.png'),
                  title: Text('친구 $index')
              );
            }
        ),
      ),
    );
  }
}