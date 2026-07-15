import 'package:flutter/material.dart';
import '../../../../theme/app_theme.dart';

class DoctorDashboard extends StatelessWidget {
  const DoctorDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Tableau de Bord Docteur', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            Row(
              children: [
                _buildStatCard('Mes Patientes', '42', Icons.people, Colors.blue),
                const SizedBox(width: 12),
                _buildStatCard('Aujourd\'hui', '5 RDV', Icons.calendar_today, Colors.green),
              ],
            ),
            const SizedBox(height: 12),
            _buildStatCard('Revenus (CFA)', '150 000', Icons.payments_outlined, AppTheme.accentColor),
            const SizedBox(height: 32),
            const Text('Patientes à suivre (Haut Risque)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            _buildPatientTile('Amina Mahamat', 'Semaine 32 - Hypertension', Colors.red),
            _buildPatientTile('Fatima Zahra', 'Semaine 12 - Normal', Colors.grey),
            const SizedBox(height: 32),
            const Text('Actions rapides', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12, runSpacing: 12,
              children: [
                _buildActionChip('Scanner QR Patiente', Icons.qr_code_scanner),
                _buildActionChip('Nouvelle Prescription', Icons.medication),
                _buildActionChip('Rapport Médical', Icons.history_edu),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String label, String val, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(24)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(height: 12),
            Text(val, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color)),
            Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  Widget _buildPatientTile(String name, String status, Color color) {
    return ListTile(
      leading: CircleAvatar(backgroundColor: color.withValues(alpha: 0.1), child: Text(name[0], style: TextStyle(color: color))),
      title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(status),
      trailing: const Icon(Icons.chevron_right),
    );
  }

  Widget _buildActionChip(String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(color: Colors.white, border: Border.all(color: Colors.grey.shade100), borderRadius: BorderRadius.circular(16)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: AppTheme.primaryColor),
          const SizedBox(width: 8),
          Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
