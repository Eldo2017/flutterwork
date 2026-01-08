import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/user_model.dart';

class DbService {
  final String BaseURL = "http://172.16.251.198:8080"; // 스프링부트 API

  Future<bool> emailCheck(String email) async {
    final response = await http.get(Uri.parse("$BaseURL/flutter/email-check?email=$email"));
    
    if(response.statusCode == 200) {
      // 서버에서 Map<"isAvailable", false> 이런 식으로 보낼 것
      return jsonDecode(response.body)['isAvailable'];
    } else {
      throw Exception("이메일 확인 실패");
    }
  }

  Future<void> registerUser(User user) async {
    final response = await http.post(
      Uri.parse("$BaseURL/flutter/insert"),
      headers: {'Content-Type' : 'application/json'},
      body: jsonEncode(user.toJson())
    );

    if(response.statusCode != 200) {
      throw Exception("회원가입에 실패하였습니다");
    }

    Future<List<User>> getAllUSers() async {
      final response = await http.get(Uri.parse("$BaseURL/flutter/users"));
      if(response.statusCode == 200) {
        List<dynamic> userList = jsonDecode(response.body);
        return userList.map((u) => User.fromJson(u)).toList();
      } else {
        throw Exception("모든 사용자 정보를 가져오지 못했습니다 : ${response.statusCode}");
      }
    }
  }
}

