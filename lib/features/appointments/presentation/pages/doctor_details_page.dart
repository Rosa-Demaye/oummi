import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../domain/entities/doctor.dart';
import '../../../../theme/app_theme.dart';

class DoctorDetailsPage extends StatefulWidget {
  final Doctor doctor;
  const DoctorDetailsPage({super.key, required this.doctor});

  @override
  State<DoctorDetailsPage> createState() => _DoctorDetailsPageState();
}

class _DoctorDetailsPageState extends State<DoctorDetailsPage> {
  String? _selectedSlot;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 250,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.network(
                widget.doctor.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: AppTheme.primaryColor.withAlpha(26),
                  child: const Icon(Icons.person, size: 100, color: AppTheme.primaryColor),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.doctor.name,
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            widget.doctor.specialty,
                            style: const TextStyle(color: AppTheme.primaryColor, fontWeight: FontWeight.w600, fontSize: 16),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.green.withAlpha(26),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.chat_outlined, color: Colors.green),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildInfoColumn('Patients', '500+'),
                      _buildInfoColumn('Expérience', '10 ans'),
                      _buildInfoColumn('Note', '${widget.doctor.rating}'),
                    ],
                  ),
                  const SizedBox(height: 32),
                  const Text('À propos', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  const SizedBox(height: 8),
                  const Text(
                    'Spécialiste dévoué à la santé maternelle et néonatale. Accompagne les femmes dans leur parcours de maternité avec expertise et bienveillance.',
                    style: TextStyle(color: Colors.grey, height: 1.5),
                  ),
                  const SizedBox(height: 32),
                  const Text('Disponibilités', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: widget.doctor.availableSlots.map((slot) => _buildSlotChip(slot)).toList(),
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black.withAlpha(13), blurRadius: 20, offset: const Offset(0, -5))],
        ),
        child: Row(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Prix total', style: TextStyle(color: Colors.grey, fontSize: 12)),
                Text(
                  '${widget.doctor.consultationFee.toStringAsFixed(0)} FCFA',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: AppTheme.primaryColor),
                ),
              ],
            ),
            const SizedBox(width: 24),
            Expanded(
              child: ElevatedButton(
                onPressed: _selectedSlot == null
                    ? null
                    : () {
                        context.push('/payment', extra: {
                          'amount': widget.doctor.consultationFee,
                          'description': 'RDV avec ${widget.doctor.name}'
                        });
                      },
                child: const Text('Réserver'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoColumn(String label, String value) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
      ],
    );
  }

  Widget _buildSlotChip(String slot) {
    bool isSelected = _selectedSlot == slot;
    return InkWell(
      onTap: () => setState(() => _selectedSlot = slot),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryColor : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isSelected ? AppTheme.primaryColor : Colors.grey.shade200),
        ),
        child: Text(
          slot,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black87,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
