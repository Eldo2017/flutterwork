import 'package:flutter/material.dart';
/*
 + 자식이 부모의 변수에 값을 사용하고 싶을 때
  1. 부모가 자식에게 보내기
  2. 자식은 부모가 보내준 변수 등록
  3. 자식이 사용
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
  // 1. 자식에게 보내줄 변수 정의
  var y = 7;
  var nameState;

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
                  // 2. 부모가 자식에게 보내기
                  return CustomDialog(stateVar: y);
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

class CustomDialog extends StatelessWidget {
  // 3. 등록
  const CustomDialog({super.key, this.stateVar, this.nameState});
  final stateVar;
  final nameState;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SizedBox(
        width: 300,
        height: 300,
        child: Column(
          children: [
            TextField(),
            Text(nameState.toString()),
            // 4. 사용
            TextButton(onPressed: (){}, child: Text(stateVar.toString())),
            TextButton(onPressed: (){ Navigator.pop(context); }, child: Text('취소')),
          ],
        ),
      ),
    );
  }
}
