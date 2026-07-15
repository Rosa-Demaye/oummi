import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../theme/app_theme.dart';

class AppointmentListPage extends StatelessWidget {
  const AppointmentListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rendez-vous'),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            decoration: const BoxDecoration(color: AppTheme.primaryColor, shape: BoxShape.circle),
            child: IconButton(
              icon: const Icon(Icons.add, color: Colors.white),
              onPressed: () => context.push('/doctor-search'),
            ),
          )
        ],
      ),
      body: Column(
        children: [
          _buildFilters(),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(24),
              children: [
                _buildSectionHeader('AOÛT 2024'),
                _buildAppointmentCard(
                  context,
                  'Dr. Halimé Idriss',
                  'Gynécologie',
                  '15 août',
                  '10h00',
                  'Présentiel',
                  'À venir',
                  'DH',
                ),
                _buildAppointmentCard(
                  context,
                  'Dr. Moussa Ali',
                  'Sage-Femme',
                  '28 août',
                  '14h30',
                  'Vidéo',
                  'À venir',
                  'DM',
                ),
                const SizedBox(height: 24),
                _buildSectionHeader('JUILLET 2024'),
                _buildAppointmentCard(
                  context,
                  'Dr. Amina Deby',
                  'Pédiatre',
                  '10 juil',
                  '09h00',
                  'Présentiel',
                  'Stable',
                  'DA',
                  isPast: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          _buildFilterChip('Tous', true),
          _buildFilterChip('À venir', false),
          _buildFilterChip('Passés', false),
          _buildFilterChip('Annulés', false),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isSelected) {
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryColor : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        title,
        style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, letterSpacing: 1.2),
      ),
    );
  }

  Widget _buildAppointmentCard(
    BuildContext context,
    String name,
    String specialty,
    String date,
    String time,
    String type,
    String status,
    String initials, {
    bool isPast = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: AppTheme.primaryColor.withAlpha(26),
                child: Text(initials, style: const TextStyle(color: AppTheme.primaryColor, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    Text(specialty, style: TextStyle(color: Colors.grey, fontSize: 14)),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: isPast ? const Color(0xFFE8F5E9) : const Color(0xFFE0F2F1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    color: isPast ? Colors.green : Colors.teal,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              )
            ],
          ),
          const SizedBox(height: 20),
          const Divider(),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildIconText(Icons.calendar_today_outlined, date),
              _buildIconText(Icons.access_time, time),
              _buildIconText(
                type == 'Vidéo' ? Icons.videocam_outlined : Icons.location_on_outlined,
                type,
                color: type == 'Vidéo' ? Colors.teal : Colors.grey,
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildIconText(IconData icon, String text, {Color color = Colors.grey}) {
    return Row(
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 6),
        Text(text, style: TextStyle(color: color, fontSize: 13, fontWeight: FontWeight.w500)),
      ],
    );
  }
}
