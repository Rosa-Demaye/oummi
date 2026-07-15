import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../data/datasources/auth_remote_datasource.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/entities/user_entity.dart';

// Check if Firebase is available
bool get _isFirebaseInitialized {
  try {
    FirebaseAuth.instance;
    return true;
  } catch (_) {
    return false;
  }
}

final firebaseAuthProvider = Provider<FirebaseAuth?>((ref) {
  if (!_isFirebaseInitialized) return null;
  return FirebaseAuth.instance;
});

final firestoreProvider = Provider<FirebaseFirestore?>((ref) {
  if (!_isFirebaseInitialized) return null;
  return FirebaseFirestore.instance;
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final auth = ref.watch(firebaseAuthProvider);
  final db = ref.watch(firestoreProvider);

  if (auth != null && db != null) {
    return AuthRepositoryImpl(
      AuthRemoteDataSourceImpl(auth, db),
      auth,
    );
  }

  return MockAuthRepository();
});

final authStateProvider = StreamProvider<UserEntity?>((ref) {
  return ref.watch(authRepositoryProvider).authStateChanges;
});

class AuthNotifier extends StateNotifier<AsyncValue<UserEntity?>> {
  final AuthRepository _repository;

  AuthNotifier(this._repository) : super(const AsyncValue.data(null));

  Future<void> signIn(String email, String password) async {
    state = const AsyncValue.loading();
    try {
      final user = await _repository.signInWithEmailAndPassword(email, password);
      state = AsyncValue.data(user);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> signUp({
    required String email,
    required String password,
    required String fullName,
    required UserRole role,
    String? phoneNumber,
    String? location,
    String? quartier,
    String? partnerPhoneNumber,
    DoctorSpecialty specialty = DoctorSpecialty.none,
  }) async {
    // Force reset state to data(null) before starting to clear previous errors
    state = const AsyncValue.data(null);
    await Future.delayed(const Duration(milliseconds: 100)); // Small delay for UI reactivity
    
    state = const AsyncValue.loading();
    try {
      final user = await _repository.signUpWithEmailAndPassword(
        email: email.trim(), // Ensure no spaces
        password: password,
        fullName: fullName,
        role: role,
        phoneNumber: phoneNumber,
        location: location,
        quartier: quartier,
        partnerPhoneNumber: partnerPhoneNumber,
        specialty: specialty,
      );
      state = AsyncValue.data(user);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> signInWithGoogle() async {
    state = const AsyncValue.loading();
    try {
      final user = await _repository.signInWithGoogle();
      state = AsyncValue.data(user);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> signOut() async {
    await _repository.signOut();
    state = const AsyncValue.data(null);
  }
}

final authNotifierProvider = StateNotifierProvider<AuthNotifier, AsyncValue<UserEntity?>>((ref) {
  return AuthNotifier(ref.watch(authRepositoryProvider));
});

class MockAuthRepository implements AuthRepository {
  UserEntity? _currentUser;
  
  @override
  Stream<UserEntity?> get authStateChanges => Stream.value(_currentUser);

  @override
  Future<UserEntity?> getCurrentUser() async => _currentUser;

  @override
  Future<void> signOut() async {
    _currentUser = null;
  }

  @override
  Future<UserEntity> signInWithEmailAndPassword(String email, String password) async {
    _currentUser = UserEntity(
      id: 'mock_id',
      email: email,
      fullName: 'Amina Mahamat (Preview)',
      role: UserRole.pregnant,
      createdAt: DateTime.now(),
    );
    return _currentUser!;
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
  }) async {
    _currentUser = UserEntity(
      id: 'mock_id',
      email: email,
      fullName: fullName,
      role: role,
      phoneNumber: phoneNumber,
      location: location,
      quartier: quartier,
      partnerPhoneNumber: partnerPhoneNumber,
      accessCode: 'OUMI-MOCK',
      specialty: specialty,
      createdAt: DateTime.now(),
    );
    return _currentUser!;
  }

  @override
  Future<UserEntity> signInWithGoogle() async {
    return signInWithEmailAndPassword('google@example.com', '');
  }
}
