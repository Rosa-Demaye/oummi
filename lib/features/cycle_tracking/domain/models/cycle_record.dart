import 'package:flutter/material.dart';

enum CyclePhase {
  menstruation,
  follicular,
  ovulation,
  luteal,
}

extension CyclePhaseExt on CyclePhase {
  String get name {
    switch (this) {
      case CyclePhase.menstruation: return 'Menstruation';
      case CyclePhase.follicular: return 'Phase Folliculaire';
      case CyclePhase.ovulation: return 'Ovulation';
      case CyclePhase.luteal: return 'Phase Lutéale';
    }
  }

  Color get color {
    switch (this) {
      case CyclePhase.menstruation: return const Color(0xFFF25F5C);
      case CyclePhase.follicular: return const Color(0xFF4A90E2);
      case CyclePhase.ovulation: return const Color(0xFFC7B6FF);
      case CyclePhase.luteal: return const Color(0xFFFFB547);
    }
  }
}

class CycleRecord {
  final int currentDay;
  final int cycleLength;
  final CyclePhase phase;
  final DateTime nextPeriodDate;
  final DateTime ovulationDate;
  final double fertilityProbability;

  CycleRecord({
    required this.currentDay,
    required this.cycleLength,
    required this.phase,
    required this.nextPeriodDate,
    required this.ovulationDate,
    required this.fertilityProbability,
  });

  Map<String, dynamic> toMap() {
    return {
      'currentDay': currentDay,
      'cycleLength': cycleLength,
      'phase': phase.index,
      'nextPeriodDate': nextPeriodDate.toIso8601String(),
      'ovulationDate': ovulationDate.toIso8601String(),
      'fertilityProbability': fertilityProbability,
    };
  }

  factory CycleRecord.fromMap(Map<String, dynamic> map) {
    return CycleRecord(
      currentDay: map['currentDay'] ?? 1,
      cycleLength: map['cycleLength'] ?? 28,
      phase: CyclePhase.values[map['phase'] ?? 0],
      nextPeriodDate: DateTime.parse(map['nextPeriodDate']),
      ovulationDate: DateTime.parse(map['ovulationDate']),
      fertilityProbability: (map['fertilityProbability'] as num?)?.toDouble() ?? 0.0,
    );
  }
}
