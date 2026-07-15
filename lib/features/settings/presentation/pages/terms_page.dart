import 'package:flutter/material.dart';
import '../../../../theme/app_theme.dart';

class TermsPage extends StatelessWidget {
  const TermsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('Conditions d\'Utilisation'), backgroundColor: Colors.white),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Bienvenue sur OUMI', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppTheme.primaryColor)),
            const SizedBox(height: 16),
            const Text(
              'En utilisant OUMI, vous acceptez les conditions suivantes relatives à la confidentialité de vos données de santé au Tchad.',
              style: TextStyle(height: 1.5),
            ),
            const SizedBox(height: 24),
            _buildSection('1. Confidentialité', 'Vos données médicales sont cryptées et accessibles uniquement par vous et les professionnels de santé que vous autorisez via votre code partenaire.'),
            _buildSection('2. Responsabilité', 'OUMI est une plateforme d\'assistance. En cas d\'urgence vitale, contactez immédiatement les services de secours nationaux (17).'),
            _buildSection('3. Paiements', 'Les fonds versés pour les consultations sont conservés de manière sécurisée (Escrow) jusqu\'à la validation effective de l\'acte médical.'),
            const SizedBox(height: 40),
            Center(
              child: Text(
                'Dernière mise à jour : Juillet 2024',
                style: TextStyle(color: Colors.grey.shade400, fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 8),
          Text(content, style: const TextStyle(color: Colors.grey, height: 1.5)),
        ],
      ),
    );
  }
}
