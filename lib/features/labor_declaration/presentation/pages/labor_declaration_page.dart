import 'package:flutter/material.dart';
import '../../../../theme/app_theme.dart';
import '../../../hospitals/domain/entities/hospital.dart';

class LaborDeclarationPage extends StatefulWidget {
  const LaborDeclarationPage({super.key});

  @override
  State<LaborDeclarationPage> createState() => _LaborDeclarationPageState();
}

class _LaborDeclarationPageState extends State<LaborDeclarationPage> {
  Hospital? _selectedHospital;
  String? _selectedSlot;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Urgence & Accouchement'),
        backgroundColor: AppTheme.secondaryColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildEmergencyStatus(),
            const SizedBox(height: 32),
            const Text('Étape 1 : Choisir l\'Hôpital Proche', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            ..._hospitals.map((h) => _buildHospitalCard(h)),
            if (_selectedHospital != null) ...[
              const SizedBox(height: 32),
              const Text('Étape 2 : Réserver une Salle / Créneau', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              _buildSlotPicker(),
              const SizedBox(height: 32),
              const Text('Étape 3 : Actions Immédiates', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              _buildActionGrid(),
            ],
            const SizedBox(height: 40),
            _buildOfflineCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildEmergencyStatus() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.secondaryColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.secondaryColor.withValues(alpha: 0.2)),
      ),
      child: const Row(
        children: [
          Icon(Icons.flash_on, color: AppTheme.secondaryColor),
          SizedBox(width: 16),
          Expanded(
            child: Text(
              'RESTEZ CALME. Votre signalement sera transmis instantanément aux équipes de garde.',
              style: TextStyle(color: AppTheme.secondaryColor, fontWeight: FontWeight.bold),
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
          color: isSelected ? AppTheme.primaryColor.withValues(alpha: 0.05) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isSelected ? AppTheme.primaryColor : Colors.grey.shade200, width: isSelected ? 2 : 1),
        ),
        child: Row(
          children: [
            ClipRRect(borderRadius: BorderRadius.circular(12), child: Image.network(hospital.imageUrl, width: 50, height: 50, fit: BoxFit.cover)),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(hospital.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text('${hospital.distance} km • ${hospital.availableRooms} salles dispos', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                ],
              ),
            ),
            if (isSelected) const Icon(Icons.check_circle, color: AppTheme.primaryColor),
          ],
        ),
      ),
    );
  }

  Widget _buildSlotPicker() {
    return Wrap(
      spacing: 8,
      children: _selectedHospital!.availableSlots.map((s) {
        bool isSel = _selectedSlot == s;
        return ChoiceChip(
          label: Text(s),
          selected: isSel,
          onSelected: (val) => setState(() => _selectedSlot = s),
          selectedColor: AppTheme.primaryColor,
          labelStyle: TextStyle(color: isSel ? Colors.white : Colors.black),
        );
      }).toList(),
    );
  }

  Widget _buildActionGrid() {
    return Column(
      children: [
        _buildActionRow('EN ROUTE', 'Informer l\'hôpital de votre arrivée.', Icons.directions_car, Colors.blue),
        const SizedBox(height: 12),
        _buildActionRow('AMBULANCE', 'Demander un véhicule médicalisé.', Icons.airport_shuttle, Colors.orange),
        const SizedBox(height: 12),
        _buildActionRow('URGENCE CRITIQUE', 'Saignements ou complications graves.', Icons.emergency, Colors.red),
      ],
    );
  }

  Widget _buildActionRow(String title, String sub, IconData icon, Color color) {
    return InkWell(
      onTap: () => _confirmAction(title),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade100),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10)],
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(width: 16),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: color)),
              Text(sub, style: const TextStyle(fontSize: 11, color: Colors.grey)),
            ])),
            const Icon(Icons.chevron_right, color: Colors.grey, size: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildOfflineCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(16)),
      child: const Row(
        children: [
          Icon(Icons.signal_wifi_off, color: Colors.grey),
          SizedBox(width: 12),
          Expanded(child: Text('Pas de connexion ? Votre code d\'urgence est actif et transmis via SMS crypté.', style: TextStyle(fontSize: 11, color: Colors.grey))),
        ],
      ),
    );
  }

  void _confirmAction(String action) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(action),
        content: Text('Transmettre cette alerte à ${_selectedHospital!.name} ?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Annuler')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Alerte transmise ! L\'équipe médicale vous attend.'), backgroundColor: Colors.green));
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            child: const Text('Confirmer'),
          )
        ],
      ),
    );
  }
}
