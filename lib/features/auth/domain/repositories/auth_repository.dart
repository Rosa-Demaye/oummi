import '../entities/user_entity.dart';

abstract class AuthRepository {
  Stream<UserEntity?> get authStateChanges;
  
  Future<UserEntity> signInWithEmailAndPassword(String email, String password);
  
  Future<UserEntity> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String fullName,
    required UserRole role,
    String? phoneNumber,
    String? location,
    String? quartier,
    String? partnerPhoneNumber,
    DoctorSpecialty specialty = DoctorSpecialty.none,
  });
  
  Future<void> signOut();
  
  Future<UserEntity?> getCurrentUser();
  
  Future<UserEntity> signInWithGoogle();
}
