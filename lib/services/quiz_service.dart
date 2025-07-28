import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/quiz_model.dart';
import '../utils/constants.dart';

class QuizService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<List<QuizModel>> getQuizzesByOrganize(String organizeId) async {
    try {
      final response = await _supabase
          .from('quizzes')
          .select()
          .eq('organize_id', organizeId)
          .order('created_at', ascending: false);

      return response.map<QuizModel>((json) => QuizModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to fetch quizzes: ${e.toString()}');
    }
  }

  Future<List<QuizAnswerModel>> getUserAnswers(String siswaId) async {
    try {
      final response = await _supabase
          .from('quiz_answers')
          .select()
          .eq('siswa_id', siswaId)
          .order('answered_at', ascending: false);

      return response.map<QuizAnswerModel>((json) => QuizAnswerModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to fetch user answers: ${e.toString()}');
    }
  }

  Future<bool> submitAnswer({
    required String quizId,
    required String siswaId,
    required String selectedOption,
    required bool isCorrect,
    required int poin,
  }) async {
    try {
      // Insert answer
      await _supabase.from('quiz_answers').insert({
        'quiz_id': quizId,
        'siswa_id': siswaId,
        'selected_option': selectedOption,
        'is_correct': isCorrect,
        'poin': poin,
      });

      // Update student points if correct
      if (isCorrect && poin > 0) {
        await _updateStudentPoints(siswaId, poin);
      }

      return true;
    } catch (e) {
      throw Exception('Failed to submit answer: ${e.toString()}');
    }
  }

  Future<void> _updateStudentPoints(String siswaId, int points) async {
    try {
      // Check if student points record exists
      final existingPoints = await _supabase
          .from('siswa_poin')
          .select()
          .eq('siswa_id', siswaId)
          .maybeSingle();

      if (existingPoints != null) {
        // Update existing points
        await _supabase
            .from('siswa_poin')
            .update({
              'total_poin': existingPoints['total_poin'] + points,
              'updated_at': DateTime.now().toIso8601String(),
            })
            .eq('siswa_id', siswaId);
      } else {
        // Create new points record
        await _supabase.from('siswa_poin').insert({
          'siswa_id': siswaId,
          'total_poin': points,
        });
      }
    } catch (e) {
      print('Failed to update student points: $e');
    }
  }
}