import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:rumah_vokasi/features/mains/models/enrollment_model.dart';

class EnrollmentService {
  final String baseUrl =
      "https://api-rumah-vokasi.dnabisa.com/rumah-vokasi-main";

  Future<EnrollmentResponse?> getEnrollmentAllData(String token) async {
    final url = Uri.parse("$baseUrl/enrollment/user");

    final response = await http.get(
      url,
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return EnrollmentResponse.fromJson(json);
    }
    return null;
  }

  Future<List<EnrollmentItem>> getEnrollment(String token) async {
    final url = Uri.parse("$baseUrl/enrollment/user");

    final response = await http.get(
      url,
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode == 200) {
      final jsonMap = jsonDecode(response.body);
      if (jsonMap['data'] is List) {
      return [];
    } else {
        final enrollmentResponse = EnrollmentResponse.fromJson(jsonMap);
        return enrollmentResponse.data.data;
      }
    } else {
      return [];
    }
  }
}
