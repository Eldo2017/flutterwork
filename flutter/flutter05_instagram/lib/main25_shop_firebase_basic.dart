import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final firestore = FirebaseFirestore.instance;

class Shop extends StatefulWidget {
  const Shop({super.key});

  @override
  State<Shop> createState() => _ShopState();
}

class _ShopState extends State<Shop> {
  @override
  void initState() {
    super.initState();
    getData();
    // setData();
  }

  // firebase에서 가져오기
  /*
  getData() async {
    var res = await firestore.collection('product')
                             .doc('KKRFEPUi57m0M8fBHrp3')
                             .get();

    print('결과: $res');
    // print('가격: ${res['price']}');

    // 컬렉션에 있는 모든 데이터 가져오려면?
    var res2 = await firestore.collection('product').get();

    /*
    for(var doc in res2.docs) {
      print(doc['name']);
    }
     */

    // 서버가 안되거나 하는 케이스라면 미리 대비하라
    if(res2.docs.isNotEmpty) {
      for(var doc in res2.docs) {
        print(doc['name']);
      }
    }
  }
   */

  /*
  // 예외처리 방식도 있다 (try~catch와 같은 식)
  getData() async {
    try {
      var res2 = await firestore.collection('product').get();
      for(var doc in res2.docs) {
        print(doc['name']);
      }
    } catch(e) {
      print('서버가 잘못됐습니다');
    }
  }
   */

  getData() async {
    try {
      var res3 = await firestore.collection('product')
                                .where('price',isGreaterThan: 60000)
                                .get();
      for(var doc in res3.docs) {
        print(doc['name']);
        print(doc['price']);
      }
    } catch(e) {
      print('서버 오류!');
    }
  }
  
  // firebase에 저장하기
  setData() async {
    await firestore.collection('product')
        .add({'name':'정장','price':109000});
  }
  
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('Shop Page With Firebase'),
    );
  }
}
