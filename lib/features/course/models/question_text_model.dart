import 'package:rumah_vokasi/features/course/models/quiz_info_model.dart';

class QuizTextResponse {
  final String result;
  final int code;
  final String message;
  final QuizTextData data;

  QuizTextResponse({
    required this.result,
    required this.code,
    required this.message,
    required this.data,
  });

  factory QuizTextResponse.fromJson(Map<String, dynamic> json) {
    return QuizTextResponse(
      result: json['result'] ?? '',
      code: json['code'] ?? 0,
      message: json['message'] ?? '',
      data: QuizTextData.fromJson(json['data'] ?? {}),
    );
  }
}

class QuizTextData {
  final QuizInfo quiz;
  final List<EssayQuestion> questions;
  final Pagination pagination;

  QuizTextData({
    required this.quiz,
    required this.questions,
    required this.pagination,
  });

  factory QuizTextData.fromJson(Map<String, dynamic> json) {
    return QuizTextData(
      quiz: QuizInfo.fromJson(json['quiz'] ?? {}),
      questions: (json['questions'] as List<dynamic>? ?? [])
          .map((e) => EssayQuestion.fromJson(e))
          .toList(),
      pagination: Pagination.fromJson(json['pagination'] ?? {}),
    );
  }
}

class EssayQuestion {
  final String questionId;
  final String questionText;
  final String questionOrder;

  EssayQuestion({
    required this.questionId,
    required this.questionText,
    required this.questionOrder,
  });

  factory EssayQuestion.fromJson(Map<String, dynamic> json) {
    return EssayQuestion(
      questionId: json['question_id'] ?? '',
      questionText: json['question_text'] ?? '',
      questionOrder: json['question_order'] ?? '',
    );
  }
}

class Pagination {
  final int currentPage;
  final int perPage;
  final int totalItems;
  final int totalPages;

  Pagination({
    required this.currentPage,
    required this.perPage,
    required this.totalItems,
    required this.totalPages,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      currentPage: json['current_page'] ?? 0,
      perPage: json['per_page'] ?? 0,
      totalItems: json['total_items'] ?? 0,
      totalPages: json['total_pages'] ?? 0,
    );
  }
}

