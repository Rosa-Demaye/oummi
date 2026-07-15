import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../data/repositories/cycle_repository_impl.dart';
import '../../domain/models/cycle_record.dart';
import '../../domain/models/symptom_log.dart';
import '../../domain/repositories/cycle_repository.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

final cycleRepositoryProvider = Provider<CycleRepository>((ref) {
  final firestore = FirebaseFirestore.instance;
  return CycleRepositoryImpl(firestore);
});

final cycleRecordProvider = StreamProvider<CycleRecord?>((ref) {
  final user = ref.watch(authStateProvider).value;
  if (user == null) return Stream.value(null);
  
  return ref.watch(cycleRepositoryProvider).getCycleRecord(user.id);
});

final symptomLogsProvider = StreamProvider<List<SymptomLog>>((ref) {
  final user = ref.watch(authStateProvider).value;
  if (user == null) return Stream.value([]);
  
  return ref.watch(cycleRepositoryProvider).getSymptomLogs(user.id);
});

class CycleNotifier extends StateNotifier<AsyncValue<void>> {
  final CycleRepository _repository;
  final String _userId;

  CycleNotifier(this._repository, this._userId) : super(const AsyncValue.data(null));

  Future<void> logSymptoms(SymptomLog log) async {
    state = const AsyncValue.loading();
    try {
      await _repository.addSymptomLog(log);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> updateCycle(CycleRecord record) async {
    state = const AsyncValue.loading();
    try {
      await _repository.updateCycleRecord(_userId, record);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final cycleNotifierProvider = StateNotifierProvider<CycleNotifier, AsyncValue<void>>((ref) {
  final repository = ref.watch(cycleRepositoryProvider);
  final user = ref.watch(authStateProvider).value;
  return CycleNotifier(repository, user?.id ?? '');
});
