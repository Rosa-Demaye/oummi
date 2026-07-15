import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/models/symptom_log.dart';
import '../providers/cycle_provider.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

class AddSymptomBottomSheet extends ConsumerStatefulWidget {
  const AddSymptomBottomSheet({super.key});

  @override
  ConsumerState<AddSymptomBottomSheet> createState() => _AddSymptomBottomSheetState();
}

class _AddSymptomBottomSheetState extends ConsumerState<AddSymptomBottomSheet> {
  String _selectedMood = 'Calm';
  double _waterIntake = 1.5;
  double _sleepHours = 8.0;
  final List<String> _selectedSymptoms = [];

  final List<Map<String, dynamic>> _moods = [
    {'label': 'Happy', 'icon': Icons.sentiment_very_satisfied, 'color': Colors.orange},
    {'label': 'Calm', 'icon': Icons.sentiment_satisfied, 'color': Colors.blue},
    {'label': 'Neutral', 'icon': Icons.sentiment_neutral, 'color': Colors.grey},
    {'label': 'Sad', 'icon': Icons.sentiment_dissatisfied, 'color': Colors.indigo},
    {'label': 'Irritated', 'icon': Icons.sentiment_very_dissatisfied, 'color': Colors.red},
  ];

  final List<String> _symptomsList = [
    'Cramps', 'Headache', 'Nausea', 'Fatigue', 'Acne', 'Back pain', 'Bloating'
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Check-in du jour', style: Theme.of(context).textTheme.titleLarge),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 24),
            
            _buildSectionTitle('Humeur'),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: _moods.map((mood) => _buildMoodItem(mood)).toList(),
            ),
            
            const SizedBox(height: 32),
            _buildSectionTitle('Symptômes'),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _symptomsList.map((symptom) => FilterChip(
                label: Text(symptom),
                selected: _selectedSymptoms.contains(symptom),
                onSelected: (selected) {
                  setState(() {
                    if (selected) {
                      _selectedSymptoms.add(symptom);
                    } else {
                      _selectedSymptoms.remove(symptom);
                    }
                  });
                },
                selectedColor: AppColors.primary.withValues(alpha: 0.2),
                checkmarkColor: AppColors.primary,
              )).toList(),
            ),

            const SizedBox(height: 32),
            _buildSectionTitle('Eau (Litres): ${_waterIntake.toStringAsFixed(1)}L'),
            Slider(
              value: _waterIntake,
              min: 0,
              max: 4,
              divisions: 8,
              onChanged: (val) => setState(() => _waterIntake = val),
            ),

            const SizedBox(height: 24),
            _buildSectionTitle('Sommeil: ${_sleepHours.toInt()}h'),
            Slider(
              value: _sleepHours,
              min: 0,
              max: 12,
              divisions: 12,
              onChanged: (val) => setState(() => _sleepHours = val),
            ),

            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: _saveLog,
              child: const Text('Enregistrer'),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
    );
  }

  Widget _buildMoodItem(Map<String, dynamic> mood) {
    bool isSelected = _selectedMood == mood['label'];
    return GestureDetector(
      onTap: () => setState(() => _selectedMood = mood['label']),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isSelected ? mood['color'].withValues(alpha: 0.2) : Colors.white,
              shape: BoxShape.circle,
              border: isSelected ? Border.all(color: mood['color'], width: 2) : null,
            ),
            child: Icon(
              mood['icon'],
              color: isSelected ? mood['color'] : Colors.grey,
              size: 30,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            mood['label'],
            style: TextStyle(
              fontSize: 10,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected ? mood['color'] : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  void _saveLog() async {
    final user = ref.read(authStateProvider).value;
    if (user == null) return;

    final log = SymptomLog(
      id: '', // Will be generated by Firestore
      userId: user.id,
      date: DateTime.now(),
      mood: _selectedMood,
      waterIntake: _waterIntake,
      sleepHours: _sleepHours,
      symptoms: _selectedSymptoms,
    );

    await ref.read(cycleNotifierProvider.notifier).logSymptoms(log);
    if (mounted) Navigator.pop(context);
  }
}
