import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:rumah_vokasi/features/course/models/attempt_result_model.dart';

class QuizResultService {
  final String baseUrl = "https://api-rumah-vokasi.dnabisa.com/rumah-vokasi-main";

  Future<Map<String, QuizAttemptInfo>> getQuizAttemptMap({
    required String token,
    required String lessonId,
  }) async {
    try {
      final url = Uri.parse(
        "$baseUrl/quiz/attempt-result?lessons_id=$lessonId",
      );

      final response = await http.get(
        url,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode != 200) return {};

      final jsonBody = jsonDecode(response.body);
      final List attempts = jsonBody['data']?['attempts'] ?? [];

      final Map<String, QuizAttemptInfo> result = {};

      for (final item in attempts) {
        final attempt = QuizAttemptItem.fromJson(item);

        result[attempt.quizId] = QuizAttemptInfo(
          attemptId: attempt.attemptId,
          score: attempt.score,
        );
      }

      return result;
    } catch (e) {
      return {};
    }
  }
}
