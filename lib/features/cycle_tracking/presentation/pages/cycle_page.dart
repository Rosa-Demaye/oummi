import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_colors.dart';
import '../widgets/add_symptom_bottom_sheet.dart';
import '../providers/cycle_provider.dart';
import '../../domain/models/cycle_record.dart';
import '../../domain/models/symptom_log.dart';

class CyclePage extends ConsumerStatefulWidget {
  const CyclePage({super.key});

  @override
  ConsumerState<CyclePage> createState() => _CyclePageState();
}

class _CyclePageState extends ConsumerState<CyclePage> {
  final CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    final cycleAsync = ref.watch(cycleRecordProvider);
    final logsAsync = ref.watch(symptomLogsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mon Cycle'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined, color: AppColors.textMain),
            onPressed: () {},
          ),
        ],
      ),
      body: cycleAsync.when(
        data: (record) => _buildContent(record, logsAsync.value ?? []),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Erreur: $err')),
      ),
    );
  }

  Widget _buildContent(CycleRecord? record, List<SymptomLog> logs) {
    // If no record exists, show a default mock for demo
    final currentRecord = record ?? CycleRecord(
      currentDay: 1,
      cycleLength: 28,
      phase: CyclePhase.menstruation,
      nextPeriodDate: DateTime.now().add(const Duration(days: 27)),
      ovulationDate: DateTime.now().add(const Duration(days: 14)),
      fertilityProbability: 0.1,
    );

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          _buildCycleDashboard(currentRecord),
          const SizedBox(height: 32),
          _buildInteractiveCalendar(),
          const SizedBox(height: 32),
          _buildDailyCheckIn(logs),
          const SizedBox(height: 32),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: ElevatedButton.icon(
              onPressed: () => _showAddSymptom(context),
              icon: const Icon(Icons.add),
              label: const Text('Enregistrer mes symptômes'),
            ),
          ),
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  void _showAddSymptom(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const AddSymptomBottomSheet(),
    );
  }

  Widget _buildCycleDashboard(CycleRecord record) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(32),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.08),
              blurRadius: 30,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 180,
                  height: 180,
                  child: CircularProgressIndicator(
                    value: record.currentDay / record.cycleLength,
                    strokeWidth: 12,
                    backgroundColor: Colors.grey.shade100,
                    valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                    strokeCap: StrokeCap.round,
                  ),
                ).animate().rotate(duration: 1.seconds, curve: Curves.easeInOutCubic),
                Column(
                  children: [
                    Text(
                      'Jour',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    Text(
                      '${record.currentDay}',
                      style: Theme.of(context).textTheme.displayLarge?.copyWith(
                        fontSize: 48,
                        color: AppColors.primary,
                      ),
                    ),
                    Text(
                      record.phase.name,
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: record.phase.color,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildInfoItem('Prochaines règles', 'dans ${record.nextPeriodDate.difference(DateTime.now()).inDays}j', Icons.water_drop_outlined),
                Container(width: 1, height: 40, color: Colors.grey.shade100),
                _buildInfoItem('Ovulation', record.ovulationDate.difference(DateTime.now()).inDays == 1 ? 'Demain' : 'dans ${record.ovulationDate.difference(DateTime.now()).inDays}j', Icons.flare_outlined),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: AppColors.textSecondary, size: 20),
        const SizedBox(height: 8),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
        Text(value, style: Theme.of(context).textTheme.labelLarge),
      ],
    );
  }

  Widget _buildInteractiveCalendar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
      ),
      child: TableCalendar(
        firstDay: DateTime.utc(2020, 1, 1),
        lastDay: DateTime.utc(2030, 12, 31),
        focusedDay: _focusedDay,
        calendarFormat: _calendarFormat,
        selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
        onDaySelected: (selectedDay, focusedDay) {
          setState(() {
            _selectedDay = selectedDay;
            _focusedDay = focusedDay;
          });
        },
        headerStyle: const HeaderStyle(
          formatButtonVisible: false,
          titleCentered: true,
          titleTextStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        calendarStyle: CalendarStyle(
          todayDecoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          todayTextStyle: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
          selectedDecoration: const BoxDecoration(
            color: AppColors.primary,
            shape: BoxShape.circle,
          ),
          markerDecoration: const BoxDecoration(
            color: AppColors.accent,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }

  Widget _buildDailyCheckIn(List<SymptomLog> logs) {
    // For now, we show latest log or defaults
    final latestLog = logs.isNotEmpty ? logs.first : null;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Check-in du jour', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildCheckInTile('Humeur', latestLog?.mood ?? 'Non renseigné', Icons.sentiment_satisfied_alt_outlined),
                _buildCheckInTile('Eau', '${latestLog?.waterIntake ?? 0} L', Icons.opacity_outlined),
                _buildCheckInTile('Sommeil', '${latestLog?.sleepHours.toInt() ?? 0}h', Icons.bedtime_outlined),
                _buildCheckInTile('Symptômes', latestLog != null && latestLog.symptoms.isNotEmpty ? latestLog.symptoms.join(', ') : 'Aucun', Icons.medical_services_outlined),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckInTile(String label, String value, IconData icon) {
    return Container(
      width: 110,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        children: [
          Icon(icon, color: AppColors.primary, size: 24),
          const SizedBox(height: 12),
          Text(label, style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: 4),
          Text(value, style: Theme.of(context).textTheme.labelLarge, overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }
}
