class Doctor {
  final String id;
  final String name;
  final String specialty;
  final String hospital;
  final String imageUrl;
  final double rating;
  final int reviewsCount;
  final double consultationFee;
  final bool isVerified;
  final List<String> availableSlots;

  Doctor({
    required this.id,
    required this.name,
    required this.specialty,
    required this.hospital,
    required this.imageUrl,
    this.rating = 4.8,
    this.reviewsCount = 120,
    required this.consultationFee,
    this.isVerified = true,
    required this.availableSlots,
  });
}
