import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/models/cycle_record.dart';
import '../../domain/models/symptom_log.dart';
import '../../domain/repositories/cycle_repository.dart';

class CycleRepositoryImpl implements CycleRepository {
  final FirebaseFirestore _firestore;

  CycleRepositoryImpl(this._firestore);

  @override
  Stream<CycleRecord?> getCycleRecord(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('cycle_data')
        .doc('current')
        .snapshots()
        .map((doc) => doc.exists ? CycleRecord.fromMap(doc.data()!) : null);
  }

  @override
  Future<void> updateCycleRecord(String userId, CycleRecord record) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('cycle_data')
        .doc('current')
        .set(record.toMap());
  }

  @override
  Stream<List<SymptomLog>> getSymptomLogs(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('symptom_logs')
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => SymptomLog.fromMap(doc.id, doc.data()))
            .toList());
  }

  @override
  Future<void> addSymptomLog(SymptomLog log) {
    return _firestore
        .collection('users')
        .doc(log.userId)
        .collection('symptom_logs')
        .add(log.toMap());
  }
}
