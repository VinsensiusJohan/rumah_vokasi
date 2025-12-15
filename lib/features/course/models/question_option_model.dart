class QuizQuestionResponse {
  final String result;
  final int code;
  final String message;
  final QuizQuestionData data;

  QuizQuestionResponse({
    required this.result,
    required this.code,
    required this.message,
    required this.data,
  });

  factory QuizQuestionResponse.fromJson(Map<String, dynamic> json) {
    return QuizQuestionResponse(
      result: json['result'] ?? '',
      code: json['code'] ?? 0,
      message: json['message'] ?? '',
      data: QuizQuestionData.fromJson(json['data'] ?? {}),
    );
  }
}

class QuizQuestionData {
  final QuizInfo quiz;
  final List<QuestionItem> questions;
  final Pagination pagination;

  QuizQuestionData({
    required this.quiz,
    required this.questions,
    required this.pagination,
  });

  factory QuizQuestionData.fromJson(Map<String, dynamic> json) {
    return QuizQuestionData(
      quiz: QuizInfo.fromJson(json['quiz'] ?? {}),
      questions: (json['questions'] as List<dynamic>? ?? [])
          .map((e) => QuestionItem.fromJson(e))
          .toList(),
      pagination: Pagination.fromJson(json['pagination'] ?? {}),
    );
  }
}

class QuizInfo {
  final String id;
  final String lessonId;
  final String title;
  final String? description;
  final String passingGrade;
  final String durationMinutes;
  final String answerType;

  QuizInfo({
    required this.id,
    required this.lessonId,
    required this.title,
    this.description,
    required this.passingGrade,
    required this.durationMinutes,
    required this.answerType,
  });

  factory QuizInfo.fromJson(Map<String, dynamic> json) {
    return QuizInfo(
      id: json['id'] ?? '',
      lessonId: json['lesson_id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'],
      passingGrade: json['passing_grade'] ?? '',
      durationMinutes: json['duration_minutes'] ?? '',
      answerType: json['answer_type'] ?? '',
    );
  }
}

class QuestionItem {
  final String questionId;
  final String questionText;
  final int questionOrder;
  final List<AnswerItem> answers;

  QuestionItem({
    required this.questionId,
    required this.questionText,
    required this.questionOrder,
    required this.answers,
  });

  factory QuestionItem.fromJson(Map<String, dynamic> json) {
    return QuestionItem(
      questionId: json['question_id'] ?? '',
      questionText: json['question_text'] ?? '',
      questionOrder:
          int.tryParse(json['question_order']?.toString() ?? '0') ?? 0,
      answers: (json['answers'] as List<dynamic>? ?? [])
          .map((e) => AnswerItem.fromJson(e))
          .toList(),
    );
  }
}

class AnswerItem {
  final String answerId;
  final String answerText;
  final String answerType;

  AnswerItem({
    required this.answerId,
    required this.answerText,
    required this.answerType,
  });

  factory AnswerItem.fromJson(Map<String, dynamic> json) {
    return AnswerItem(
      answerId: json['answer_id'] ?? '',
      answerText: json['answer_text'] ?? '',
      answerType: json['answer_type'] ?? '',
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

class QuizDetailOption {
  final QuizInfo quiz;
  final List<QuestionItem> questions;

  QuizDetailOption({
    required this.quiz,
    required this.questions,
  });
}
