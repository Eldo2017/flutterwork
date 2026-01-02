import 'package:flutter/material.dart';
import './style.dart' as style;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/rendering.dart'; // 스크롤 관련 유용한 함수들이 대부분 여기에 있다

// 무한 스크롤 : 화면의 맨 하단에 닿았을 때 데이터를 서버에서 가져와 보여주는 역할을 한다


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

  bool isLoading = false;
  int page = 1;

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    if(isLoading) return;
    isLoading = true;

    await Future.delayed(Duration(seconds: 5));

    var url = page == 1
        ? 'https://raw.githubusercontent.com/Eldo2017/flutterwork/main/flutter/data/MyData1.json'
        : 'https://raw.githubusercontent.com/Eldo2017/flutterwork/main/flutter/data/MyData2.json';

    var result = await http.get(Uri.parse(url));

    if (result.statusCode == 200) {
      var newItems = jsonDecode(result.body);

      setState(() {
        feedItems.addAll(newItems);
        page++;
      });
    } else {
      throw Exception('서버에서 가져오지 못했음');
    }

    isLoading = false;
  }

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
      body: [Home(feedItems: feedItems, getMore: getData), Text('Shop Page')][tab],
        bottomNavigationBar: BottomNavigationBar(
            onTap: (i){
              print(i);
              setState(() {
                tab = i;
              });
            },
            items: [
              BottomNavigationBarItem(icon: Icon(Icons.home_outlined),label: 'Home',),
              BottomNavigationBarItem(icon: Icon(Icons.shopping_cart_checkout_sharp), label: 'Shop'),
            ]
        )
    );
  }
}

// StatefulWidget이어야 가능하다. 데이터가 바뀌어서
class Home extends StatefulWidget {
  const Home({
    super.key,
    required this.feedItems,
    required this.getMore
  });
  final feedItems;
  final VoidCallback getMore;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var scroll = ScrollController(); // 스크롤바 위치를 기록한다

  @override
  void initState() {
    super.initState();

    // 스크롤 이벤트 리스너를 등록한다(단 한번만 등록)
    scroll.addListener((){ // 스크롤이 움직일 때마다 호출
      // print('스크롤 위치 변경됨');
      // print(scroll.position.pixels); // 스크롤바가 위에서 얼마나 내려오거나 올라왔는지 높이로 알려준다
      // print(scroll.position.maxScrollExtent);
      // print(scroll.position.userScrollDirection);
      if(scroll.position.pixels == scroll.position.maxScrollExtent) {
        // print('맨 밑까지 스크롤하였습니다');
        widget.getMore(); // 추가 로드
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
                    Text(widget.feedItems[i]['date']),
                    SizedBox(height: 8),

                    Text(widget.feedItems[i]['user']),
                    SizedBox(height: 8),

                    Text(widget.feedItems[i]['content']),
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