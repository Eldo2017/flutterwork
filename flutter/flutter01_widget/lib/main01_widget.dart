import 'package:flutter/material.dart';

/*
  Layout
  - Scaffold() : 화면을 top, body, bottom으로 분리시킨다
  - Row() : 위젯들을 가로로 배치시킨다
  - Column() : 위젯들을 세로로 배치시킨다
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
        appBar: AppBar(title: Text('앱의 제목'), backgroundColor: Color(0xfff3e)), // top 부분
        body: Text('이브라히마 섹'), // body 부분 - 필수!
        bottomNavigationBar: BottomAppBar(child: Text('하단바')), // bottom 부분
      ),
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
        body: Row(
          // 메인 축 정렬
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          // 메인의 반대축 정렬
          // crossAxisAlignment: CrossAxisAlignment.end,
          // end, center 모두 동일
          crossAxisAlignment: CrossAxisAlignment.stretch, // 이거 하나만 가능하다
          children: [
            Icon(Icons.ac_unit),
            Icon(Icons.abc_outlined),
            Icon(Icons.eighteen_mp_outlined)
          ],
        ),
      )
    );
  }
}