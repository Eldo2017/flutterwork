import 'dart:convert';

import 'package:http/http.dart' as http;

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
}

