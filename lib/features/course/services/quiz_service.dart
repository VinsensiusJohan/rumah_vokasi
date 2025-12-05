import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:rumah_vokasi/features/course/models/quiz_model.dart';
import 'package:http/http.dart' as http;

class QuizService {
  final String baseUrl =
      "https://api-rumah-vokasi.dnabisa.com/rumah-vokasi-main";

  Future<QuizData?> getQuizByLessonId(String lessonId, String token) async {
  final url = Uri.parse("$baseUrl/quizzes?lesson_id=$lessonId");

  try {
    final response = await http.get(url, headers: {
      "Authorization": "Bearer $token",
      "Content-Type": "application/json",
    });

    if (response.statusCode != 200) {
      throw Exception("Failed to load quiz. Status: ${response.statusCode}");
    }

    final jsonBody = jsonDecode(response.body);
    final quizResponse = QuizResponse.fromJson(jsonBody);

    if (quizResponse.data.isEmpty) return null;

    return quizResponse.data.first;
  } catch (e) {
    debugPrint("Error get quiz: $e");
    return null;
  }
}

}
