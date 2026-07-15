import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/user_entity.dart';

abstract class AuthRemoteDataSource {
  Future<UserCredential> signIn(String email, String password);
  Future<UserCredential> signUp(String email, String password);
  Future<void> saveUserData(UserEntity user);
  Future<Map<String, dynamic>?> getUserData(String uid);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  AuthRemoteDataSourceImpl(this._firebaseAuth, this._firestore);

  @override
  Future<UserCredential> signIn(String email, String password) {
    return _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  @override
  Future<UserCredential> signUp(String email, String password) {
    return _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  @override
  Future<void> saveUserData(UserEntity user) {
    return _firestore.collection('users').doc(user.id).set({
      'email': user.email,
      'fullName': user.fullName,
      'role': user.role.name,
      'phoneNumber': user.phoneNumber,
      'profileImageUrl': user.profileImageUrl,
      'createdAt': user.createdAt.toIso8601String(),
      'location': user.location,
      'quartier': user.quartier,
      'partnerPhoneNumber': user.partnerPhoneNumber,
      'accessCode': user.accessCode,
      'specialty': user.specialty.name,
      'bloodPressure': user.bloodPressure,
      'weight': user.weight,
      'glucose': user.glucose,
      'currentWeek': user.currentWeek,
    });
  }

  @override
  Future<Map<String, dynamic>?> getUserData(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();
    return doc.data();
  }
}
