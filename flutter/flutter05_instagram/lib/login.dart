
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _auth = FirebaseAuth.instance;

  String errorMsg = '';

  login() async {
    try {
      await _auth.signInWithEmailAndPassword(
          email: _email.text,
          password: _password.text
      );
      Navigator.pop(context);
    } catch(e) {
      setState(() {
        errorMsg = '로그인 실패';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          TextField(
            controller: _email,
            decoration: InputDecoration(labelText: 'Email'),
          ),
          TextField(
            controller: _password,
            decoration: InputDecoration(labelText: 'Password'),
            obscureText: true,
          ),
          ElevatedButton(
              onPressed: login,
              child: Text('Login')
          ),
          if(errorMsg.isNotEmpty)
            Padding(
              padding: EdgeInsets.only(top: 10.0),
              child: Text(errorMsg, style: TextStyle(color: Colors.red)),
            )
        ],
      ),
    );
  }
}
