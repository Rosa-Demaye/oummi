enum UserRole {
  girl,       // Jeune fille (Santé reproductive)
  pregnant,   // Femme enceinte / Maman
  father,     // Père / Mari
  doctor,     // Médecin / Sage-femme
  hospital,   // Gestionnaire Hôpital
  admin,      // Super Admin OUMI
}

enum DoctorSpecialty {
  gynaecologist,
  obstetrician,
  pediatrician,
  midwife,
  generalPractitioner,
  none,
}

class UserEntity {
  final String id;
  final String email;
  final String fullName;
  final UserRole role;
  final String? phoneNumber;
  final String? profileImageUrl;
  final DateTime createdAt;
  
  // Champs Communs
  final String? language;
  final String? region;
  final String? city;
  final String? location;
  final String? quartier;
  final String? accessCode; // Le code unique OUMI-XXXXXX

  // Spécifique Femme (Jeune & Enceinte)
  final DateTime? dob;
  final String? nationality;
  final String? emergencyContact;
  final String? emergencyRelationship;
  
  // Spécifique Jeune Fille
  final int? cycleLength;
  final DateTime? lastPeriod;

  // Spécifique Femme Enceinte
  final DateTime? dueDate;
  final int? currentWeek;
  final int? numberOfPregnancies;
  final bool? previousCaesarean;
  final bool? highRiskPregnancy;
  final String? partnerPhoneNumber;
  final String? preferredHospitalId;

  // Spécifique Père
  final String? occupation;
  final String? linkedPartnerId;

  // Spécifique Médecin
  final String? medicalRegistrationNumber;
  final DoctorSpecialty specialty;
  final int? yearsExperience;
  final double? consultationFee;
  final bool isVerified;

  // Spécifique Hôpital
  final String? hospitalType; // Public / Privé
  final int? bedCapacity;
  final bool? hasAmbulance;

  // Health Metrics (Current)
  final String bloodPressure;
  final double weight;
  final int glucose;

  UserEntity({
    required this.id,
    required this.email,
    required this.fullName,
    required this.role,
    this.phoneNumber,
    this.profileImageUrl,
    required this.createdAt,
    this.language,
    this.region,
    this.city,
    this.location,
    this.quartier,
    this.accessCode,
    this.dob,
    this.nationality,
    this.emergencyContact,
    this.emergencyRelationship,
    this.cycleLength,
    this.lastPeriod,
    this.dueDate,
    this.currentWeek,
    this.numberOfPregnancies,
    this.previousCaesarean,
    this.highRiskPregnancy,
    this.partnerPhoneNumber,
    this.preferredHospitalId,
    this.occupation,
    this.linkedPartnerId,
    this.medicalRegistrationNumber,
    this.specialty = DoctorSpecialty.none,
    this.yearsExperience,
    this.consultationFee,
    this.isVerified = false,
    this.hospitalType,
    this.bedCapacity,
    this.hasAmbulance,
    this.bloodPressure = '118/140',
    this.weight = 68.0,
    this.glucose = 110,
  });
}
