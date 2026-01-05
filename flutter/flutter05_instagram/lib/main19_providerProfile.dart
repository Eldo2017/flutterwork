import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import './style.dart' as style;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:provider/provider.dart';

/*
  > 넘겨줘야 할 값이 있을 때 하위 위젯이 많으면 넘겨주기가 귀찮다
  * Provider : 전송 없이 위젯이 state를 직접 가져다가 쓸 수 있게 해주는 패키지
               (플러터 기본 기능에 InheritedWidget이 있으나, 문법이 어려워서 패키지 설치 후 사용을 권장한다)
       - state 보관하는 storage 필요 : 모든 위젯들이 공유할 state들은 class를 따로 만들어야 한다
         순서 : state class 만들기 -> 등록(ChangeNotifierProvider()로 감싸야 한다) -> 사용하면 끝
 */

void main() {
  runApp(
      ChangeNotifierProvider(
        create: (context) => Store1(),
        child: MaterialApp(
          theme: style.theme,
          initialRoute: '/',
          routes: {
            '/' : (context) => MyApp(),
          },
        ),
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

  setUserContent(newContent) {
    setState(() {
      userContent = newContent;
    });
  }

  @override
  void initState() {
    super.initState();
    getData();
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
    String formattedData = DateFormat('MMM dd').format(DateTime.now());
    var myCon = {
      "id": feedItems.length,
      "image": userImage is String ? userImage : userImage.path,
      "likes": 0,
      "date": formattedData,
      "content": userContent,
      "liked": false,
      "user": "Jack Yun"
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
                  GestureDetector(
                    child: Text('글쓴이 : ${widget.feedItems[i]['user']}'),
                    onTap: () {
                      Navigator.push(context,
                        PageRouteBuilder(pageBuilder: (context,a1,a2) => Profile(),
                          transitionsBuilder: (context,a1,a2,child) => FadeTransition(opacity: a1,child: child),
                          transitionDuration: Duration(milliseconds: 3000)
                        )
                      );
                    },
                  ),
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

class Store1 extends ChangeNotifier {
  var name = 'Manju Hong';

  /*
  changeName() {
    // name = 'Manju Hong';
    // 재렌더링은 setState의 사용없이 아래와 같이 사용한다
    notifyListeners();
  }
  */
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

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  int follower = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.watch<Store1>().name)),
      /*
      body: ElevatedButton(
          onPressed: (){
            context.read<Store1>().changeName();
          },
          child: Text('이름 바꾸기')
      )
       */
      body: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          CircleAvatar(
              radius: 35,
              backgroundImage: AssetImage('assets/Manju hong.webp'),
          ),

          SizedBox(width: 15),

          // 팔로워 수
          Text(
            '팔로워 $follower명',
            style: TextStyle(fontSize: 18),
          ),

          SizedBox(width: 15),

          ElevatedButton(
              onPressed: (){
                setState(() {
                  follower = follower == 0 ? 1 : 0;
                });
              },
              child: Text('팔로우하기')
          )
        ],
      ),
    );
  }
}

/*
  - Provider 사용할 때
    > context.watch<>() : state를 출력할 때
    > context.read<>() : state 내 함수를 사용할 때
 */