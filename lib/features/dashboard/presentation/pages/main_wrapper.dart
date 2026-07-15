import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../auth/domain/entities/user_entity.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../pregnancy/presentation/pages/pregnancy_dashboard_page.dart';
import 'dashboard_page.dart';
import '../../../../features/cycle_tracking/presentation/pages/cycle_page.dart';

class MainWrapper extends ConsumerStatefulWidget {
  const MainWrapper({super.key});

  @override
  ConsumerState<MainWrapper> createState() => _MainWrapperState();
}

class _MainWrapperState extends ConsumerState<MainWrapper> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authStateProvider).value;
    final isPregnant = user?.role == UserRole.pregnant;

    final List<Widget> screens = [
      isPregnant ? const PregnancyDashboardPage() : const DashboardPage(),
      const CyclePage(),
      const Center(child: Text('Rendez-vous')),
      const Center(child: Text('Communauté')),
      const Center(child: Text('Profil')),
    ];

    return Scaffold(
      body: screens[_currentIndex],
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
              currentIndex: _currentIndex,
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
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home_outlined, color: Colors.grey),
                  activeIcon: Icon(Icons.home, color: AppColors.primary),
                  label: 'Accueil',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.favorite_outline, color: Colors.grey),
                  activeIcon: Icon(Icons.favorite, color: AppColors.primary),
                  label: 'Santé',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.calendar_month_outlined, color: Colors.grey),
                  activeIcon: Icon(Icons.calendar_month, color: AppColors.primary),
                  label: 'RDV',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.people_outline, color: Colors.grey),
                  activeIcon: Icon(Icons.people, color: AppColors.primary),
                  label: 'Communauté',
                ),
                BottomNavigationBarItem(
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
