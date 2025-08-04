abstract class NotificationRepository {
  Future<dynamic> getNotification(
      {required int studentId,
      String searchTerm = "",
      int pageNumb = 1,
      int pageSize = 10});
}
