import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// 1. import
import 'package:firebase_auth/firebase_auth.dart';

final firestore = FirebaseFirestore.instance;

// 2. auth 객체 얻어오기
final auth = FirebaseAuth.instance;

class Shop extends StatefulWidget {
  const Shop({super.key});

  @override
  State<Shop> createState() => _ShopState();
}

class _ShopState extends State<Shop> {
  @override
  void initState() {
    super.initState();
    // authCreate();
    login();
  }

  authCreate() async {
    /*
    // 사용자 등록
    try {
      var result = await auth.createUserWithEmailAndPassword(
        email: 'kim@naver.com',
        password: '123456'
      );
      print(result.user);
    } catch(e) {
      print(e);  // 이메일/비밀번호로 setting해 놓음. 이메일형식이 아니거나 비밀번호가 6자리미만이면 오류
    }
    */
/*
    // 사용자 이름까지 등록
    try {
      var result = await auth.createUserWithEmailAndPassword(
        email: 'hong12@gmail.com',
        password: '123456'
      );
      result.user?.updateDisplayName('홍미남');
      // 출력시
      // await result.user?.updateDisplayName('홍미남');
      //
      // await result.user?.reload();
      // var user = auth.currentUser;
      // if(user != null) {
      //   print('${user.displayName}');
      // }
    }catch(e) {
      print(e);
    }
    */

    // 기타 다른것들도 넣으려면
    try {
      var result = await auth.createUserWithEmailAndPassword(
          email: 'hong@gmail.com',
          password: '123456'
      );
      User? user = result.user;
      await user?.updateDisplayName('홍사부');

      await firestore.collection('users').doc(user?.uid).set({
        'name':'홍사부',
        'address' : '서울시 강남구',
        'phone' : '010-1234-5678',
        'email' : user?.email,
        'createAt' : Timestamp.now()
      });
      print('회원가입 및 정보 저장 완료');
    } catch(e) {
      print(e);
    }
  }

  login() async {
    try {
      await auth.signInWithEmailAndPassword(
          email: 'hong@gmail.com',
          password: '123456'
      );
    } catch(e) {
      print(e);
    }

    if(auth.currentUser?.uid == null) {
      print('로그인이 되지 않았습니다');
    } else {
      print('로그인 됨');
      userInfo();
    }
  }

  userInfo() async {
    try {
      var user = auth.currentUser;
      // uid, email, displayName 들어있음
      if(user == null) {
        print('로그인 안됨');
        return;
      }

      var uid = user.uid;
      var doc = await firestore.collection('users').doc(uid).get();
      if(doc.exists) {
        var data = doc.data() as Map<String, dynamic>;
        print('이름 : ${data['name']}');
        // print('이름 : ${user.displayName}');
        print('전화번호 : ${data['phone']}');
        print('주소 : ${data['address']}');
        print('가입날자 : ${data['createAt']}');
      } else {
        print('사용자 정보가 없습니다');
      }
    } catch(e) {
      print(e);
    }

    logout();
  }

  logout() async {
    await auth.signOut();
    print('로그아웃 됨 : ${auth.currentUser?.uid}');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('Shop Page firebase'),
    );
  }
}