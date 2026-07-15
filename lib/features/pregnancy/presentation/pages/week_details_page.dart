import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/repositories/pregnancy_content_repository.dart';

class WeekDetailsPage extends StatelessWidget {
  final int week;
  const WeekDetailsPage({super.key, required this.week});

  @override
  Widget build(BuildContext context) {
    final weekDetail = PregnancyContentRepository().getWeekDetail(week);

    return Scaffold(
      appBar: AppBar(
        title: Text('Semaine $week'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.child_care, size: 80, color: AppColors.primary),
              ),
            ),
            const SizedBox(height: 32),
            _buildInfoSection(context, 'Taille du bébé', weekDetail.babySize, Icons.straighten),
            const SizedBox(height: 24),
            _buildInfoSection(context, 'Développement', weekDetail.babyDevelopment, Icons.auto_awesome),
            const SizedBox(height: 24),
            _buildInfoSection(context, 'Votre corps', weekDetail.motherChanges, Icons.favorite_border),
            const SizedBox(height: 24),
            _buildInfoSection(context, 'Conseil', weekDetail.tipOfTheWeek, Icons.lightbulb_outline),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoSection(BuildContext context, String title, String content, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: AppColors.primary, size: 20),
            const SizedBox(width: 8),
            Text(title, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 18)),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Text(content, style: const TextStyle(height: 1.6)),
        ),
      ],
    );
  }
}
