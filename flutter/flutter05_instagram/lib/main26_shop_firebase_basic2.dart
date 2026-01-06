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
    // getData();
    // updateData();
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
        print(doc['name']);
      }
      print('-------------------------------------------------------');

      /*
      // 용인 거주자만 찾아라
      var queryByCity = await firestore.collection('person').where('city', isEqualTo: 'Yongin').get();

      for(var doc in queryByCity.docs) {
        print('${doc['name']} - ${doc['city']}');
      }
      print('-------------------------------------------------------');

      // 나이가 30세 이상인 사람만 찾아라
      var queryByAge = await firestore.collection('person')
                                      .where('age', isGreaterThanOrEqualTo: 30)
                                      .get();

      for(var doc in queryByAge.docs) {
        print('${doc['name']} - ${doc['age']}');
      }
      print('-------------------------------------------------------');

      // 나이가 15세에서 25세 사이(15세, 25세 포함)인 사람만 찾아라
      var queryByAge2 = await firestore.collection('person')
                                        .where('age', isGreaterThanOrEqualTo: 15)
                                        .where('age', isLessThanOrEqualTo: 25)
                                        .get();
      for(var doc in queryByAge2.docs) {
        print('${doc['name']} - ${doc['age']}');
      }
      print('-------------------------------------------------------');

      // 취미에 'boxing'이 포함된 사람만 찾아라
      var hobbies = await firestore.collection('person')
                                   .where('hobbies', arrayContains: 'boxing')
                                   .get();

      for(var doc in hobbies.docs) {
        print('${doc['name']} - ${doc['hobbies']}');
      }
      print('-------------------------------------------------------');

      // 취미에 'boxing','dancing' 이중에 하나라도 포함된 사람만 찾아라
      var hobbies2 = await firestore.collection('person')
                                    .where('hobbies', arrayContainsAny: ['boxing','dancing'])
                                    .get();

      for(var doc in hobbies2.docs) {
        print('${doc['name']} - ${doc['hobbies']}');
      }
      print('-------------------------------------------------------');

      // 여러 도시 조건
      var queryByCities = await firestore.collection('person')
                                         .where('city',whereIn: ['Seoul','Yongin','Daequ','Gyeongju'])
                                         .get();

      for(var doc in queryByCities.docs) {
        print('${doc['name']} - ${doc['city']}');
      }
      print('-------------------------------------------------------');

      // 여러 이름 조건
      var queryByNames = await firestore.collection('person')
                                        .where('name',whereIn: ['김창민','이재은','박승모','권유리','최영재'])
                                        .get();

      for(var doc in queryByNames.docs) {
        print('${doc['name']}');
      }
      print('-------------------------------------------------------');

      // 이름 정렬 - 오름차순 / 내림차순
      var nameSort = await firestore.collection('person')
                                    // .orderBy('name', descending: true) - 내림차순
                                    .orderBy('name') // - 오름차순 (굳이 넣을 필요도 없다)
                                    .get();

      for(var doc in nameSort.docs) {
        print('${doc['name']}');
      }
      print('-------------------------------------------------------');


      // 나이가 25세 이상인 사람만 age순으로 가져와라 (오름차순)
      var queryByAgeSort = await firestore.collection('person')
                                           .where('age', isGreaterThanOrEqualTo: 25)
                                           .orderBy('age')
                                           .get();

      for(var doc in queryByAgeSort.docs) {
        print('${doc['name']} - ${doc['age']}');
      }
      print('-------------------------------------------------------');

      // 나이가 25세 이하인 사람만 name순으로 가져와라
      var queryByNameSort2 = await firestore.collection('person')
                                           .where('age', isLessThanOrEqualTo: 25)
                                           .orderBy('name')
                                           .get();

      for(var doc in queryByNameSort2.docs) {
        print('${doc['name']} - ${doc['age']}');
      }
       */
    } catch(e) {
      print('가져오는 도중 문제 발생');
    }
  }

  /*
    set vs update
     - set은 같은 문서라면 update하고, 문서가 없다면 새로 set, 즉 생성한다
     - update는 반드시 문서가 있어야 한다. 그러나 문서가 없다면 오류가 생긴다
   */

  updateData() async {
    await firestore.collection('person')
                    .doc('person7')
                    .update({'hobbies': ['boxing','dancing','traveling']});
    var hobbyUpdate = await firestore.collection('person')
                                      .doc('person7')
                                      .get();

    print(hobbyUpdate['hobbies']);
    print('-------------------------------------------------------');

    // 이렇게 하면 name, age, city 모두 지워지고 hobbies만 남는다 (즉 덮어쓰기가 된다는 얘기)
    /*
    await firestore.collection('person')
                    .doc('person3')
                    .set({'hobbies':['boxing','gaming','soccer']});

     */

    /*
    await firestore.collection('person')
        .doc('person3')
        .set({
          'name':'최영재',
          'age':26,
          'city':'Suwon',
          'hobbies':['boxing','gaming','soccer']
        });
     */

    //

    /*
    print(hobbyUpdate['hobbies']);
    print('-------------------------------------------------------');
     */
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('Shop Page With Firebase'),
    );
  }
}
