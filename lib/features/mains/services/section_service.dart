import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:rumah_vokasi/features/mains/models/section_model.dart';

class SectionService {
  final String baseUrl =
      "https://api-rumah-vokasi.dnabisa.com/rumah-vokasi-main";

  Future<List<SectionItem>> getSectionByCourseID(String courseID) async {
    final url = Uri.parse("$baseUrl/sections?course_id=$courseID");

    try {
      final response = await http.get(url);
      if (response.statusCode != 200) {
        throw Exception(
            "Failed to load sections. Status: ${response.statusCode}");
      }
      final jsonBody = jsonDecode(response.body);
      return SectionsResponse.fromJson(jsonBody).data;
    } catch (e) {
      return [];
    }
  }
}
