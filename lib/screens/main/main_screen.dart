import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../models/user_model.dart';
import '../../utils/theme.dart';
import '../dashboard/dashboard_screen.dart';
import '../setoran/setoran_screen.dart';
import '../quiz/quiz_screen.dart';
import '../profile/profile_screen.dart';
import '../admin/admin_screen.dart';
import '../guru/guru_screen.dart';
import '../ortu/ortu_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        final user = authProvider.user;
        if (user == null) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        final screens = _getScreensForRole(user.role);
        final bottomNavItems = _getBottomNavItemsForRole(user.role);

        return Scaffold(
          body: IndexedStack(
            index: _currentIndex,
            children: screens,
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            type: BottomNavigationBarType.fixed,
            selectedItemColor: AppTheme.primaryGreen,
            unselectedItemColor: AppTheme.gray400,
            items: bottomNavItems,
          ),
        );
      },
    );
  }

  List<Widget> _getScreensForRole(UserRole role) {
    switch (role) {
      case UserRole.admin:
        return [
          const DashboardScreen(),
          const AdminScreen(),
          const ProfileScreen(),
        ];
      case UserRole.guru:
        return [
          const DashboardScreen(),
          const GuruScreen(),
          const QuizScreen(),
          const ProfileScreen(),
        ];
      case UserRole.siswa:
        return [
          const DashboardScreen(),
          const SetoranScreen(),
          const QuizScreen(),
          const ProfileScreen(),
        ];
      case UserRole.ortu:
        return [
          const DashboardScreen(),
          const OrtuScreen(),
          const ProfileScreen(),
        ];
    }
  }

  List<BottomNavigationBarItem> _getBottomNavItemsForRole(UserRole role) {
    switch (role) {
      case UserRole.admin:
        return [
          const BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.admin_panel_settings),
            label: 'Admin',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ];
      case UserRole.guru:
        return [
          const BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'Kelas',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.quiz),
            label: 'Quiz',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ];
      case UserRole.siswa:
        return [
          const BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.upload),
            label: 'Setoran',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.quiz),
            label: 'Quiz',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ];
      case UserRole.ortu:
        return [
          const BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.child_care),
            label: 'Anak',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ];
    }
  }
}