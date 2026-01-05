import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

  saveData() async {
    var storage = await SharedPreferences.getInstance();
    storage.setString('name','Himuro'); // 저장
    var res1 = storage.get('name');
    print(res1);

    storage.setBool('w', false);
    storage.setDouble('x', 9.13);
    storage.setInt('y', 23);
    storage.setStringList('z', ['시온','리사','재희','로제']);
    
    var res2 = storage.get('w');
    var res3 = storage.get('x');
    var res4 = storage.get('y');
    var res5 = storage.getStringList('z')?[3];
    
    print('bool 데이터 : $res2');
    print('double 데이터 : $res3');
    print('int 데이터 : $res4');
    print('list 데이터 : $res5');
    
    storage.remove('w'); // 삭제하기
    storage.clear(); // 모두 삭제

    // map 저장하기
    var map = {'name': 'Raye', 'age' : 26};
    storage.setString('map', jsonEncode(map));

    var res6 = storage.get('map');
    print('map : $res6');
    // print(jsonDecode(res6)); 오류 -> null일수도 있으므로 null 처리 필수!
    var res7 = storage.getString('map') ?? '데이터 없다';
    print(jsonDecode(res7)['age']);
  }

  setUserContent(newContent) {
    setState(() {
      userContent = newContent;
    });
  }

  @override
  void initState() {
    super.initState();
    getData();
    saveData();
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
    var myCon = {
      "id": 101,
      "image": userImage,
      "likes": 0,
      "date": "Oct 27",
      "content": userContent,
      "liked": false,
      "user": "Arisa Kim"
    };
    setState(() {
      feedItems.insert(0, myCon);
    });
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
            widget.feedItems[i]['image'].runtimeType == String
                ? Image.network(widget.feedItems[i]['image'])
                : Image.file(widget.feedItems[i]['image']),

            Container(
              padding: EdgeInsets.all(20),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('좋아요 : ${widget.feedItems[i]['likes']}'),
                  Text('글쓴이 : ${widget.feedItems[i]['user']}'),
                  Text('내용 : ${widget.feedItems[i]['content']}')
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