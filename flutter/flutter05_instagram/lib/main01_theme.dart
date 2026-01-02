import 'package:flutter/material.dart';

/*
 * 스타일을 한 곳에
   ThemeData() : 스타일을 모아놓는다(<style></style>과 유사하다)
   - 같은 파일에 넣어도 되고 별도의 파일로 만들어 넣어도 상관없다
 */

void main() {
  runApp(
      MaterialApp(
        theme: ThemeData(
          iconTheme: IconThemeData(color: Colors.red),
          appBarTheme: AppBarTheme(
              color: Colors.pinkAccent,
              actionsIconTheme: IconThemeData(color: Colors.black),
          ),
          textTheme: TextTheme(
            bodyMedium: TextStyle(color: Colors.deepPurpleAccent, fontSize: 35)
          )
        ),
        home: const MyApp(),
      )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(actions: [Icon(Icons.heart_broken_sharp)]),
      body: Column(
        children: [
          Icon(Icons.star),
          Text('이것은 수류탄이여!')
        ],
      ),
    );
  }
}


