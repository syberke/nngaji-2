import 'package:flutter/material.dart';
import '../models/quiz_model.dart';
import '../services/quiz_service.dart';

class QuizProvider with ChangeNotifier {
  final QuizService _quizService = QuizService();
  
  List<QuizModel> _quizzes = [];
  List<QuizAnswerModel> _userAnswers = [];
  bool _isLoading = false;
  String? _error;

  List<QuizModel> get quizzes => _quizzes;
  List<QuizAnswerModel> get userAnswers => _userAnswers;
  bool get isLoading => _isLoading;
  String? get error => _error;

  int get totalPoints => _userAnswers.fold(0, (sum, answer) => sum + answer.poin);
  int get correctAnswers => _userAnswers.where((answer) => answer.isCorrect).length;

  Future<void> fetchQuizzes(String organizeId) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _quizzes = await _quizService.getQuizzesByOrganize(organizeId);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchUserAnswers(String siswaId) async {
    try {
      _userAnswers = await _quizService.getUserAnswers(siswaId);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<bool> submitAnswer({
    required String quizId,
    required String siswaId,
    required String selectedOption,
    required String correctOption,
    required int points,
  }) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final isCorrect = selectedOption == correctOption;
      final earnedPoints = isCorrect ? points : 0;

      final success = await _quizService.submitAnswer(
        quizId: quizId,
        siswaId: siswaId,
        selectedOption: selectedOption,
        isCorrect: isCorrect,
        poin: earnedPoints,
      );

      if (success) {
        // Refresh user answers
        await fetchUserAnswers(siswaId);
      }

      return success;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  bool hasAnswered(String quizId) {
    return _userAnswers.any((answer) => answer.quizId == quizId);
  }

  QuizAnswerModel? getAnswer(String quizId) {
    try {
      return _userAnswers.firstWhere((answer) => answer.quizId == quizId);
    } catch (e) {
      return null;
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}