class QuizAttemptResult {
  final String result;
  final int code;
  final String message;
  final QuizAttemptHistoryData data;

  QuizAttemptResult({
    required this.result,
    required this.code,
    required this.message,
    required this.data,
  });

  factory QuizAttemptResult.fromJson(Map<String, dynamic> json) {
    return QuizAttemptResult(
      result: json['result'] ?? '',
      code: json['code'] ?? 0,
      message: json['message'] ?? '',
      data: QuizAttemptHistoryData.fromJson(json['data']),
    );
  }
}

// ======================================================================

class QuizAttemptHistoryData {
  final String quizId;
  final String lessonsId;
  final String userId;
  final int attemptCount;
  final List<QuizAttemptItem> attempts;

  QuizAttemptHistoryData({
    required this.quizId,
    required this.lessonsId,
    required this.userId,
    required this.attemptCount,
    required this.attempts,
  });

  factory QuizAttemptHistoryData.fromJson(Map<String, dynamic> json) {
    return QuizAttemptHistoryData(
      quizId: json['quiz_id'] ?? '',
      lessonsId: json['lessons_id'] ?? '',
      userId: json['user_id'] ?? '',
      attemptCount: json['attempt_count'] ?? 0,
      attempts: (json['attempts'] as List<dynamic>)
          .map((e) => QuizAttemptItem.fromJson(e))
          .toList(),
    );
  }
}

// ======================================================================

class QuizAttemptItem {
  final String lessonsId;
  final String attemptId;
  final String quizId;
  final String quizTitle;
  final String studentId;
  final String studentName;
  final String? score;
  final String status;
  final String startedAt;
  final String? finishedAt;

  QuizAttemptItem({
    required this.lessonsId,
    required this.attemptId,
    required this.quizId,
    required this.quizTitle,
    required this.studentId,
    required this.studentName,
    required this.score,
    required this.status,
    required this.startedAt,
    required this.finishedAt,
  });

  factory QuizAttemptItem.fromJson(Map<String, dynamic> json) {
    return QuizAttemptItem(
      lessonsId: json['lessons_id'] ?? '',
      attemptId: json['attempt_id'] ?? '',
      quizId: json['quiz_id'] ?? '',
      quizTitle: json['quiz_title'] ?? '',
      studentId: json['student_id'] ?? '',
      studentName: json['student_name'] ?? '',
      score: json['score'], 
      status: json['status'] ?? '',
      startedAt: json['started_at'] ?? '',
      finishedAt: json['finished_at'], 
    );
  }
}

class QuizAttemptInfo {
  final String? attemptId;
  final String? score;

  QuizAttemptInfo({
    required this.attemptId,
    required this.score,
  });

  bool get hasAttempt => attemptId != null;
}
