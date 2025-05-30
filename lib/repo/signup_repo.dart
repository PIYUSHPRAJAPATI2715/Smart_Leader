import 'dart:convert';
import 'package:http/http.dart' as http;

import '../Modal/signup.dart';


class SignupRepository {
  final String _baseUrl = "https://ruparnatechnology.com/Smartleader/Api/process.php?action=user_signup";

  Future<SignupResponse> signup({
    required String name,
    required String username,
    required String email,
    required String phone,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'name': name,
        'username': username,
        'email': email,
        'phone': phone,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return SignupResponse.fromJson(json);
    } else {
      throw Exception('Failed to signup');
    }
  }
}
