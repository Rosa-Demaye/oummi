class SymptomLog {
  final String id;
  final String userId;
  final DateTime date;
  final String mood;
  final double waterIntake; // in liters
  final double sleepHours;
  final List<String> symptoms;
  final String? note;

  SymptomLog({
    required this.id,
    required this.userId,
    required this.date,
    required this.mood,
    required this.waterIntake,
    required this.sleepHours,
    required this.symptoms,
    this.note,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'date': date.toIso8601String(),
      'mood': mood,
      'waterIntake': waterIntake,
      'sleepHours': sleepHours,
      'symptoms': symptoms,
      'note': note,
    };
  }

  factory SymptomLog.fromMap(String id, Map<String, dynamic> map) {
    return SymptomLog(
      id: id,
      userId: map['userId'] ?? '',
      date: DateTime.parse(map['date']),
      mood: map['mood'] ?? 'Neutral',
      waterIntake: (map['waterIntake'] as num?)?.toDouble() ?? 0.0,
      sleepHours: (map['sleepHours'] as num?)?.toDouble() ?? 0.0,
      symptoms: List<String>.from(map['symptoms'] ?? []),
      note: map['note'],
    );
  }
}
