import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginRegisterServices {
  final String baseUrl =
      "https://api-rumah-vokasi.dnabisa.com/rumah-vokasi-main";

  // Register
  Future<Map<String, dynamic>> registerUser({
    required String name,
    required String email,
    required String password,
  }) async {
    final url = Uri.parse("$baseUrl/register");

    final body = jsonEncode({
      "user_type": "STUDENT",
      "name": name,
      "email": email,
      "password": password,
      "phone": "",
      "address": "",
      "bio": "",
      "status": "Confirmed",
    });

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: body,
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Gagal : ${response.body}");
    }
  }

  //Login
  Future<bool> loginUser({
    required String email,
    required String password,
  }) async {
    final url = Uri.parse("$baseUrl/login");

    final body = jsonEncode({
      "email": email,
      "password": password,
      "deviceType": "MOBILE",
    });

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: body,
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final jsonData = jsonDecode(response.body);
      await saveToPref(jsonData["data"]);
      return true;
    } else {
      throw Exception("Gagal : ${response.body}");
    }
  }

  //Save to Shared Preference
  Future<void> saveToPref(Map<String, dynamic> data) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString("access_token", data["access_token"]);
    await prefs.setString("exp_access_token", data["exp_access_token"]);
    await prefs.setString("user_id", data["user_id"]);
    await prefs.setString("role", data["role"]);
    await prefs.setString("name", data["name"]);
    await prefs.setString("email", data["email"]);
  }
}
