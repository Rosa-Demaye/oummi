import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../domain/entities/doctor.dart';
import '../../../../theme/app_theme.dart';

class DoctorSearchPage extends StatefulWidget {
  const DoctorSearchPage({super.key});

  @override
  State<DoctorSearchPage> createState() => _DoctorSearchPageState();
}

class _DoctorSearchPageState extends State<DoctorSearchPage> {
  final List<Doctor> _doctors = [
    Doctor(
      id: 'd1',
      name: 'Dr. Mahamat Nour',
      specialty: 'Gynécologue Obstétricien',
      hospital: 'Hôpital de la Renaissance',
      imageUrl: 'https://i.pravatar.cc/150?u=d1',
      consultationFee: 10000,
      availableSlots: ['09:00', '10:30', '14:00', '16:00'],
    ),
    Doctor(
      id: 'd2',
      name: 'Dr. Fatima Zahra',
      specialty: 'Sage-femme Spécialisée',
      hospital: 'Clinique Olivia',
      imageUrl: 'https://i.pravatar.cc/150?u=d2',
      consultationFee: 5000,
      availableSlots: ['08:00', '11:00', '15:30'],
    ),
    Doctor(
      id: 'd3',
      name: 'Dr. Youssouf Ali',
      specialty: 'Pédiatre',
      hospital: 'Hôpital Mère-Enfant',
      imageUrl: 'https://i.pravatar.cc/150?u=d3',
      consultationFee: 7500,
      availableSlots: ['10:00', '12:00', '17:00'],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trouver un Spécialiste'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Rechercher un médecin, une spécialité...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.tune),
                  onPressed: () {},
                ),
              ),
            ),
          ),
          SizedBox(
            height: 50,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _buildFilterChip('Tous', true),
                _buildFilterChip('Gynécologue', false),
                _buildFilterChip('Sage-femme', false),
                _buildFilterChip('Pédiatre', false),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _doctors.length,
              itemBuilder: (context, index) {
                final doctor = _doctors[index];
                return _buildDoctorCard(doctor);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isSelected) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (val) {},
        backgroundColor: Colors.white,
        selectedColor: AppTheme.primaryColor.withAlpha(26),
        labelStyle: TextStyle(
          color: isSelected ? AppTheme.primaryColor : Colors.black87,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        side: BorderSide(color: isSelected ? AppTheme.primaryColor : Colors.grey.shade200),
      ),
    );
  }

  Widget _buildDoctorCard(Doctor doctor) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () => context.push('/doctor-details', extra: doctor),
        borderRadius: BorderRadius.circular(24),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  doctor.imageUrl,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 80,
                    height: 80,
                    color: AppTheme.primaryColor.withAlpha(26),
                    child: const Icon(Icons.person, color: AppTheme.primaryColor),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          doctor.name,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        if (doctor.isVerified)
                          const Padding(
                            padding: EdgeInsets.only(left: 4.0),
                            child: Icon(Icons.verified, color: Colors.blue, size: 16),
                          ),
                      ],
                    ),
                    Text(
                      doctor.specialty,
                      style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.location_on_outlined, size: 14, color: Colors.grey),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            doctor.hospital,
                            style: const TextStyle(color: Colors.grey, fontSize: 12),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.star, color: Colors.amber, size: 16),
                            const SizedBox(width: 4),
                            Text(
                              '${doctor.rating}',
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                            ),
                            Text(
                              ' (${doctor.reviewsCount})',
                              style: const TextStyle(color: Colors.grey, fontSize: 12),
                            ),
                          ],
                        ),
                        Text(
                          '${doctor.consultationFee.toStringAsFixed(0)} FCFA',
                          style: const TextStyle(
                            color: AppTheme.primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
