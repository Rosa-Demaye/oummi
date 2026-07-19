import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../hospitals/domain/entities/hospital.dart';
import '../../domain/entities/emergency_alert.dart';
import '../providers/emergency_provider.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

class LaborDeclarationPage extends ConsumerStatefulWidget {
  const LaborDeclarationPage({super.key});

  @override
  ConsumerState<LaborDeclarationPage> createState() => _LaborDeclarationPageState();
}

class _LaborDeclarationPageState extends ConsumerState<LaborDeclarationPage> {
  Hospital? _selectedHospital;

  final List<Hospital> _hospitals = [
    Hospital(
      id: 'h1',
      name: 'Hôpital de la Renaissance',
      address: 'Quartier NDjari, N\'Djamena',
      distance: 2.5,
      availableRooms: 5,
      hasAmbulance: true,
      phoneNumber: '+235 22 51 00 00',
      imageUrl: 'https://images.unsplash.com/photo-1587350859728-117699f4a13d?auto=format&fit=crop&q=80&w=400',
    ),
    Hospital(
      id: 'h2',
      name: 'Hôpital Mère-Enfant',
      address: 'Quartier Gardolé, N\'Djamena',
      distance: 4.2,
      availableRooms: 2,
      hasAmbulance: true,
      phoneNumber: '+235 22 52 00 00',
      imageUrl: 'https://images.unsplash.com/photo-1519494026892-80bbd2d6fd0d?auto=format&fit=crop&q=80&w=400',
    ),
  ];

  void _triggerEmergency(EmergencyType type) async {
    if (_selectedHospital == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez d\'abord choisir un hôpital.')),
      );
      return;
    }

    final user = ref.read(authStateProvider).value;
    if (user == null) return;

    final alert = EmergencyAlert(
      id: '',
      userId: user.id,
      userName: user.fullName,
      hospitalId: _selectedHospital!.id,
      type: type,
      createdAt: DateTime.now(),
    );

    await ref.read(emergencyNotifierProvider.notifier).triggerAlert(alert);
    
    if (mounted) {
      _showSuccessDialog();
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        title: const Row(
          children: [
            Icon(Icons.check_circle, color: AppColors.success),
            SizedBox(width: 12),
            Text('Alerte Transmise'),
          ],
        ),
        content: Text(
          'Votre signalement a été envoyé avec succès à ${_selectedHospital!.name}. '
          'L\'équipe médicale se prépare à votre arrivée.',
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              context.pop();
            },
            child: const Text('Compris'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Urgence & Accouchement'),
        backgroundColor: AppColors.error,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStatusHeader(),
            const SizedBox(height: 32),
            const Text(
              '1. Choisir l\'Hôpital',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ..._hospitals.map((h) => _buildHospitalCard(h)),
            const SizedBox(height: 32),
            if (_selectedHospital != null) ...[
              const Text(
                '2. Signaler mon État',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              _buildEmergencyActions(),
            ],
            const SizedBox(height: 40),
            _buildSafetyInfo(),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: AppColors.error.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.error.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.security, color: AppColors.error),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'RESTEZ CALME',
                  style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.error, letterSpacing: 1),
                ),
                Text(
                  'OUMMI vous connecte instantanément aux secours.',
                  style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHospitalCard(Hospital hospital) {
    bool isSelected = _selectedHospital?.id == hospital.id;
    return GestureDetector(
      onTap: () => setState(() => _selectedHospital = hospital),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.secondary.withValues(alpha: 0.05) : Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected ? AppColors.secondary : Colors.grey.shade100,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(hospital.imageUrl, width: 60, height: 60, fit: BoxFit.cover),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(hospital.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text(
                    '${hospital.distance} km • ${hospital.availableRooms} salles dispos',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
            if (isSelected) const Icon(Icons.check_circle, color: AppColors.secondary),
          ],
        ),
      ),
    );
  }

  Widget _buildEmergencyActions() {
    return Column(
      children: [
        _buildActionButton(
          'JE SUIS EN ROUTE',
          'Informer l\'hôpital de votre arrivée imminente.',
          Icons.directions_car_outlined,
          AppColors.secondary,
          () => _triggerEmergency(EmergencyType.enRoute),
        ),
        const SizedBox(height: 16),
        _buildActionButton(
          'DEMANDER UNE AMBULANCE',
          'Un véhicule médicalisé sera dépêché vers vous.',
          Icons.airport_shuttle_outlined,
          AppColors.warning,
          () => _triggerEmergency(EmergencyType.ambulance),
        ),
        const SizedBox(height: 16),
        _buildActionButton(
          'URGENCE CRITIQUE',
          'Saignements ou complications graves.',
          Icons.emergency_outlined,
          AppColors.error,
          () => _triggerEmergency(EmergencyType.critical),
        ),
      ],
    );
  }

  Widget _buildActionButton(String title, String sub, IconData icon, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(28),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.1),
              blurRadius: 15,
              offset: const Offset(0, 6),
            ),
          ],
          border: Border.all(color: color.withValues(alpha: 0.1)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(16)),
              child: Icon(icon, color: color),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: color, fontSize: 15)),
                  Text(sub, style: const TextStyle(fontSize: 11, color: Colors.grey)),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 14),
          ],
        ),
      ),
    );
  }

  Widget _buildSafetyInfo() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(24),
      ),
      child: const Row(
        children: [
          Icon(Icons.wifi_off_outlined, color: Colors.grey),
          SizedBox(width: 16),
          Expanded(
            child: Text(
              'En cas de perte de connexion, un SMS crypté contenant votre position et votre code OUMMI sera automatiquement envoyé aux secours.',
              style: TextStyle(fontSize: 11, color: Colors.grey, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }
}
