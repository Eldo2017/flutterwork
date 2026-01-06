import 'dart:math';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/*
  where() 사용법
  - 사용 방식
                      사용 방식                 |           제시한 값 기준
    -----------------------------------------------------------------------------------
    > isEqualTo: value                         | 같은 경우
    > isGreaterThan: value                     | 큰 경우
    > isGreaterThanOrEqualTo: value            | 크거나 같은 경우
    > isLessThan: value                        | 작은 경우
    > isLessThanOrEqualTo: value               | 작거나 같은 경우
    > arrayContains: value(List 항목이어야 가능)  | 포함
    > arrayContainsAny: [...]                  | 배열 중 하나라도 포함이 되어있는 경우에 한정
    > where('field', whereIn: [...])           | 여러 값 중 하나
    > where('field', whereNotIn: [...])        | 여러 값을 제외
 */

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
    // setData();
    getData();
  }

  setData() async {
    var rand = Random();

    // 일괄 쓰기
    WriteBatch batch = firestore.batch();
    var names = [
      '오지나', '유용욱', '최영재', '이효진', '박승모',
      '김대원', '권유리', '김창민', '박채영', '고동하',
      '나호성', '이은지', '이재은', '황지만', '한소혜',
      '노상진', '김성호', '박인재', '오성환'
    ];

    var citys = [
      'Seoul','Busan','Incheon','Gwangju','Sejong',
      'Jeju', 'Yongin','Daegu','Daejeon','Gyeongju',
      'Yongin','Seongnam','Daegu','Jeju','Gwangju',
      'Suwon','Incheon','Busan','Jeju'
    ];

    var hobbies = [
      'drawing','dancing','boxing','soccer','baseball',
      'gaming','cooking','hiking','music','reading',
      'traveling'
    ];
    
    for(var i=0;i<19;i++) {
      DocumentReference id = firestore.collection('person').doc('person${i+1}');
      // 취미는 2~4개
      int hobbycount = rand.nextInt(3)+2; // 2~4개
      var shuffled = List<String>.from(hobbies)..shuffle();
      var hobbies2 = shuffled.take(hobbycount).toList();

      batch.set(id, {
        'name': names[i],
        'age': i+15,
        'city': citys[i],
        'hobbies': hobbies2
      });
    }
    await batch.commit();
  }

  getData() async {
    var persons = await firestore.collection('person').get();
    try {
      for(var doc in persons.docs) {
        print('이름: ${doc['name']} - 나이: ${doc['age']} - 거주도시: ${doc['city']} - 취미: ${doc['hobbies']}');
      }
    } catch(e) {
      print('가져오는 도중 문제 발생');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
          stream: firestore.collection('person')
                            .orderBy('age')
                            .snapshots(),
          builder: (context, snapshot) {
            if(!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            var docs = snapshot.data!.docs;

            return ListView.builder(
              itemCount: docs.length,
              itemBuilder: (context, index) {
                var data = docs[index];
                return personItem(data);
              },
            );
          },
      ),
    );
  }
}

Widget personItem(QueryDocumentSnapshot doc) {
  return Card(
    margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    elevation: 2,
    child: Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 이름 + 나이
          Text(
            '${doc['name']} (${doc['age']})',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 4),

          // 도시
          Text(
            '도시: ${doc['city']}',
            style: const TextStyle(color: Colors.grey),
          ),

          const SizedBox(height: 8),

          // 취미
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: List<Widget>.from(
              doc['hobbies'].map(
                  (hobby) => Chip(
                    label: Text(hobby),
                  ),
              ),
            ),
          )
        ],
      ),
    ),
  );
}