import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var x = 1;
  var name = ['김재설', '이찬열', '박종인','권도혁','백준식'];
  // 1. state 생성
  var likes = [0,0,0,0,0];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
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
                leading: Text(likes[index].toString()),
                title: Text(name[index]),
                // 3. 버튼 생성 -> setState
                trailing: ElevatedButton(
                    onPressed: (){
                      setState(() {
                        likes[index]++;
                      });
                    }, 
                    child: Text('좋아요')
                ),
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