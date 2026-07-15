class WeekDetail {
  final int weekNumber;
  final String babySize;
  final String babyDevelopment;
  final String motherChanges;
  final String tipOfTheWeek;
  final String imagePath;

  WeekDetail({
    required this.weekNumber,
    required this.babySize,
    required this.babyDevelopment,
    required this.motherChanges,
    required this.tipOfTheWeek,
    this.imagePath = '',
  });
}
