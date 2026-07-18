import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../auth/domain/entities/user_entity.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../pregnancy/presentation/pages/pregnancy_dashboard_page.dart';
import 'dashboard_page.dart';
import '../../../cycle_tracking/presentation/pages/cycle_page.dart';
import '../../../dashboards/presentation/pages/doctor_dashboard.dart';
import '../../../dashboards/presentation/pages/father_dashboard.dart';
import '../../../dashboards/presentation/pages/young_woman_dashboard.dart';

class MainWrapper extends ConsumerStatefulWidget {
  const MainWrapper({super.key});

  @override
  ConsumerState<MainWrapper> createState() => _MainWrapperState();
}

class _MainWrapperState extends ConsumerState<MainWrapper> {
  int _currentIndex = 0;

  Widget _buildHomeScreen(UserRole? role) {
    switch (role) {
      case UserRole.pregnant:
        return const PregnancyDashboardPage();
      case UserRole.doctor:
        return const DoctorDashboard();
      case UserRole.father:
        return const FatherDashboard();
      case UserRole.girl:
        return const YoungWomanDashboard();
      case UserRole.hospital:
        return const DashboardPage();
      case UserRole.admin:
        return const DashboardPage();
      case null:
        return const DashboardPage();
    }
  }

  bool _showCycleTab(UserRole? role) {
    return role == UserRole.pregnant || role == UserRole.girl;
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authStateProvider).value;
    final role = user?.role;

    final List<Widget> screens = [
      _buildHomeScreen(role),
      if (_showCycleTab(role)) const CyclePage() else const Center(child: Text('Rendez-vous')),
      const Center(child: Text('Communauté')),
      const Center(child: Text('Profil')),
    ];

    final activeIndex = _currentIndex.clamp(0, screens.length - 1);

    return Scaffold(
      body: screens[activeIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: BottomNavigationBar(
              currentIndex: activeIndex,
              onTap: (index) => setState(() => _currentIndex = index),
              type: BottomNavigationBarType.fixed,
              backgroundColor: Colors.transparent,
              elevation: 0,
              selectedItemColor: AppColors.primary,
              unselectedItemColor: AppColors.textSecondary.withValues(alpha: 0.5),
              selectedLabelStyle: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
              unselectedLabelStyle: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 12,
              ),
              items: [
                const BottomNavigationBarItem(
                  icon: Icon(Icons.home_outlined, color: Colors.grey),
                  activeIcon: Icon(Icons.home, color: AppColors.primary),
                  label: 'Accueil',
                ),
                if (_showCycleTab(role))
                  const BottomNavigationBarItem(
                    icon: Icon(Icons.favorite_outline, color: Colors.grey),
                    activeIcon: Icon(Icons.favorite, color: AppColors.primary),
                    label: 'Santé',
                  )
                else
                  const BottomNavigationBarItem(
                    icon: Icon(Icons.calendar_month_outlined, color: Colors.grey),
                    activeIcon: Icon(Icons.calendar_month, color: AppColors.primary),
                    label: 'RDV',
                  ),
                const BottomNavigationBarItem(
                  icon: Icon(Icons.people_outline, color: Colors.grey),
                  activeIcon: Icon(Icons.people, color: AppColors.primary),
                  label: 'Communauté',
                ),
                const BottomNavigationBarItem(
                  icon: Icon(Icons.person_outline, color: Colors.grey),
                  activeIcon: Icon(Icons.person, color: AppColors.primary),
                  label: 'Profil',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
