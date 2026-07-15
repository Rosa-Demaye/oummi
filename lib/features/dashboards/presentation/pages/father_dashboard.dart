import 'package:flutter/material.dart';
import '../../../../theme/app_theme.dart';

class FatherDashboard extends StatelessWidget {
  const FatherDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Tableau de Bord Père', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            _buildWifeStatusCard(),
            const SizedBox(height: 32),
            const Text('Suivi de la Grossesse', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            _buildProgressTile('Semaine 24', 'Développement des poumons de bébé', Icons.child_care, Colors.teal),
            _buildProgressTile('Prochain RDV', 'Demain à 10h00', Icons.calendar_today, Colors.blue),
            const SizedBox(height: 32),
            _buildEmergencyCallCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildWifeStatusCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [AppTheme.primaryColor, Colors.indigo]),
        borderRadius: BorderRadius.circular(28),
      ),
      child: const Column(
        children: [
          Row(
            children: [
              CircleAvatar(radius: 24, backgroundColor: Colors.white24, child: Icon(Icons.favorite, color: Colors.white)),
              SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Épouse : Amina M.', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                  Text('Statut : En bonne santé', style: TextStyle(color: Colors.white70, fontSize: 12)),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProgressTile(String title, String desc, IconData icon, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(20)),
      child: Row(
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 16),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            Text(desc, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          ])),
        ],
      ),
    );
  }

  Widget _buildEmergencyCallCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: AppTheme.secondaryColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(24), border: Border.all(color: AppTheme.secondaryColor.withValues(alpha: 0.2))),
      child: const Row(
        children: [
          Icon(Icons.phone_in_talk, color: AppTheme.secondaryColor),
          SizedBox(width: 16),
          Expanded(child: Text('Besoin d\'aide ? Appelez le 17 ou votre médecin en un clic.', style: TextStyle(color: AppTheme.secondaryColor, fontWeight: FontWeight.bold, fontSize: 13))),
        ],
      ),
    );
  }
}
