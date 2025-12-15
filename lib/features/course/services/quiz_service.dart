import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:rumah_vokasi/features/course/models/quiz_model.dart';
import 'package:http/http.dart' as http;

class QuizService {
  final String baseUrl =
      "https://api-rumah-vokasi.dnabisa.com/rumah-vokasi-main";

  Future<List<QuizData>> getQuizByLessonId(
    String lessonId,
    String token,
  ) async {
    final url = Uri.parse("$baseUrl/quizzes?lesson_id=$lessonId");

    try {
      final response = await http.get(
        url,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode != 200) {
        throw Exception("Failed to load quiz");
      }

      final jsonBody = jsonDecode(response.body);
      return QuizResponse.fromJson(jsonBody).data;
    } catch (e) {
      return [];
    }
  }

  Future<String> getQuizAttempt(String token, String quizId) async {
    final url = Uri.parse("$baseUrl/quiz/start");
    try {
      final body = jsonEncode({"quiz_id": quizId});

      final response = await http.post(
        url,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: body,
      );

      if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);

      final attemptId = decoded['data']?['attempt_id'];

      if (attemptId is String && attemptId.isNotEmpty) {
        return attemptId;
      }
      throw Exception('Attempt ID not found in response');
    } else {
      throw Exception(
        'Failed to start quiz',
      );
    }
    }catch(e){
      debugPrint("$e");
      return "";
    }
  }
}
