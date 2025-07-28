class QuizModel {
  final String id;
  final String question;
  final List<String> options;
  final String correctOption;
  final int poin;
  final String organizeId;
  final DateTime createdAt;

  QuizModel({
    required this.id,
    required this.question,
    required this.options,
    required this.correctOption,
    required this.poin,
    required this.organizeId,
    required this.createdAt,
  });

  factory QuizModel.fromJson(Map<String, dynamic> json) {
    return QuizModel(
      id: json['id'],
      question: json['question'],
      options: List<String>.from(json['options']),
      correctOption: json['correct_option'],
      poin: json['poin'] ?? 10,
      organizeId: json['organize_id'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'question': question,
      'options': options,
      'correct_option': correctOption,
      'poin': poin,
      'organize_id': organizeId,
      'created_at': createdAt.toIso8601String(),
    };
  }
}

class QuizAnswerModel {
  final String id;
  final String quizId;
  final String siswaId;
  final String selectedOption;
  final bool isCorrect;
  final int poin;
  final DateTime answeredAt;

  QuizAnswerModel({
    required this.id,
    required this.quizId,
    required this.siswaId,
    required this.selectedOption,
    required this.isCorrect,
    required this.poin,
    required this.answeredAt,
  });

  factory QuizAnswerModel.fromJson(Map<String, dynamic> json) {
    return QuizAnswerModel(
      id: json['id'],
      quizId: json['quiz_id'],
      siswaId: json['siswa_id'],
      selectedOption: json['selected_option'],
      isCorrect: json['is_correct'] ?? false,
      poin: json['poin'] ?? 0,
      answeredAt: DateTime.parse(json['answered_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'quiz_id': quizId,
      'siswa_id': siswaId,
      'selected_option': selectedOption,
      'is_correct': isCorrect,
      'poin': poin,
      'answered_at': answeredAt.toIso8601String(),
    };
  }
}