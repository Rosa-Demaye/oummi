import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/models/pregnancy_data.dart';
import '../../domain/repositories/pregnancy_repository.dart';

class PregnancyRepositoryImpl implements PregnancyRepository {
  final FirebaseFirestore _firestore;

  PregnancyRepositoryImpl(this._firestore);

  @override
  Stream<PregnancyData?> getPregnancyData(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('health_data')
        .doc('pregnancy')
        .snapshots()
        .map((doc) => doc.exists ? PregnancyData.fromMap(doc.data()!) : null);
  }

  @override
  Future<void> updatePregnancyData(String userId, PregnancyData data) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('health_data')
        .doc('pregnancy')
        .set(data.toMap());
  }

  @override
  Future<void> registerPregnancy(String userId, DateTime lastPeriodDate) {
    // Calculate due date (approx 280 days from LMP)
    final dueDate = lastPeriodDate.add(const Duration(days: 280));
    final data = PregnancyData(
      startDate: lastPeriodDate,
      dueDate: dueDate,
      currentWeek: (DateTime.now().difference(lastPeriodDate).inDays / 7).floor().clamp(1, 42),
    );
    
    return updatePregnancyData(userId, data);
  }
}
