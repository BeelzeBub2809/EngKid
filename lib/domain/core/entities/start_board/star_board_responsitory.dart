abstract class StarBoardRepository {
  Future<dynamic> getStarsHistory(
      int studentId, String startDate, String endDate);
}
