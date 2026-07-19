import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../labor_declaration/domain/entities/emergency_alert.dart';
import '../../../labor_declaration/presentation/providers/emergency_provider.dart';

class HospitalDashboardPage extends ConsumerWidget {
  const HospitalDashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // For demo, using a fixed hospital ID
    const hospitalId = 'h1';
    final emergenciesAsync = ref.watch(activeEmergenciesProvider(hospitalId));

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          _buildAppBar(context),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildNationalStatsHeader(context),
                  const SizedBox(height: 24),
                  _buildStatsGrid(),
                  const SizedBox(height: 32),
                  _buildEmergencyCenter(context, emergenciesAsync),
                  const SizedBox(height: 32),
                  _buildResourceManagement(context),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 200,
      pinned: true,
      backgroundColor: AppColors.textMain,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppColors.textMain, Color(0xFF374151)],
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Centre de Commande',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                              letterSpacing: 1,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            'Hôpital de la Renaissance',
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      ClipOval(
                        child: Image.asset(
                          'assets/images/logo.png',
                          width: 45,
                          height: 45,
                          errorBuilder: (context, error, stackTrace) => const Icon(Icons.local_hospital, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  _buildLiveBadge(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLiveBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.success.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.success.withValues(alpha: 0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: AppColors.success,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          const Text(
            'SYSTÈME EN DIRECT',
            style: TextStyle(
              color: AppColors.success,
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNationalStatsHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Statistiques Nationales',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        Text(
          'Tchad 🇹🇩',
          style: TextStyle(color: Colors.grey.shade600, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  Widget _buildStatsGrid() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.3,
      children: [
        _buildStatCard('Grossesses', '1,420', Icons.pregnant_woman, AppColors.secondary),
        _buildStatCard('Accouchements', '856', Icons.child_care, AppColors.success),
        _buildStatCard('Alertes Urgentes', '14', Icons.warning_amber_rounded, AppColors.error),
        _buildStatCard('Disponibilité', '92%', Icons.check_circle_outline, AppColors.accent),
      ],
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: color, size: 20),
              const Icon(Icons.trending_up, color: AppColors.success, size: 16),
            ],
          ),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textMain),
          ),
          Text(
            label,
            style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildEmergencyCenter(BuildContext context, AsyncValue<List<EmergencyAlert>> emergenciesAsync) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Centre d\'Urgences (Temps Réel)',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        emergenciesAsync.when(
          data: (alerts) {
            if (alerts.isEmpty) {
              return Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(28),
                ),
                child: const Text('Aucune urgence active.', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey)),
              );
            }
            return Column(
              children: alerts.map((alert) => _buildEmergencyTile(alert)).toList(),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, stack) => Text('Erreur: $err'),
        ),
      ],
    );
  }

  Widget _buildEmergencyTile(EmergencyAlert alert) {
    Color color;
    String typeText;
    String actionText;

    switch (alert.type) {
      case EmergencyType.critical:
        color = AppColors.error;
        typeText = 'URGENCE CRITIQUE';
        actionText = 'Équipe d\'intervention requise';
        break;
      case EmergencyType.ambulance:
        color = AppColors.warning;
        typeText = 'DEMANDE AMBULANCE';
        actionText = 'Véhicule en cours de dépêche';
        break;
      case EmergencyType.enRoute:
        color = AppColors.secondary;
        typeText = 'EN ROUTE';
        actionText = 'Arrivée estimée : -- min';
        break;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: color.withValues(alpha: 0.1), width: 1.5),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            child: const Icon(Icons.emergency, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(alert.userName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    Text(
                      DateFormat('HH:mm').format(alert.createdAt),
                      style: const TextStyle(fontSize: 10, color: Colors.grey),
                    ),
                  ],
                ),
                Text(typeText, style: TextStyle(color: color, fontSize: 13, fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Text(actionText, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResourceManagement(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Gestion des Ressources',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            _buildResourceCard('Lits Disponibles', '12/40', Icons.bed_outlined, AppColors.secondary),
            const SizedBox(width: 12),
            _buildResourceCard('Ambulances', '3/5', Icons.medical_services_outlined, AppColors.primary),
          ],
        ),
      ],
    );
  }

  Widget _buildResourceCard(String title, String status, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.grey.shade100),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 12),
            Text(status, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text(title, style: const TextStyle(fontSize: 11, color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}
