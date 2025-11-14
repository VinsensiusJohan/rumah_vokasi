class Quiz {
  final String id;
  final String title;
  final String description;
  final int passingGrade;
  final List<Question> questions;

  Quiz({
    required this.id,
    required this.title,
    required this.description,
    required this.passingGrade,
    required this.questions,
  });

  factory Quiz.fromJson(Map<String, dynamic> json) {
    return Quiz(
      id: json['quiz']['id'],
      title: json['quiz']['title'],
      description: json['quiz']['description'],
      passingGrade: json['quiz']['passing_grade'],
      questions: (json['questions'] as List)
          .map((q) => Question.fromJson(q))
          .toList(),
    );
  }
}

class Question {
  final String id;
  final String text;
  final List<Answer> answers;

  Question({
    required this.id,
    required this.text,
    required this.answers,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['question_id'],
      text: json['question_text'],
      answers: (json['answers'] as List)
          .map((a) => Answer.fromJson(a))
          .toList(),
    );
  }
}

class Answer {
  final String id;
  final String text;
  final bool isCorrect;

  Answer({
    required this.id,
    required this.text,
    required this.isCorrect,
  });

  factory Answer.fromJson(Map<String, dynamic> json) {
    return Answer(
      id: json['answer_id'],
      text: json['answer_text'],
      isCorrect: json['is_correct'] == 1,
    );
  }
}
