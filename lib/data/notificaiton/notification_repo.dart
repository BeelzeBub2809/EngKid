import 'package:EngKid/data/core/remote/api/notification_api/notification_api.dart';
import 'package:EngKid/data/core/remote/api_response_object/api_response_object.dart';
import 'package:EngKid/domain/notificaiton/notification_repositories.dart';

class NotificationRepositoryImp implements NotificationRepository {
  final NotificationApi notificationApi;
  NotificationRepositoryImp({required this.notificationApi});

  @override
  Future<dynamic> getNotification({
    required int studentId,
    String searchTerm = "",
    int pageNumb = 1,
    int pageSize = 10,
  }) async {
    try {
      final Map<String, dynamic> body = {
        "student_id": studentId,
        "search_term": searchTerm,
        "page_numb": pageNumb,
        "page_size": pageSize,
      };
      final ApiResponseObject response =
          await notificationApi.getNotificationsByParent(body);
      if (response.result) {
        return response.data;
      } else {
        throw Exception('Failed to load notifications');
      }
    } catch (error) {
      return Future.error(error);
    }
  }
}
