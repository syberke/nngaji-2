import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/setoran_provider.dart';
import '../../providers/quiz_provider.dart';
import '../../models/user_model.dart';
import '../../utils/theme.dart';
import '../../widgets/stats_card.dart';
import '../../widgets/recent_activity_card.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final user = authProvider.user;
    
    if (user != null) {
      if (user.role == UserRole.siswa) {
        Provider.of<SetoranProvider>(context, listen: false)
            .fetchSetoranBySiswa(user.id);
        if (user.organizeId != null) {
          Provider.of<QuizProvider>(context, listen: false)
              .fetchQuizzes(user.organizeId!);
          Provider.of<QuizProvider>(context, listen: false)
              .fetchUserAnswers(user.id);
        }
      } else if (user.role == UserRole.guru) {
        Provider.of<SetoranProvider>(context, listen: false)
            .fetchSetoranByGuru(user.id);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        final user = authProvider.user;
        if (user == null) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: Text('Dashboard ${user.roleDisplayName}'),
            backgroundColor: AppTheme.primaryGreen,
            foregroundColor: Colors.white,
          ),
          body: RefreshIndicator(
            onRefresh: () async {
              _loadData();
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Welcome Card
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundColor: AppTheme.primaryGreen.withOpacity(0.1),
                            child: Icon(
                              _getRoleIcon(user.role),
                              size: 30,
                              color: AppTheme.primaryGreen,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Assalamu\'alaikum',
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: AppTheme.gray600,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  user.name,
                                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  user.roleDisplayName,
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: AppTheme.primaryGreen,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Stats Section
                  Text(
                    'Statistik',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  _buildStatsSection(user),
                  
                  const SizedBox(height: 24),
                  
                  // Recent Activity
                  Text(
                    'Aktivitas Terbaru',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  _buildRecentActivity(user),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  IconData _getRoleIcon(UserRole role) {
    switch (role) {
      case UserRole.admin:
        return Icons.admin_panel_settings;
      case UserRole.guru:
        return Icons.school;
      case UserRole.siswa:
        return Icons.person;
      case UserRole.ortu:
        return Icons.family_restroom;
    }
  }

  Widget _buildStatsSection(UserModel user) {
    return Consumer2<SetoranProvider, QuizProvider>(
      builder: (context, setoranProvider, quizProvider, child) {
        if (user.role == UserRole.siswa) {
          return Row(
            children: [
              Expanded(
                child: StatsCard(
                  title: 'Total Setoran',
                  value: setoranProvider.setoranList.length.toString(),
                  icon: Icons.upload,
                  color: AppTheme.primaryGreen,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: StatsCard(
                  title: 'Quiz Selesai',
                  value: quizProvider.userAnswers.length.toString(),
                  icon: Icons.quiz,
                  color: AppTheme.secondaryBlue,
                ),
              ),
            ],
          );
        } else if (user.role == UserRole.guru) {
          return Row(
            children: [
              Expanded(
                child: StatsCard(
                  title: 'Setoran Masuk',
                  value: setoranProvider.setoranList.length.toString(),
                  icon: Icons.inbox,
                  color: AppTheme.primaryGreen,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: StatsCard(
                  title: 'Perlu Review',
                  value: setoranProvider.setoranList
                      .where((s) => s.status.name == 'pending')
                      .length
                      .toString(),
                  icon: Icons.pending,
                  color: AppTheme.warningOrange,
                ),
              ),
            ],
          );
        }
        
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildRecentActivity(UserModel user) {
    return Consumer<SetoranProvider>(
      builder: (context, setoranProvider, child) {
        if (setoranProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (setoranProvider.setoranList.isEmpty) {
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Icon(
                    Icons.inbox_outlined,
                    size: 48,
                    color: AppTheme.gray400,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Belum ada aktivitas',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppTheme.gray600,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return Column(
          children: setoranProvider.setoranList
              .take(5)
              .map((setoran) => RecentActivityCard(setoran: setoran))
              .toList(),
        );
      },
    );
  }
}