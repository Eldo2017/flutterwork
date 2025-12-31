import 'package:flutter/material.dart';
// SizeBox() : 간단한 박스
//  - 속성 : width, height, child
//    > 많은 속성이 필요 시에는 Container를 사용

// style() : 위젯에 대한 스타일을 넣기
void main() {
  runApp(const MyApp());
}

// 버튼 스타일
//  - TextButton, IconButton, ElevatedButton

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
          body: Center(
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xffffcc00),
                borderRadius: BorderRadius.circular(13)
              ),
              child: IconButton(
                onPressed: (){
                },
                icon: Icon(
                  Icons.favorite,
                  size: 70,
                  color: Colors.pinkAccent,
                ),
                padding: EdgeInsets.all(17),
              ),
            )
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


// 버튼
//  - TextButton(), IconButton(), ElevatedButton()
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
        body: SizedBox(
          // child: TextButton(onPressed: (){}, child: Text('TextButton')),
          // child: ElevatedButton(onPressed: (){}, child: Text('ElevatedButton')),
          child: IconButton(
              onPressed: (){
                // 클릭시 실행할 코드
              },
              icon: Icon(
                Icons.favorite,
                size: 50,
                color: Colors.purple,
              )
          ),
        ),
      ),
    );
  }
}
*/

/*
   child: Text('역대급 웃긴 축구선수 모음',
     style: TextStyle(
     color: Color(0xffff43a7),
     fontSize: 50,
     fontWeight: FontWeight.w700
    ),
 */
/*
   child: Icon(
     Icons.ac_unit_outlined,
     color: Colors.red,
     size: 50, // 기본 사이즈 : 24
   ),
 */