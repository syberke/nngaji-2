import 'package:flutter/material.dart';
import '../../utils/theme.dart';

class OrtuScreen extends StatelessWidget {
  const OrtuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Monitoring Anak'),
        backgroundColor: AppTheme.primaryGreen,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Child Selection (if multiple children)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: AppTheme.primaryGreen.withOpacity(0.1),
                    child: Icon(
                      Icons.child_care,
                      color: AppTheme.primaryGreen,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Anak Anda',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Kelas: -',
                          style: TextStyle(color: AppTheme.gray600),
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.arrow_drop_down, color: AppTheme.gray400),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Progress Overview
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  context,
                  'Total Setoran',
                  '0',
                  Icons.upload,
                  AppTheme.primaryGreen,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  context,
                  'Total Poin',
                  '0',
                  Icons.stars,
                  AppTheme.accentGold,
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Monitoring Options
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: Icon(Icons.history, color: AppTheme.primaryGreen),
                  title: const Text('Riwayat Setoran'),
                  subtitle: const Text('Lihat semua setoran anak'),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    // TODO: Navigate to setoran history
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: Icon(Icons.quiz, color: AppTheme.secondaryBlue),
                  title: const Text('Hasil Quiz'),
                  subtitle: const Text('Lihat hasil quiz anak'),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    // TODO: Navigate to quiz results
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: Icon(Icons.label, color: AppTheme.successGreen),
                  title: const Text('Label & Achievement'),
                  subtitle: const Text('Lihat pencapaian anak'),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    // TODO: Navigate to achievements
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: Icon(Icons.trending_up, color: AppTheme.accentGold),
                  title: const Text('Progres Hafalan'),
                  subtitle: const Text('Grafik perkembangan hafalan'),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    // TODO: Navigate to progress chart
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Communication
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: Icon(Icons.message, color: AppTheme.gray600),
                  title: const Text('Pesan dari Guru'),
                  subtitle: const Text('Komunikasi dengan guru'),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    // TODO: Navigate to messages
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: Icon(Icons.notifications, color: AppTheme.gray600),
                  title: const Text('Notifikasi'),
                  subtitle: const Text('Pengaturan notifikasi'),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    // TODO: Navigate to notifications
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Card(
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
    );
  }
}