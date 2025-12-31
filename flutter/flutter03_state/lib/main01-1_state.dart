import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var x = 1;
  var name = ['권두현','최인지','이찬열','김미라','박종인'];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: (){
            setState(() {
              x++;
            });
          },
          child: Text(x.toString(), style: TextStyle(fontSize: 25)),
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
                leading: Image.asset('assets/user${index + 1}.png'),
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