
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_contacts/flutter_contacts.dart';

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
  getPermission() async {
    if (!await FlutterContacts.requestPermission(readonly: true)) {
      print('거절됨');
      return;
    }
    print('허락됨');
    List<Contact> contacts = await FlutterContacts.getContacts(
        withProperties: true);
    setState(() {
      name = contacts;
    });
  }

  List<Contact> name = [];    // List<dynamic> 타입이 됨

  addName() async {
    var contacts = await FlutterContacts.getContacts(withProperties: true);
    setState(() {
      name = contacts;
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
                return CustomDialog(addName : addName);
              }
          );
        },
        child: Text('Dialog'),
      ),
      appBar: AppBar(
        backgroundColor: Color(0xfff3edf7),
        leading: Icon(Icons.list),
        title: Text('주소록'),
        actions: [IconButton(onPressed: (){getPermission();}, icon: Icon(Icons.contacts_outlined)), Icon(Icons.search), Icon(Icons.share)],
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(10),
        itemCount: name.length,
        itemBuilder: (context, index) {
          return ListTile(
            // leading: Image.asset('assets/user${index+1}.png'),
            title: Text(name[index].displayName ?? '이름 없음'),
            subtitle: Text(name[index].phones.isNotEmpty ? name[index].phones[0].number : '전번 없다'),
          );
        },
      ),
      bottomNavigationBar: CustomBottom(),
    );
  }
}

// 3. 등록
class CustomDialog extends StatelessWidget {
  CustomDialog({super.key, this.addName});
  final addName;
  var inputData = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SizedBox(
        width: 300,
        height: 300,
        child: Column(
          children: [
            TextField(controller: inputData,),
            TextButton(onPressed: () async {
              try {
                var newContact = Contact();
                newContact.name.first = inputData.text;
                await newContact.insert(); // 핸드폰의 주소록에 넣기
                await addName();
                Navigator.pop(context);
              } catch(e) {
                print('등록 실패');
              }
            }, child: Text('완료')),
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
