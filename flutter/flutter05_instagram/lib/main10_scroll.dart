import 'package:flutter/material.dart';
import './style.dart' as style;
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(
      MaterialApp(
        theme: style.theme,
        home: const MyApp(),
      )
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var tab = 0;
  var feedItems = [];

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    // await Future.delayed(Duration(seconds: 2));
    var result = await http.get(Uri.parse('https://raw.githubusercontent.com/Eldo2017/flutterwork/main/flutter/data/MyData1.json'));

    if(result.statusCode == 200) {
      var result2 = jsonDecode(result.body);
      setState(() {
        feedItems = result2;
      });
    } else {
      throw Exception('서버에서 가져오지 못했음');
    }
  }

  // feedItems 뒤에 하나 추가한다
  addData(a) {
    setState(() {
      feedItems.addAll(a); // 리스트를 펼쳐서 넣어라
    });
  }
  /*
    add() : 리스트 그대로 넣어준다 -> [{},{},{},{}] -> 여러줄을 for 문으로 펼쳐서 넣는다
    addAll() : 리스트를 펼쳐서 넣는다 -> [{},{},{},{},...,{}] -> for문 없이도 리스트를 펼쳐넣을 수 있다
   */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Instagram'),
          actions: [
            IconButton(
                onPressed: () {

                },
                icon: Icon(Icons.add_box_outlined)
            )
          ],
        ),
      // 자식에게 넘겨주기
      body: [Home(feedItems: feedItems, addData: addData), Text('Shop Page')][tab],
      bottomNavigationBar: BottomNavigationBar(
          showSelectedLabels: false,
          showUnselectedLabels: false,
          onTap: (i) {
            print(i);
            setState(() {
              tab = i;
            });
          },
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.shopping_bag_outlined), label: 'Shop')
          ]
      ),
    );
  }
}

// StatefulWidget이어야 가능하다. 데이터가 바뀌어서
class Home extends StatefulWidget {
  const Home({
    super.key,
    required this.feedItems,
    required this.addData
  });
  final feedItems;
  final addData;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var scroll = ScrollController(); // 스크롤바 위치를 기록한다

  // MyData1.json, MyData2.json -> 2개의 페이지만 있으니 더 이상 가져올게 없다면 요청 중단
  bool isLoading = false; // 데이터 요청 여부
  bool hasMore = true; // 더 가져올 데이터가 있는지의 여부
  int page = 1;

  getMore() async {
    if(isLoading || !hasMore) return;
    isLoading = true;

    // await Future.delayed(Duration(seconds: 5));
    var result = await http.get(Uri.parse('https://raw.githubusercontent.com/Eldo2017/flutterwork/main/flutter/data/MyData$page.json'));

    if(result.statusCode == 200) {
      var res2 = jsonDecode(result.body);
      if(res2.isEmpty) {
        hasMore = false;
      } else {
        widget.addData(res2);
        page++;
      }
    } else {
      hasMore = false;
      throw Exception('서버에서 가져오지 못했음');
    }
    isLoading = false;
  }

  @override
  void initState() {
    super.initState();

    scroll.addListener((){
      if(scroll.position.pixels >= scroll.position.maxScrollExtent - 100) {
        getMore();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if(widget.feedItems.isNotEmpty) {
      // 스크롤이 움직일 때마다 스크롤 위치 정보들을 scroll 변수에 기록하라
      return ListView.builder(
        itemCount: widget.feedItems.length,
        controller: scroll,
        itemBuilder: (c, i) {
          return Column(
            children: [
              Image.network(widget.feedItems[i]['image']),
              Container(
                padding: EdgeInsets.all(20),
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('날짜 : ${widget.feedItems[i]['date']}'),
                    SizedBox(height: 8),

                    Text('글쓴이 : ${widget.feedItems[i]['user']}'),
                    SizedBox(height: 8),

                    Text('내용 : ${widget.feedItems[i]['content']}'),
                    SizedBox(height: 8),
                  ],
                ),
              ),
            ],
          );
        },
      );
    } else {
      return Center(child: CircularProgressIndicator());
    }
  }
}