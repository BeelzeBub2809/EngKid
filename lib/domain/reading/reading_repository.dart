import 'package:EngKid/domain/core/entities/lesson/entities/entities.dart';

abstract class ReadingRepository {
  Future<List<Reading>> getByCateAndStudent(Map<String, dynamic> body);
  Future<void> submitReadingResult(Map<String, dynamic> body);
}