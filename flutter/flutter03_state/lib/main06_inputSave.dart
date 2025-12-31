import 'package:flutter/material.dart';
/*
* input 데이터 사용
  TextField()위젯은 저장되지 않음. 변수에 저장해야됨
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
  var name = ['김홍균', '조인지', '박종인', '강보송', '최상준'];
  var total = 5;

  // 1. 수정 함수: 입력값을 받아 name에 추가하고 total도 증가되게 한다
  addFriend(String newName) {
    setState(() {
      final trimmed = newName.trim();

      // 1) TextField에 글씨 안넣고 완료만 눌러도 추가
      //   -> 만일 비어있다면 기본 이름만 생성
      final friendName = trimmed.isEmpty ? '새 친구 ${name.length + 1}' : trimmed;

      name.add(friendName);
      total = name.length; // total을 name길이와 동기화
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
                return CustomDialog(friendState : addFriend);
              }
          );
        },
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        backgroundColor: Color(0xfff3edf7),
        leading: Icon(Icons.list),
        title: Text(total.toString()),
        actions: [Icon(Icons.search), Icon(Icons.share)],
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(10),
        itemCount: name.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(name[index]),
          );
        },
      ),
      bottomNavigationBar: CustomBottom(),
    );
  }
}

class CustomDialog extends StatelessWidget {
  // 1. const 지우기
  /* const */ CustomDialog({super.key, required this.friendState});
  final void Function(String) friendState;

  // 2. 변수 만들기
  final TextEditingController inputData = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SizedBox(
        width: 300,
        height: 220,
        child: Padding(
            padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: inputData,
                decoration: const InputDecoration(
                  labelText: '이름을 입력하라',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                      onPressed: (){
                        // 입력값을 부모로 전달해 추가
                        friendState(inputData.text);

                        // 다이얼로그 닫기
                        Navigator.pop(context);
                      },
                      child: const Text('완료'),
                  ),
                  TextButton(
                      onPressed: (){
                        Navigator.pop(context);
                      },
                      child: const Text('취소'),
                  )
                ],
              )
            ],
          ),
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

/*
  1) TextField에 글씨 안넣고 그냥 완료 버튼만 누르면 name에 이름이 추가되게 하라
     1-1) 수정 함수
     1-2) 함수를 보내고 등록하고 사용한다
  2) input 데이터를 변수에 저장해 보내라
 */