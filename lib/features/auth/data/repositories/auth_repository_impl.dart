import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final FirebaseAuth _firebaseAuth;

  AuthRepositoryImpl(this._remoteDataSource, this._firebaseAuth);

  @override
  Stream<UserEntity?> get authStateChanges => _firebaseAuth.authStateChanges().asyncMap((user) async {
        if (user == null) return null;
        try {
          final userData = await _remoteDataSource.getUserData(user.uid);
          if (userData == null) return null;
          return _mapToEntity(user.uid, userData);
        } catch (e) {
          return null;
        }
      });

  @override
  Future<UserEntity> signInWithEmailAndPassword(String email, String password) async {
    final credential = await _remoteDataSource.signIn(email, password);
    final userData = await _remoteDataSource.getUserData(credential.user!.uid);
    if (userData == null) throw Exception('Profil Firestore introuvable');
    return _mapToEntity(credential.user!.uid, userData);
  }

  @override
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
    // New parameters can be added here as needed for the UI forms
  }) async {
    UserCredential? credential;
    try {
      credential = await _remoteDataSource.signUp(email, password);
      
      // Génération d'un code OUMI unique (ex: OUMI-7F23X)
      final random = Random();
      final code = 'OUMI-${List.generate(5, (index) => 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789'[random.nextInt(31)]).join()}';

      final userEntity = UserEntity(
        id: credential.user!.uid,
        email: email,
        fullName: fullName,
        role: role,
        phoneNumber: phoneNumber,
        location: location,
        quartier: quartier,
        partnerPhoneNumber: partnerPhoneNumber,
        accessCode: code,
        specialty: specialty,
        createdAt: DateTime.now(),
      );
      
      await _remoteDataSource.saveUserData(userEntity);
      return userEntity;
    } catch (e) {
      if (credential?.user != null) await credential!.user!.delete();
      rethrow;
    }
  }

  @override
  Future<void> signOut() => _firebaseAuth.signOut();

  @override
  Future<UserEntity?> getCurrentUser() async {
    final user = _firebaseAuth.currentUser;
    if (user == null) return null;
    final userData = await _remoteDataSource.getUserData(user.uid);
    if (userData == null) return null;
    return _mapToEntity(user.uid, userData);
  }

  @override
  Future<UserEntity> signInWithGoogle() async {
    throw UnimplementedError('Intégration Google en cours...');
  }

  UserEntity _mapToEntity(String uid, Map<String, dynamic> data) {
    return UserEntity(
      id: uid,
      email: data['email'] ?? '',
      fullName: data['fullName'] ?? '',
      role: UserRole.values.firstWhere((e) => e.name == data['role'], orElse: () => UserRole.girl),
      phoneNumber: data['phoneNumber'],
      accessCode: data['accessCode'],
      location: data['location'],
      quartier: data['quartier'],
      specialty: DoctorSpecialty.values.firstWhere((e) => e.name == data['specialty'], orElse: () => DoctorSpecialty.none),
      currentWeek: data['currentWeek'] ?? 1,
      createdAt: DateTime.tryParse(data['createdAt'] ?? '') ?? DateTime.now(),
      // Mappage des autres champs...
    );
  }
}
