import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../data/repositories/pregnancy_repository_impl.dart';
import '../../domain/models/pregnancy_data.dart';
import '../../domain/repositories/pregnancy_repository.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

final pregnancyRepositoryProvider = Provider<PregnancyRepository>((ref) {
  return PregnancyRepositoryImpl(FirebaseFirestore.instance);
});

final pregnancyDataProvider = StreamProvider<PregnancyData?>((ref) {
  final user = ref.watch(authStateProvider).value;
  if (user == null) return Stream.value(null);
  return ref.watch(pregnancyRepositoryProvider).getPregnancyData(user.id);
});

class PregnancyNotifier extends StateNotifier<AsyncValue<void>> {
  final PregnancyRepository _repository;
  final String _userId;

  PregnancyNotifier(this._repository, this._userId) : super(const AsyncValue.data(null));

  Future<void> startPregnancy(DateTime lmp) async {
    state = const AsyncValue.loading();
    try {
      await _repository.registerPregnancy(_userId, lmp);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final pregnancyNotifierProvider = StateNotifierProvider<PregnancyNotifier, AsyncValue<void>>((ref) {
  final repo = ref.watch(pregnancyRepositoryProvider);
  final user = ref.watch(authStateProvider).value;
  return PregnancyNotifier(repo, user?.id ?? '');
});
