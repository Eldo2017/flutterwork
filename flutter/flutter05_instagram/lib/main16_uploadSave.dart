import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import './style.dart' as style;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

/*
  기존 방식
  > 앱을 다시 키면은 upload를 한 내용이 사라진다
  > 사라지지 않게 하기 위해선 DB에 저장한다든가, 로컬에 저장한다

  shared preference (localStorage와 유사)
  : 로컬 저장소
  넣을 때 : set자료형('키','값')
  가져올 때 : get자료형('키')
             get('키') => 데이터 자료형을 모르는 경우면, Object나 dynamic으로 반환한다
             -> 자료를 형변환해야 하는 상황이 생길 수도 있다

 */

void main() {
  runApp(
      MaterialApp(
        theme: style.theme,
        initialRoute: '/',
        routes: {
          '/' : (context) => MyApp(),
        },
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
  var userImage;
  var userContent;

  // shared에 저장하기
  saveData() async {
    var storage = await SharedPreferences.getInstance();
    List<String> StringList = feedItems.map((item) => jsonEncode(item)).toList();
    await storage.setStringList('items', StringList);
  }

  // shared에서 가져오기
  loadData() async {
    var storage = await SharedPreferences.getInstance();
    List<String>? StringList = storage.getStringList('items');

    if(StringList != null) {
      List<Map<String, dynamic>> restored =
        StringList.map((item) => jsonDecode(item) as Map<String, dynamic>).toList();

      setState(() {
        feedItems = restored;
      });
    } else {
      getData();
    }
  }

  setUserContent(newContent) {
    setState(() {
      userContent = newContent;
    });
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  getData() async {
    var result = await http.get(Uri.parse('https://raw.githubusercontent.com/Eldo2017/flutterwork/main/flutter/data/MyData1.json'));
    if(result.statusCode == 200) {
      var result2 = jsonDecode(result.body);
      setState(() {
        feedItems = result2;
      });
    } else {
      throw Exception('서버에서 가져오기 실패');
    }
  }

  addData(a) {
    setState(() {
      feedItems.addAll(a);
    });
  }

  addContent() {
    // var now = DateTime.now();
    // var formatter = DateFormat('MMM dd');
    String formattedData = DateFormat('MMM dd').format(DateTime.now());
    var myCon = {
      "id": feedItems.length,
      "image": userImage is String ? userImage : userImage.path,
      "likes": 0,
      "date": formattedData,
      "content": userContent,
      "liked": false,
      "user": "Arisa Kim"
    };
    setState(() {
      feedItems.insert(0, myCon);
    });
    saveData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:Text('Instagram'),
        actions: [
          IconButton(
              onPressed: () async {
                var picker = ImagePicker();
                var image = await picker.pickImage(source: ImageSource.gallery);
                if(image != null) {
                  setState(() {
                    userImage = File(image.path);

                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Upload(
                              userImage: userImage,
                              setUserContent: setUserContent,
                              addMyCon: addContent,
                            )
                        )
                    );
                  });
                }
              },
              icon: Icon(Icons.add_box_outlined)
          )
        ],
      ),
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

class Home extends StatefulWidget {
  const Home({super.key, this.feedItems, this.addData});
  final feedItems;
  final addData;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var scroll = ScrollController();

  bool isLoading = false;
  bool hasMore = true;
  int page = 1;

  getMore() async {
    if(isLoading || !hasMore) return;

    isLoading = true;
    var result = await http.get(Uri.parse('https://raw.githubusercontent.com/Eldo2017/flutterwork/main/flutter/data/MyData$page.json'));
    if(result.statusCode == 200) {
      var result2 = jsonDecode(result.body);
      if(result2.isEmpty) {
        hasMore = false;
      } else {
        widget.addData(result2);
        page++;
      }
    } else {
      hasMore = false;
      throw Exception('서버에서 가져오기 실패');
    }
    isLoading = false;
  }

  @override
  void initState() {
    super.initState();
    scroll.addListener((){
      if(scroll.position.pixels >= scroll.position.maxScrollExtent-100) {
        getMore();
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    if(widget.feedItems.isNotEmpty) {
      return ListView.builder(itemCount: widget.feedItems.length, controller: scroll, itemBuilder: (c, i) {
        return Column(
          children: [
            widget.feedItems[i]['image'].runtimeType == String && (widget.feedItems[i]['image'] as String).startsWith('http')
                ? Image.network(widget.feedItems[i]['image'])
                : Image.file(File(widget.feedItems[i]['image']), height: 400, width: double.infinity, fit: BoxFit.cover),

            Container(
              padding: EdgeInsets.all(20),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('좋아요 : ${widget.feedItems[i]['likes']}'),
                  Text('글쓴이 : ${widget.feedItems[i]['user']}'),
                  Text('내용 : ${widget.feedItems[i]['content']}'),
                  Text('날짜 : ${widget.feedItems[i]['date']}')
                ],
              ),
            ),
          ],
        );
      }
      );
    } else {
      return Center(child: CircularProgressIndicator());
    }
  }
}

class Upload extends StatelessWidget {
  const Upload({super.key, this.userImage, this.setUserContent, this.addMyCon});
  final userImage;
  final setUserContent;
  final addMyCon;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(onPressed: (){
            addMyCon();
            Navigator.pop(context);
          }, icon: Icon(Icons.send))
        ],
      ),
      body: Column(
        children: [
          Image.file(userImage),
          Text('이미지 업로드 화면'),
          TextField(onChanged: (text){
            setUserContent(text);
          }),
          IconButton(onPressed: (){ Navigator.pop(context); }, icon: Icon(Icons.close))
        ],
      ),
    );
  }
}