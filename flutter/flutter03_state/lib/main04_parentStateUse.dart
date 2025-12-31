import 'package:flutter/material.dart';
/*
  * 자식이 부모의 변수에 값을 사용하고 싶을 때
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
  var name = ['이기쁨', '채규태', '이고잉', '송미영', '더조은'];
  // 0. 자식에게 보낼줄 변수 정의
  var num = 7;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print(context);
          showDialog(
              context: context,
              builder: (context) {
// 1. 부모가 자식에게 보내기
                return CustomDialog(stateVar : num, nameState : name);
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
        itemCount: 5,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Image.asset('assets/user${index+1}.png'),
            title: Text(name[index]),
          );
        },
      ),
      bottomNavigationBar: CustomBottom(),
    );
  }
}

class CustomDialog extends StatelessWidget {
  // 2.  등록하기
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
            // 3. 사용하기
            // Text(nameState[1]),
            Text(nameState.toString()),
            TextButton(onPressed: (){}, child: Text(stateVar.toString())),
            TextButton(onPressed: (){ Navigator.pop(context); }, child: Text('취소'))
          ],
        ),
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
          Icon(Icons.contacts)
        ],
      ),
    );
  }
}