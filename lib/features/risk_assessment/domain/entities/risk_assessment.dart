enum RiskLevel {
  low, // Green
  medium, // Yellow
  high, // Red
}

class RiskAssessment {
  final String id;
  final DateTime date;
  final Map<String, dynamic> answers;
  final RiskLevel level;
  final String recommendations;

  RiskAssessment({
    required this.id,
    required this.date,
    required this.answers,
    required this.level,
    required this.recommendations,
  });

  static RiskLevel calculateRisk(Map<String, dynamic> answers) {
    // Logic based on PRD: Saignements, Fièvre, etc.
    if (answers['bleeding'] == true || answers['severe_headache'] == true) {
      return RiskLevel.high;
    }
    if (answers['fever'] == true || answers['swelling'] == true) {
      return RiskLevel.medium;
    }
    return RiskLevel.low;
  }
}
