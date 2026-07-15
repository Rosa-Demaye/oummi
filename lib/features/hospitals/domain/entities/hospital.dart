class Hospital {
  final String id;
  final String name;
  final String address;
  final double distance; // in km
  final int availableRooms;
  final bool hasAmbulance;
  final String phoneNumber;
  final String imageUrl;
  final List<String> availableSlots;

  Hospital({
    required this.id,
    required this.name,
    required this.address,
    required this.distance,
    required this.availableRooms,
    required this.hasAmbulance,
    required this.phoneNumber,
    required this.imageUrl,
    this.availableSlots = const ['08:00', '10:00', '14:00', '16:00'],
  });
}
