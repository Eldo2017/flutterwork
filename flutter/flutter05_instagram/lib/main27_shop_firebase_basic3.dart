import 'dart:math';

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
  var persons = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    var result = await firestore.collection('person').get();

    setState(() {
      persons = result.docs.map((doc) => doc.data()).toList();
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if(isLoading) return Center(child: CircularProgressIndicator());

    return ListView.builder(
        itemCount: persons.length,
        itemBuilder: (context, index) {
          var person = persons[index];
          return ListTile(
            title: Text('${person['name']} (${person['age']}세)'),
            subtitle: Text('도시 : ${person['city']} / 취미 : ${person['hobbies']?.join(', ') ?? ''}'),
          );
        }
    );
  }
}