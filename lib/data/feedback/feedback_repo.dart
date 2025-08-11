import 'package:EngKid/data/core/remote/api/feedback_api/feedback_api.dart';
import 'package:EngKid/data/core/remote/api_response_object/api_response_object.dart';
import 'package:EngKid/domain/feedback/feedback_repository.dart';

class FeedbackRepositoryImp implements FeedbackRepository {
  final FeedbackApi feedbackApi;
  FeedbackRepositoryImp({required this.feedbackApi});

  @override
  Future<dynamic> sendFeedback({
    required int userId,
    int? readingId,
    int? rating,
    String? comment,
  }) async {
    try {
      final Map<String, dynamic> body = {
        "user_id": userId,
        if (readingId != null) "reading_id": readingId,
        if (rating != null) "rating": rating,
        if (comment != null && comment.isNotEmpty) "comment": comment,
      };

      final ApiResponseObject response = await feedbackApi.sendFeedback(body);

      if (response.result) {
        return response.data;
      } else {
        throw Exception('Failed to send feedback: ${response.message}');
      }
    } catch (error) {
      return Future.error(error);
    }
  }
}
