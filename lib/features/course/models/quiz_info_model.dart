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
    required this.description,
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
