import '../models/cycle_record.dart';
import '../models/symptom_log.dart';

abstract class CycleRepository {
  Stream<CycleRecord?> getCycleRecord(String userId);
  Future<void> updateCycleRecord(String userId, CycleRecord record);
  
  Stream<List<SymptomLog>> getSymptomLogs(String userId);
  Future<void> addSymptomLog(SymptomLog log);
}
