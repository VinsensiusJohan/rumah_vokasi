class QuizResponse {
  final String result;
  final int code;
  final String message;
  final List<QuizData> data;

  QuizResponse({
    required this.result,
    required this.code,
    required this.message,
    required this.data,
  });

  factory QuizResponse.fromJson(Map<String, dynamic> json) {
    return QuizResponse(
      result: json['result'] ?? '',
      code: json['code'] ?? 0,
      message: json['message'] ?? '',
      data: (json['data'] as List<dynamic>? ?? [])
          .map((item) => QuizData.fromJson(item))
          .toList(),
    );
  }
}

class QuizData {
  final String id;
  final String lessonId;
  final String title;
  final String? description;
  final String passingGrade;
  final String durationMinutes;
  final String answerType;
  final String createdAt;
  final String updatedAt;
  final String? deletedAt;

  QuizData({
    required this.id,
    required this.lessonId,
    required this.title,
    required this.description,
    required this.passingGrade,
    required this.durationMinutes,
    required this.answerType,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
  });

  factory QuizData.fromJson(Map<String, dynamic> json) {
    return QuizData(
      id: json['id'] ?? '',
      lessonId: json['lesson_id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'],
      passingGrade: json['passing_grade'] ?? '',
      durationMinutes: json['duration_minutes'] ?? '',
      answerType: json['answer_type'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      deletedAt: json['deleted_at'],
    );
  }
}
