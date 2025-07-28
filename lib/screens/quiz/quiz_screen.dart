import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/quiz_provider.dart';
import '../../models/quiz_model.dart';
import '../../utils/theme.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  @override
  void initState() {
    super.initState();
    _loadQuizzes();
  }

  void _loadQuizzes() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final user = authProvider.user;
    
    if (user?.organizeId != null) {
      Provider.of<QuizProvider>(context, listen: false)
          .fetchQuizzes(user!.organizeId!);
      Provider.of<QuizProvider>(context, listen: false)
          .fetchUserAnswers(user.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz Al-Qur\'an'),
        backgroundColor: AppTheme.primaryGreen,
        foregroundColor: Colors.white,
      ),
      body: Consumer<QuizProvider>(
        builder: (context, quizProvider, child) {
          if (quizProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (quizProvider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: AppTheme.errorRed,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Terjadi kesalahan',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    quizProvider.error!,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: AppTheme.gray600),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _loadQuizzes,
                    child: const Text('Coba Lagi'),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              _loadQuizzes();
            },
            child: Column(
              children: [
                // Stats Header
                Container(
                  padding: const EdgeInsets.all(16),
                  color: AppTheme.primaryGreen.withOpacity(0.1),
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(
                          'Total Quiz',
                          quizProvider.quizzes.length.toString(),
                          Icons.quiz,
                          AppTheme.primaryGreen,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildStatCard(
                          'Selesai',
                          quizProvider.userAnswers.length.toString(),
                          Icons.check_circle,
                          AppTheme.successGreen,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildStatCard(
                          'Total Poin',
                          quizProvider.totalPoints.toString(),
                          Icons.stars,
                          AppTheme.accentGold,
                        ),
                      ),
                    ],
                  ),
                ),

                // Quiz List
                Expanded(
                  child: quizProvider.quizzes.isEmpty
                      ? _buildEmptyState()
                      : ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: quizProvider.quizzes.length,
                          itemBuilder: (context, index) {
                            final quiz = quizProvider.quizzes[index];
                            final hasAnswered = quizProvider.hasAnswered(quiz.id);
                            final answer = quizProvider.getAnswer(quiz.id);
                            
                            return Card(
                              margin: const EdgeInsets.only(bottom: 12),
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: hasAnswered
                                      ? (answer?.isCorrect == true
                                          ? AppTheme.successGreen
                                          : AppTheme.errorRed)
                                      : AppTheme.primaryGreen,
                                  child: Icon(
                                    hasAnswered
                                        ? (answer?.isCorrect == true
                                            ? Icons.check
                                            : Icons.close)
                                        : Icons.quiz,
                                    color: Colors.white,
                                  ),
                                ),
                                title: Text(
                                  quiz.question,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                subtitle: hasAnswered
                                    ? Text(
                                        answer?.isCorrect == true
                                            ? 'Benar (+${answer?.poin} poin)'
                                            : 'Salah (0 poin)',
                                        style: TextStyle(
                                          color: answer?.isCorrect == true
                                              ? AppTheme.successGreen
                                              : AppTheme.errorRed,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      )
                                    : Text('${quiz.poin} poin'),
                                trailing: hasAnswered
                                    ? const Icon(Icons.done)
                                    : const Icon(Icons.arrow_forward_ios),
                                onTap: hasAnswered
                                    ? null
                                    : () => _showQuizDialog(quiz),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: AppTheme.gray600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.quiz_outlined,
              size: 80,
              color: AppTheme.gray400,
            ),
            const SizedBox(height: 24),
            Text(
              'Belum Ada Quiz',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Quiz akan tersedia setelah guru membuat soal untuk kelas Anda.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppTheme.gray600,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showQuizDialog(QuizModel quiz) {
    String? selectedOption;
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(
            'Quiz',
            style: TextStyle(color: AppTheme.primaryGreen),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                quiz.question,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),
              ...quiz.options.map((option) => RadioListTile<String>(
                title: Text(option),
                value: option,
                groupValue: selectedOption,
                onChanged: (value) {
                  setState(() {
                    selectedOption = value;
                  });
                },
              )),
              const SizedBox(height: 8),
              Text(
                'Poin: ${quiz.poin}',
                style: TextStyle(
                  color: AppTheme.accentGold,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: selectedOption == null
                  ? null
                  : () => _submitAnswer(quiz, selectedOption!),
              child: const Text('Jawab'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submitAnswer(QuizModel quiz, String selectedOption) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final user = authProvider.user!;
    
    final success = await Provider.of<QuizProvider>(context, listen: false)
        .submitAnswer(
      quizId: quiz.id,
      siswaId: user.id,
      selectedOption: selectedOption,
      correctOption: quiz.correctOption,
      points: quiz.poin,
    );

    if (mounted) {
      Navigator.of(context).pop();
      
      if (success) {
        final isCorrect = selectedOption == quiz.correctOption;
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(
              isCorrect ? 'Benar!' : 'Salah!',
              style: TextStyle(
                color: isCorrect ? AppTheme.successGreen : AppTheme.errorRed,
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isCorrect ? Icons.check_circle : Icons.cancel,
                  size: 64,
                  color: isCorrect ? AppTheme.successGreen : AppTheme.errorRed,
                ),
                const SizedBox(height: 16),
                Text(
                  isCorrect
                      ? 'Selamat! Anda mendapat ${quiz.poin} poin'
                      : 'Jawaban yang benar: ${quiz.correctOption}',
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            actions: [
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Gagal mengirim jawaban'),
            backgroundColor: AppTheme.errorRed,
          ),
        );
      }
    }
  }
}