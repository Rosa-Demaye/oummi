import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

class YoungWomanDashboard extends ConsumerWidget {
  const YoungWomanDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authStateProvider).value;
    
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Bonjour,', style: TextStyle(color: Colors.grey, fontSize: 14)),
            Text(
              '${user?.fullName.split(' ').first ?? 'Amira'} 🌸',
              style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.black87),
            onPressed: () {},
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16.0, left: 8.0),
            child: CircleAvatar(
              backgroundColor: const Color(0xFFD97D64).withValues(alpha: 0.5),
              radius: 18,
              child: const Text('AK', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Current Phase Banner
            _buildPhaseBanner(),
            const SizedBox(height: 24),
            
            // Action Tiles Grid
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 1.1,
              children: [
                _buildActionCard('Journal', 'Notez vos symptômes', Icons.edit_note, const Color(0xFFFFF3F0), Colors.redAccent),
                _buildActionCard('Humeur', 'Comment ça va?', Icons.sentiment_satisfied_alt, const Color(0xFFF0FFF4), Colors.green),
                _buildActionCard('Éducation', 'Articles santé', Icons.library_books_outlined, const Color(0xFFEBF8FF), Colors.blue),
                _buildActionCard('Communauté', 'Échangez avec d\'autres', Icons.groups_outlined, const Color(0xFFFFF5F7), Colors.purple),
              ],
            ),
            const SizedBox(height: 32),
            
            // Tip of the day
            _buildTipCard(),
            const SizedBox(height: 32),
            
            // Today's Symptoms
            _buildSymptomSection(),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildPhaseBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      decoration: BoxDecoration(
        color: const Color(0xFFD97D64), // Peach/Orange from Figma
        borderRadius: BorderRadius.circular(30),
      ),
      child: const Text(
        'PHASE ACTUELLE',
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 1.5, fontSize: 12),
      ),
    );
  }

  Widget _buildActionCard(String title, String sub, IconData icon, Color bgColor, Color iconColor) {
    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(24),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: iconColor, size: 28),
          const SizedBox(height: 12),
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          const SizedBox(height: 4),
          Text(sub, style: const TextStyle(fontSize: 11, color: Colors.black54)),
        ],
      ),
    );
  }

  Widget _buildTipCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: Colors.amber.withValues(alpha: 0.1), shape: BoxShape.circle),
            child: const Icon(Icons.lightbulb_outline, color: Colors.amber, size: 20),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Conseil du jour', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                SizedBox(height: 8),
                Text(
                  'En phase fertile, restez bien hydratée et favorisez les aliments riches en acide folique comme les légumes verts.',
                  style: TextStyle(color: Colors.grey, fontSize: 13, height: 1.5),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSymptomSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Symptômes aujourd\'hui', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            TextButton(
              onPressed: () {},
              child: const Text('+ Ajouter', style: TextStyle(color: Color(0xFFD97D64), fontWeight: FontWeight.bold)),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildSymptomChip('Légère crampe', const Color(0xFFFFF3F0), Colors.redAccent),
              const SizedBox(width: 12),
              _buildSymptomChip('Fatigue', const Color(0xFFFFF3F0), Colors.redAccent),
              const SizedBox(width: 12),
              _buildSymptomChip('Humeur positive 🤩', const Color(0xFFF0FFF4), Colors.green),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildSymptomChip(String label, Color bgColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 13),
      ),
    );
  }
}
