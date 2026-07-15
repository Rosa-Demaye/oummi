class PregnancyData {
  final DateTime startDate;
  final DateTime dueDate;
  final int currentWeek;
  final bool isHighRisk;
  final String? preferredHospitalId;

  PregnancyData({
    required this.startDate,
    required this.dueDate,
    required this.currentWeek,
    this.isHighRisk = false,
    this.preferredHospitalId,
  });

  Map<String, dynamic> toMap() {
    return {
      'startDate': startDate.toIso8601String(),
      'dueDate': dueDate.toIso8601String(),
      'currentWeek': currentWeek,
      'isHighRisk': isHighRisk,
      'preferredHospitalId': preferredHospitalId,
    };
  }

  factory PregnancyData.fromMap(Map<String, dynamic> map) {
    return PregnancyData(
      startDate: DateTime.parse(map['startDate']),
      dueDate: DateTime.parse(map['dueDate']),
      currentWeek: map['currentWeek'] ?? 1,
      isHighRisk: map['isHighRisk'] ?? false,
      preferredHospitalId: map['preferredHospitalId'],
    );
  }
}
