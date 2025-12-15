import 'dart:convert';
import 'package:http/http.dart' as http;

class ChangePasswordService {
  final String baseUrl =
      "https://api-rumah-vokasi.dnabisa.com/rumah-vokasi-main";

  Future<bool> changeUserPassword({
    required String userID,
    required String oldPassword,
    required String newPassword,
    required String token,
  }) async {
    final url = Uri.parse("$baseUrl/change-password");
    final body = jsonEncode({
      "userId": userID,
      "oldPassword": oldPassword,
      "newPassword": newPassword,
    });

    final response = await http.post(
      url,
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
      body: body,
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}
