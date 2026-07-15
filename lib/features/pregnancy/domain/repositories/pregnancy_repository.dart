import '../models/pregnancy_data.dart';

abstract class PregnancyRepository {
  Stream<PregnancyData?> getPregnancyData(String userId);
  Future<void> updatePregnancyData(String userId, PregnancyData data);
  Future<void> registerPregnancy(String userId, DateTime lastPeriodDate);
}
