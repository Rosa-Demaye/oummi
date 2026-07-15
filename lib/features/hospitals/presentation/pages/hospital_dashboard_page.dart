import 'package:flutter/material.dart';

class HospitalDashboardPage extends StatelessWidget {
  const HospitalDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Tableau de Bord Hôpital'),
        backgroundColor: Colors.white,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: ClipOval(child: Image.asset('assets/images/logo.png', width: 32, height: 32)),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Statistiques Nationales (Tchad)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            Row(
              children: [
                _buildStatCard('Grossesses', '124', Icons.pregnant_woman, Colors.blue),
                const SizedBox(width: 16),
                _buildStatCard('Accouchements', '45', Icons.baby_changing_station, Colors.green),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _buildStatCard('Cas Risqués', '12', Icons.warning_amber, Colors.orange),
                const SizedBox(width: 16),
                _buildStatCard('Interventions', '8', Icons.medical_services, Colors.red),
              ],
            ),
            const SizedBox(height: 32),
            const Text('Alertes en Temps Réel', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            _buildAlerteTile('Amina M.', 'Travail commencé - En route', '2 min ago', Colors.orange),
            _buildAlerteTile('Fatima Z.', 'Urgence critique - Ambulance', '10 min ago', Colors.red),
            const SizedBox(height: 32),
            const Text('Gestion des Salles', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            _buildRoomTile('Salle A101', 'Occupée', Colors.grey),
            _buildRoomTile('Salle B202', 'Disponible', Colors.green),
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
            Icon(icon, color: color),
            const SizedBox(height: 12),
            Text(val, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color)),
            Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  Widget _buildAlerteTile(String name, String desc, String time, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: color.withValues(alpha: 0.2)),
        borderRadius: BorderRadius.circular(16),
        color: color.withValues(alpha: 0.02),
      ),
      child: Row(
        children: [
          CircleAvatar(backgroundColor: color, radius: 4),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
            Text(desc, style: TextStyle(fontSize: 12, color: color)),
          ])),
          Text(time, style: const TextStyle(fontSize: 10, color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildRoomTile(String room, String status, Color color) {
    return ListTile(
      title: Text(room),
      trailing: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(20)),
        child: Text(status, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12)),
      ),
    );
  }
}
