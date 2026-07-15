class PregnancyEntity {
  final DateTime lastMenstrualPeriod;
  final DateTime? dueDate;
  final int currentWeek;

  PregnancyEntity({
    required this.lastMenstrualPeriod,
    this.dueDate,
    required this.currentWeek,
  });

  // Business logic to calculate current week
  static int calculateCurrentWeek(DateTime lmp) {
    final difference = DateTime.now().difference(lmp);
    return (difference.inDays / 7).floor();
  }

  // Business logic to calculate due date
  static DateTime calculateDueDate(DateTime lmp) {
    return lmp.add(const Duration(days: 280)); // Standard 40 weeks
  }
}
