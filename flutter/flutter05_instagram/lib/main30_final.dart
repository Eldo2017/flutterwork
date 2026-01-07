import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter05_instagram/login.dart';
import 'package:flutter05_instagram/notification.dart';
import './style.dart' as style;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:provider/provider.dart';
import 'shop.dart';
import 'homeLarge.dart';

void main() async {
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
    initNotification(context);
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
      "user": "Arisa Kim"
    };
    setState(() {
      feedItems.insert(0, myData);
    });
  }

  @override
  Widget build(BuildContext context) {
    // MediaQuery.of : 현재 기기
    /*
    print('가로: ${MediaQuery.of(context).size.width}');
    print('세로: ${MediaQuery.of(context).size.height}');
    print('기기 상단: ${MediaQuery.of(context).padding.top}');
    print('해상도: ${MediaQuery.of(context).devicePixelRatio}'); // 이 기기는 1LP에 픽셀이 몇 개가 들어가는지를 확인한다
     */

    // 고대비 옵션이 켜져있는지 아닌지를 확인하라
    print(MediaQuery.of(context).highContrast);

    // 폰트 사이즈를 얼마나 키우고 폰을 사용하는지를 확인하라
    print(MediaQuery.of(context).textScaler);

    return Scaffold(
      appBar: AppBar(
        title:Text('Instargram'),
        actions: [
          IconButton(
              onPressed: () {
                showNotificationII();
                print("알림 발신 성공");
              },
              icon: Icon(Icons.access_alarm_sharp)
          ),
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
          ),
          IconButton(
              onPressed: (){
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage())
                );
              },
              icon: Icon(Icons.login)
          )
        ],
      ),
      body: [MediaQuery.sizeOf(context).width > 600 ? Homelarge() : Home(feedItems: feedItems, addData: addData), Shop()][tab],
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
  var name = 'Yusei Kim';
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

const List<String> profileImages = [
  'assets/profile0.jpg',
  'assets/profile1.jpg',
  'assets/profile2.jpg',
  'assets/profile3.jpg',
  'assets/profile4.jpg',
  'assets/profile5.jpg',
  'assets/profile6.jpg',
  'assets/profile7.jpg',
  'assets/profile8.jpg',
  'assets/profile9.jpg',
  'assets/profile10.jpg',
  'assets/profile11.jpg',
  'assets/profile12.jpg',
  'assets/profile13.jpg'
];
class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.watch<Store2>().name)),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: ProfileHeader(),
          ),
          SliverGrid(
              delegate: SliverChildBuilderDelegate(
                  (c, i) {
                    return Image.asset(
                      profileImages[i],
                      fit: BoxFit.cover,
                    );
                  },
                  childCount: profileImages.length,
              ),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 5,
                  crossAxisSpacing: 5
              )
          )
        ],
      ),
    );
  }
}

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        CircleAvatar(
            radius: 30,
            backgroundImage: AssetImage('assets/profile5.jpg')
        ),
        Text('팔로워 ${context.watch<Store1>().follower}명'),
        ElevatedButton(
            onPressed: (){
              context.read<Store1>().addFollower();
            },
            child: Text('팔로우')
        )
      ],
    );
  }
}