import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../utils/theme.dart';
import '../auth/login_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: AppTheme.primaryGreen,
        foregroundColor: Colors.white,
      ),
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          final user = authProvider.user;
          if (user == null) {
            return const Center(child: CircularProgressIndicator());
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Profile Header
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: AppTheme.primaryGreen.withOpacity(0.1),
                        child: Icon(
                          Icons.person,
                          size: 50,
                          color: AppTheme.primaryGreen,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        user.name,
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        user.roleDisplayName,
                        style: TextStyle(
                          color: AppTheme.primaryGreen,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        user.email,
                        style: TextStyle(
                          color: AppTheme.gray600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Profile Info
              Card(
                child: Column(
                  children: [
                    ListTile(
                      leading: Icon(Icons.email, color: AppTheme.primaryGreen),
                      title: const Text('Email'),
                      subtitle: Text(user.email),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: Icon(Icons.badge, color: AppTheme.primaryGreen),
                      title: const Text('Role'),
                      subtitle: Text(user.roleDisplayName),
                    ),
                    if (user.type != null) ...[
                      const Divider(height: 1),
                      ListTile(
                        leading: Icon(Icons.category, color: AppTheme.primaryGreen),
                        title: const Text('Tipe'),
                        subtitle: Text(user.type!.name),
                      ),
                    ],
                    if (user.organizeId != null) ...[
                      const Divider(height: 1),
                      ListTile(
                        leading: Icon(Icons.school, color: AppTheme.primaryGreen),
                        title: const Text('Kelas'),
                        subtitle: Text(user.organizeId!),
                      ),
                    ],
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Settings
              Card(
                child: Column(
                  children: [
                    ListTile(
                      leading: Icon(Icons.settings, color: AppTheme.gray600),
                      title: const Text('Pengaturan'),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        // TODO: Navigate to settings
                      },
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: Icon(Icons.help, color: AppTheme.gray600),
                      title: const Text('Bantuan'),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        // TODO: Navigate to help
                      },
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: Icon(Icons.info, color: AppTheme.gray600),
                      title: const Text('Tentang Aplikasi'),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        _showAboutDialog(context);
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Logout Button
              Card(
                child: ListTile(
                  leading: Icon(Icons.logout, color: AppTheme.errorRed),
                  title: Text(
                    'Keluar',
                    style: TextStyle(color: AppTheme.errorRed),
                  ),
                  onTap: () => _showLogoutDialog(context),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: 'Ngaji App',
      applicationVersion: '1.0.0',
      applicationIcon: Icon(
        Icons.menu_book,
        size: 48,
        color: AppTheme.primaryGreen,
      ),
      children: [
        const Text(
          'Platform Edukasi Al-Qur\'an untuk memfasilitasi hafalan dan murojaah siswa dengan sistem penilaian dan reward berbasis poin.',
        ),
      ],
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Keluar'),
        content: const Text('Apakah Anda yakin ingin keluar dari aplikasi?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await Provider.of<AuthProvider>(context, listen: false).signOut();
              if (context.mounted) {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                  (route) => false,
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.errorRed,
            ),
            child: const Text('Keluar'),
          ),
        ],
      ),
    );
  }
}