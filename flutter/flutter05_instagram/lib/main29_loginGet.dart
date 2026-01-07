
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login.dart';

final firestore = FirebaseFirestore.instance;
final auth = FirebaseAuth.instance;

class Shop extends StatefulWidget {
  const Shop({super.key});

  @override
  State<Shop> createState() => _ShopState();
}

class _ShopState extends State<Shop> {
  final _auth = FirebaseAuth.instance;
  List<Map<String, dynamic>> productList = [];
  User? user;

  @override
  void initState() {
    super.initState();
    checkLogin();
  }

  checkLogin() async {
    user = _auth.currentUser;
    if(user == null) {
      Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LoginPage())
      );
    } else {
      await getData();
    }
  }

  getData() async {
    var products = await firestore.collection('product').get();

    List<Map<String, dynamic>> list= products.docs.map((doc) {
      return {
        'name': doc['name'],
        'price' : doc['price']
      };
      /*
      return {
        'name':doc['name'],
        ...
        'hobbies' : List<String>.from(doc['hobbies'])
      };
      */
    }).toList();

    setState(() {
      productList = list;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: productList.length,
              itemBuilder: (context, index) {
                final product = productList[index];
                return ListTile(
                  title : Text('${product['name']}'),
                  subtitle: Text('${product['price']}'),
                );
              },
            ),
          ),
          ElevatedButton(
              onPressed: () async {
                await auth.signOut();
              },
              child: Text('Logout')
          )
        ],
      ),
    );
  }
}
