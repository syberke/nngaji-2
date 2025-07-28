import 'package:flutter/material.dart';
import '../../utils/theme.dart';

class GuruScreen extends StatelessWidget {
  const GuruScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kelola Kelas'),
        backgroundColor: AppTheme.primaryGreen,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Quick Actions
          Row(
            children: [
              Expanded(
                child: _buildActionCard(
                  context,
                  'Setoran Masuk',
                  '0',
                  Icons.inbox,
                  AppTheme.primaryGreen,
                  () {
                    // TODO: Navigate to incoming setoran
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildActionCard(
                  context,
                  'Perlu Review',
                  '0',
                  Icons.pending,
                  AppTheme.warningOrange,
                  () {
                    // TODO: Navigate to pending reviews
                  },
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Management Options
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: Icon(Icons.rate_review, color: AppTheme.primaryGreen),
                  title: const Text('Review Setoran'),
                  subtitle: const Text('Nilai hafalan dan murojaah siswa'),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    // TODO: Navigate to review setoran
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: Icon(Icons.quiz, color: AppTheme.secondaryBlue),
                  title: const Text('Kelola Quiz'),
                  subtitle: const Text('Buat dan kelola soal quiz'),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    // TODO: Navigate to quiz management
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: Icon(Icons.people, color: AppTheme.accentGold),
                  title: const Text('Daftar Siswa'),
                  subtitle: const Text('Lihat progres dan poin siswa'),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    // TODO: Navigate to student list
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: Icon(Icons.label, color: AppTheme.successGreen),
                  title: const Text('Berikan Label'),
                  subtitle: const Text('Beri label juz selesai untuk siswa'),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    // TODO: Navigate to label management
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Reports
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: Icon(Icons.analytics, color: AppTheme.gray600),
                  title: const Text('Laporan Kelas'),
                  subtitle: const Text('Statistik dan progres kelas'),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    // TODO: Navigate to class reports
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: Icon(Icons.leaderboard, color: AppTheme.gray600),
                  title: const Text('Leaderboard'),
                  subtitle: const Text('Ranking siswa berdasarkan poin'),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    // TODO: Navigate to leaderboard
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(icon, color: color, size: 24),
                  Text(
                    value,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.gray600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}