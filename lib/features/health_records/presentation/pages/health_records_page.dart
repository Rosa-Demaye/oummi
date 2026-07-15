import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../../../theme/app_theme.dart';
import '../../../auth/domain/entities/user_entity.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

class HealthRecordsPage extends ConsumerWidget {
  const HealthRecordsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authStateProvider).value;
    final isDoctor = user?.role == UserRole.doctor;
    final isFather = user?.role == UserRole.father;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Dossier Médical'),
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () => _showAccessCodeDialog(context, user),
            icon: const Icon(Icons.qr_code_2),
            tooltip: 'Mon Code d\'Accès',
          ),
          IconButton(onPressed: () {}, icon: const Icon(Icons.file_download_outlined)),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (isDoctor || isFather) _buildAccessInput(),
            const SizedBox(height: 16),
            _buildStatusCard(),
            const SizedBox(height: 24),
            _buildRecordsList(),
          ],
        ),
      ),
      floatingActionButton: isDoctor 
          ? FloatingActionButton(
              onPressed: () => _showAddEntryDialog(context),
              backgroundColor: AppTheme.primaryColor,
              child: const Icon(Icons.add, color: Colors.white),
            )
          : null,
    );
  }

  Widget _buildAccessInput() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Accéder à un dossier patiente', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          TextField(
            decoration: InputDecoration(
              hintText: 'Entrer le code OUMI-XXXXXX',
              suffixIcon: IconButton(
                icon: const Icon(Icons.qr_code_scanner),
                onPressed: () {}, 
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.green.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.green.withValues(alpha: 0.1)),
        ),
        child: const Row(
          children: [
            Icon(Icons.verified, color: Colors.green, size: 28),
            SizedBox(width: 16),
            Expanded(
              child: Text(
                'Dossier Authentifié par le Ministère de la Santé du Tchad.',
                style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 13),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecordsList() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Consultations & Examens', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          _buildRecordTile('Échographie T1', '12 Juil 2024', 'Hôpital Renaissance', true),
          _buildRecordTile('Bilan Sanguin', '05 Juil 2024', 'Labo BioTchad', true),
          _buildRecordTile('Consultation Mensuelle', '01 Juil 2024', 'Dr. Mahamat Nour', false),
        ],
      ),
    );
  }

  Widget _buildRecordTile(String title, String date, String author, bool isCertified) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: AppTheme.primaryColor.withValues(alpha: 0.05), shape: BoxShape.circle),
            child: const Icon(Icons.description_outlined, color: AppTheme.primaryColor, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
                Text('$date • $author', style: const TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
          ),
          if (isCertified) const Icon(Icons.verified, color: Colors.blue, size: 18),
        ],
      ),
    );
  }

  void _showAccessCodeDialog(BuildContext context, UserEntity? user) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(32))),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Mon Code OUMI', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            const Text('Partagez ce code avec votre mari ou votre médecin pour leur donner accès à votre dossier.', 
              textAlign: TextAlign.center, style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 32),
            QrImageView(
              data: user?.accessCode ?? 'OUMI-ERROR',
              version: QrVersions.auto,
              size: 200.0,
              eyeStyle: const QrEyeStyle(eyeShape: QrEyeShape.square, color: AppTheme.primaryColor),
              dataModuleStyle: const QrDataModuleStyle(dataModuleShape: QrDataModuleShape.square, color: AppTheme.primaryColor),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(12)),
              child: Text(user?.accessCode ?? '---', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, letterSpacing: 2)),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddEntryDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Nouvel examen'),
        content: const Text('Interface réservée aux médecins pour ajouter un document authentifié au dossier de la patiente.'),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Fermer'))],
      ),
    );
  }
}
