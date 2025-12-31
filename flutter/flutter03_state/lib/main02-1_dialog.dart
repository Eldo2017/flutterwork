import 'package:flutter/material.dart';
/*
 - dialog 창

 - context : 커스텀 위젯을 만들때마다 자동으로 하나가 만들어진다
    > 부모 위젯들의 정보를 담고 있는 변수
    > 그리고 그 부모에는 반드시 MaterialApp()이 들어있어야 한다

  >> context를 반드시 매개변수로 받아야 하는 위젯들
     - showDialog()
     - Navigator()
     - Theme.of()
     - Scaffold.of()
 */
void main() {
  runApp(
      MaterialApp(
          home: MyApp()
      )
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var name = ['김재설', '이진영', '박종인','권미라','백준식'];
  // 1. state 생성
  var likes = [0,0,0,0,0];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        floatingActionButton: FloatingActionButton(
            onPressed: (){
              print(context);
              showDialog(
                  context: context,
                  builder: (context) {
                    return Dialog(child: Text('내 이름은 또봇'));
                  }
              );
            },
          child: Text(''),
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
                // 2. 이미지 글자 위젯 바꾸기
                leading: Image.asset('assets/user${index+1}.png'),
                title: Text(name[index]),
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