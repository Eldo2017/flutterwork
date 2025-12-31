import 'package:flutter/material.dart';
/*
* 커스텀 위젯 : class로 만듬. 첫글자 대문자로 만듬
  - 재사용이 많은 UI들
  - 큰 페이지들
  - 모두 커스텀 위젯으로 만들면 state관리가 어려워짐

* 변수로 사용해도됨
  : 고정적이고 변함이 없는것은 변수로 해도됨.(BottomBar 같은 것들)
 */
void main() {
  runApp(const MyApp());
}



class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(),
          // body: ProItems()  // 커스텀 위젯 사용
          body: proItems    // 변수 사용
      ),
    );
  }
}

/*
// 커스텀 위젯
class ProItems extends StatelessWidget {
  const ProItems({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Text('안녕'),
    );
  }
}
*/

// 변수로 사용
var proItems = SizedBox(
  child: Text('안녕'),
);