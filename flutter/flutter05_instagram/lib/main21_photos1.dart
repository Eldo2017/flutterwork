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

void main() {
  runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => Store1()),
          ChangeNotifierProvider(create: (context) => Store2())
        ],
        child: MaterialApp(
          theme: style.theme,
          home: const MyApp(),
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

  addMyData() {
    String formattedData = DateFormat('MMM dd').format(DateTime.now());
    var myData = {
      "id": feedItems.length,
      "image": userImage,
      "likes": 0,
      "date": formattedData,
      "content": userContent,
      "liked": false,
      "user": "Jack Yun"
    };
    setState(() {
      feedItems.insert(0, myData);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:Text('Instargram'),
        actions: [
          IconButton(
              onPressed: () async {
                var picker = ImagePicker();
                var image = await picker.pickImage(source: ImageSource.gallery);
                if(image != null) {
                  setState(() {
                    userImage = File(image.path);
                  });
                }
                Navigator.push(context, MaterialPageRoute(builder: (context) => Upload(
                    userImage: userImage,
                    setUserContent: setUserContent,
                    addMyData : addMyData
                )));
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
                : Image.file(widget.feedItems[i]['image'], height: 400, width: double.infinity, fit: BoxFit.cover),

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
                          PageRouteBuilder(pageBuilder: (context, a1, a2) => Profile(),
                              transitionsBuilder: (context, a1, a2, child) => FadeTransition(opacity: a1, child: child),
                              transitionDuration: Duration(milliseconds: 1000)
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
  var follower = 0;
  var isFollower = false;
  var profileImage = [];

  getData() async {
    var result = await http.get(Uri.parse('https://raw.githubusercontent.com/Eldo2017/flutterwork/main/flutter/data/profile.json'));
    var result2 = jsonDecode(result.body);
    profileImage = result2;
    notifyListeners();
  }

  addFollower() {
    if(isFollower) {
      follower--;
      isFollower = false;
    } else {
      follower++;
      isFollower = true;
    }
    notifyListeners();
  }
}

class Store2 extends ChangeNotifier {
  var name = 'Manju Hong';
}

class Upload extends StatelessWidget {
  const Upload({super.key, this.userImage, this.setUserContent, this.addMyData});
  final userImage;
  final setUserContent;
  final addMyData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(onPressed: (){
            addMyData();
            Navigator.pop(context);
          }, icon: Icon(Icons.send))
        ],
      ),
      body: Column(
        children: [
          Image.file(userImage),
          Text('이미지 업로드 화면'),
          TextField(onChanged: (text) {
            setUserContent(text);
          }),
          IconButton(onPressed: (){ Navigator.pop(context); }, icon: Icon(Icons.close))
        ],
      ),
    );
  }
}

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(context.watch<Store2>().name)),
        body: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                CircleAvatar(
                    radius: 30,
                    backgroundImage: AssetImage('assets/Manju hong.webp')
                ),

                Text(
                  '팔로워 ${context.watch<Store1>().follower}명',
                  style: TextStyle(fontSize: 16),
                ),

                ElevatedButton(
                  onPressed: (){
                    context.read<Store1>().addFollower();
                  },
                  child: Text('팔로우')
                ),
                ElevatedButton(
                    onPressed: (){
                      context.read<Store1>().getData();
                    }, 
                    child: Text('사진 가져오기')
                )
              ],
            ),

            Expanded(
                child: ListView.builder(
                    itemCount: context.watch<Store1>().profileImage.length,
                    itemBuilder: (context, idx) {
                      var img = context.watch<Store1>().profileImage[idx];
                      return Padding(
                        padding: EdgeInsets.all(5),
                        child: Image.network(img),
                      );
                    }
                )
            ),
          ],
        ),
    );
  }
}
