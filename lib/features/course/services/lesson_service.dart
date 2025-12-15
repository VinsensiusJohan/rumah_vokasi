import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:rumah_vokasi/features/course/models/lesson_model.dart';

class LessonService {
  final String baseUrl =
      "https://api-rumah-vokasi.dnabisa.com/rumah-vokasi-main";

  Future<List<LessonItem>> getLessonBySectionId(String sectionId) async {
    final url = Uri.parse("$baseUrl/lessons?section_id=$sectionId");

    try {
      final response = await http.get(url);
      if(response.statusCode != 200){
        throw Exception("Failed to load data");
      }
      final jsonbody = jsonDecode(response.body);
      return LessonResponse.fromJson(jsonbody).data;
    } catch (e) {
      return [];
    }
  }
}
