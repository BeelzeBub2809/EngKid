import 'package:EngKid/domain/core/entities/lesson/entities/entities.dart';
import 'package:EngKid/domain/reading/reading_repository.dart';

class ReadingUsecases {
  final ReadingRepository _readingRepository;
  ReadingUsecases(this._readingRepository);

  Future<List<Reading>> getByCateAndStudent(Map<String, dynamic> body) async =>
      _readingRepository.getByCateAndStudent(body);
  Future<void> submitReadingResult(Map<String, dynamic> body) async =>
      _readingRepository.submitReadingResult(body);
  Future<List<dynamic>> getListReading(String keyword) async =>
      _readingRepository.getListReading(keyword);
  Future<dynamic> getLeaderboard(Map<String, dynamic> body) async =>
      _readingRepository.getLeaderboard(body);
}
