import 'package:flutter/material.dart';
import '../../utils/theme.dart';

class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Panel'),
        backgroundColor: AppTheme.primaryGreen,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Quick Stats
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  context,
                  'Total Users',
                  '0',
                  Icons.people,
                  AppTheme.primaryGreen,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  context,
                  'Total Kelas',
                  '0',
                  Icons.school,
                  AppTheme.secondaryBlue,
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
                  leading: Icon(Icons.people, color: AppTheme.primaryGreen),
                  title: const Text('Manajemen User'),
                  subtitle: const Text('Kelola admin, guru, siswa, dan orang tua'),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    // TODO: Navigate to user management
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: Icon(Icons.school, color: AppTheme.secondaryBlue),
                  title: const Text('Manajemen Kelas'),
                  subtitle: const Text('Kelola kelas dan organize'),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    // TODO: Navigate to class management
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: Icon(Icons.assessment, color: AppTheme.accentGold),
                  title: const Text('Laporan & Statistik'),
                  subtitle: const Text('Lihat laporan aktivitas dan progres'),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    // TODO: Navigate to reports
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // System Settings
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: Icon(Icons.settings, color: AppTheme.gray600),
                  title: const Text('Pengaturan Sistem'),
                  subtitle: const Text('Konfigurasi aplikasi'),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    // TODO: Navigate to system settings
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: Icon(Icons.backup, color: AppTheme.gray600),
                  title: const Text('Backup Data'),
                  subtitle: const Text('Backup dan restore data'),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    // TODO: Navigate to backup
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