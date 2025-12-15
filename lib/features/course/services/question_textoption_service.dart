import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:rumah_vokasi/features/course/models/question_option_model.dart';

class QuizQuestionService {
  final String baseUrl =
      "https://api-rumah-vokasi.dnabisa.com/rumah-vokasi-main";

  Future<QuizDetailOption?> getQuizOption(String quizID, String token) async {
    final url = Uri.parse("$baseUrl/quizzes?quiz_id=$quizID&page=1&limit=100");

    try {
      final response = await http.get(
        url,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode != 200) {
        throw Exception("Failed to load data");
      }

      final jsonBody = jsonDecode(response.body);
      final data = jsonBody['data'];

      final quizInfo = QuizInfo.fromJson(data['quiz']);

      final question = (data['questions'] as List<dynamic>)
          .map((q) => QuestionItem.fromJson(q))
          .toList();

      return QuizDetailOption(quiz: quizInfo, questions: question);
    } catch (e) {
      return null;
    }
  }

  Future<bool> saveAnswerOption(
    String token,
    String attemptId,
    String questionId,
    String answerId,
  ) async {
    final url = Uri.parse("$baseUrl/quiz/save-progress");
    final body = jsonEncode({
      "attempt_id": attemptId,
      "question_id": questionId,
      "answer": answerId,
      "type": "OPTION",
    });

    try {
      final response = await http.post(
        url,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: body,
      );

      if (response.statusCode != 200) {
        return false;
      } else {
        return true;
      }
    } catch (e) {
      return false;
    }
  }

  Future<bool> submitQuiz(String token, String attemptId)async{
    final url = Uri.parse("$baseUrl/quiz/submit");

    try {
      final response = await http.post(
        url,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: jsonEncode({
           "attempt_id": attemptId
        })
      );

      if (response.statusCode != 200) {
        return false;
      } else {
        return true;
      }
    } catch (e) {
      return false;
    }
  }















}
