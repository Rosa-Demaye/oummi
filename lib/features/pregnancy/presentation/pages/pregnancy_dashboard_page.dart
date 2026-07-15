import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_colors.dart';
import 'week_details_page.dart';
import '../providers/pregnancy_provider.dart';
import '../../data/repositories/pregnancy_content_repository.dart';

class PregnancyDashboardPage extends ConsumerWidget {
  const PregnancyDashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pregnancyAsync = ref.watch(pregnancyDataProvider);
    final contentRepo = PregnancyContentRepository();

    return Scaffold(
      body: pregnancyAsync.when(
        data: (data) {
          if (data == null) {
            return _buildNoPregnancyState(context, ref);
          }
          final weekDetail = contentRepo.getWeekDetail(data.currentWeek);
          return _buildDashboardContent(context, data, weekDetail);
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Erreur: $err')),
      ),
    );
  }

  Widget _buildNoPregnancyState(BuildContext context, WidgetRef ref) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.pregnant_woman, size: 80, color: AppColors.primary),
            const SizedBox(height: 24),
            Text(
              'Félicitations !',
              style: Theme.of(context).textTheme.displayMedium,
            ),
            const SizedBox(height: 8),
            const Text(
              'Commencez à suivre votre grossesse avec OUMMI.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                // For demo, just set it to today
                ref.read(pregnancyNotifierProvider.notifier).startPregnancy(
                  DateTime.now().subtract(const Duration(days: 84)), // 12 weeks ago
                );
              },
              child: const Text('Commencer le suivi'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardContent(BuildContext context, dynamic data, dynamic weekDetail) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 280,
          pinned: true,
          flexibleSpace: FlexibleSpaceBar(
            background: Container(
              decoration: const BoxDecoration(
                gradient: AppColors.pregnancyGradient,
              ),
              child: SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildHeartbeatIcon(),
                    const SizedBox(height: 16),
                    Text(
                      'Semaine ${data.currentWeek}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Bébé a ${weekDetail.babySize}',
                      style: const TextStyle(color: Colors.white70, fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildEmergencyCard(context),
                const SizedBox(height: 32),
                _buildDevelopmentCard(context, weekDetail),
                const SizedBox(height: 24),
                _buildMotherChangesCard(context, weekDetail),
                const SizedBox(height: 24),
                _buildTipCard(context, weekDetail),
                const SizedBox(height: 32),
                Center(
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => WeekDetailsPage(week: data.currentWeek),
                        ),
                      );
                    },
                    child: const Text('Voir tous les détails de la semaine'),
                  ),
                ),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeartbeatIcon() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        shape: BoxShape.circle,
      ),
      child: const Icon(Icons.favorite, color: Colors.white, size: 40),
    )
    .animate(onPlay: (controller) => controller.repeat(reverse: true))
    .scale(
      begin: const Offset(1, 1),
      end: const Offset(1.15, 1.15),
      duration: 800.ms,
      curve: Curves.easeInOut,
    );
  }

  Widget _buildEmergencyCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.error.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.error.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              color: AppColors.error,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.emergency, color: Colors.white),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Urgence / Accouchement',
                  style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.error),
                ),
                Text(
                  'Signalez une urgence immédiatement',
                  style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: AppColors.error),
        ],
      ),
    );
  }

  Widget _buildDevelopmentCard(BuildContext context, dynamic weekDetail) {
    return _buildFeatureCard(
      context,
      'Développement du bébé',
      weekDetail.babyDevelopment,
      Icons.child_care,
      AppColors.primary,
    );
  }

  Widget _buildMotherChangesCard(BuildContext context, dynamic weekDetail) {
    return _buildFeatureCard(
      context,
      'Votre corps',
      weekDetail.motherChanges,
      Icons.woman,
      AppColors.secondary,
    );
  }

  Widget _buildTipCard(BuildContext context, dynamic weekDetail) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.accent.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(32),
      ),
      child: Row(
        children: [
          const Icon(Icons.lightbulb_outline, color: AppColors.accent, size: 32),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Conseil de la semaine',
                  style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.accent),
                ),
                Text(weekDetail.tipOfTheWeek),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard(BuildContext context, String title, String content, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color),
              const SizedBox(width: 12),
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            content,
            style: const TextStyle(color: AppColors.textSecondary, height: 1.5),
          ),
        ],
      ),
    );
  }
}
