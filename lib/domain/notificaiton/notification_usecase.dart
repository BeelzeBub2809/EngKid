import 'package:EngKid/domain/notificaiton/notification_repositories.dart';

class NotificationUsecases {
  final NotificationRepository _notificationRepository;
  NotificationUsecases(this._notificationRepository);

  Future<dynamic> getNotification({
    required int studentId,
    String searchTerm = "",
    int pageNumb = 1,
    int pageSize = 10,
  }) async =>
      _notificationRepository.getNotification(
        studentId: studentId,
        searchTerm: searchTerm,
        pageNumb: pageNumb,
        pageSize: pageSize,
      );
}
