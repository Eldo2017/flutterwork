import 'package:flutter/material.dart';
/*
  * 자식이 부모의 state 변경하기
    1. 부모가 수정 함수 만들기
    2. 자식에게 state 보내기
    3. 자식은 등록하고 사용
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
  var name = ['이종길', '채순임', '김덕우', '송민선', '오택언'];
// 1. state 만들기
  var total = 5;    // 친구수

  // 3. 수정 함수 만들기
  addFriend() {
    setState(() {
      total++;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print(context);
          showDialog(
              context: context,
              builder: (context) {
// 4. 자식에게 함수 보내기
                return CustomDialog(friendState : addFriend);
              }
          );
        },
        child: Text(''),
      ),
      appBar: AppBar(
        backgroundColor: Color(0xfff3edf7),
        leading: Icon(Icons.list),
// 2. 출력 : CustomDialog에서 완료 버튼을 누르면 숫자가 1증가
        title: Text(total.toString()),
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
  // 5.  등록하기
  const CustomDialog({super.key, this.friendState});
  final friendState;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SizedBox(
        width: 300,
        height: 300,
        child: Column(
          children: [
            TextField(),
            // 6. 사용하기
            TextButton(onPressed: (){
              friendState();
              Navigator.pop(context);
            },
                child: Text('완료')
            ),
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