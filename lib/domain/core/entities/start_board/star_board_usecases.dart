import 'star_board_responsitory.dart';

class StarBoardUseCases {
  final StarBoardRepository _starBoardRepository;
  StarBoardUseCases(this._starBoardRepository);

  Future<dynamic> getStarsHistory(
          {required int studentId,
          required String startDate,
          required String endDate}) =>
      _starBoardRepository.getStarsHistory(studentId, startDate, endDate);
}
