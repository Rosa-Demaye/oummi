import 'package:flutter/material.dart';
import '../../../../theme/app_theme.dart';
import '../../domain/entities/risk_assessment.dart';

class RiskAssessmentPage extends StatefulWidget {
  const RiskAssessmentPage({super.key});

  @override
  State<RiskAssessmentPage> createState() => _RiskAssessmentPageState();
}

class _RiskAssessmentPageState extends State<RiskAssessmentPage> {
  final Map<String, bool> _answers = {
    'bleeding': false,
    'fever': false,
    'swelling': false,
    'severe_headache': false,
    'reduced_movement': false,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Enquête de Santé')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Comment vous sentez-vous ?',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'Ces questions nous aident à évaluer votre santé et celle de votre bébé.',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 30),
            _buildSwitchTile('Saignements vaginaux', 'bleeding'),
            _buildSwitchTile('Fièvre ou frissons', 'fever'),
            _buildSwitchTile('Gonflement (mains, visage, pieds)', 'swelling'),
            _buildSwitchTile('Maux de tête sévères', 'severe_headache'),
            _buildSwitchTile('Réduction des mouvements du bébé', 'reduced_movement'),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                final risk = RiskAssessment.calculateRisk(_answers);
                _showResult(risk);
              },
              child: const Text('Évaluer mon état'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchTile(String title, String key) {
    return SwitchListTile(
      title: Text(title),
      value: _answers[key]!,
      activeThumbColor: AppTheme.primaryColor,
      onChanged: (val) {
        setState(() {
          _answers[key] = val;
        });
      },
    );
  }

  void _showResult(RiskLevel level) {
    Color color;
    String title;
    String message;
    IconData icon;

    switch (level) {
      case RiskLevel.low:
        color = Colors.green;
        title = 'État Normal';
        message = 'Continuez votre suivi régulier et reposez-vous bien.';
        icon = Icons.check_circle;
        break;
      case RiskLevel.medium:
        color = Colors.orange;
        title = 'Surveillance';
        message = 'Nous vous recommandons de prendre rendez-vous avec votre médecin bientôt.';
        icon = Icons.warning;
        break;
      case RiskLevel.high:
        color = Colors.red;
        title = 'Consultation Urgente';
        message = 'Veuillez contacter immédiatement votre centre de santé ou votre médecin.';
        icon = Icons.emergency;
        break;
    }

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 60),
            const SizedBox(height: 16),
            Text(title, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: color)),
            const SizedBox(height: 12),
            Text(message, textAlign: TextAlign.center, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 24),
            if (level != RiskLevel.low)
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(backgroundColor: color),
                child: const Text('Prendre RDV Maintenant'),
              ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Fermer'),
            ),
          ],
        ),
      ),
    );
  }
}
