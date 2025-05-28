import 'package:EngKid/domain/core/entities/feedback/entities/categories/categories.dart';
import 'package:EngKid/domain/core/entities/feedback/entities/feedbacks/feedbacks.dart';

abstract class FeedbackRepository {
  Future<Categories> getCategories();
  Future<Feedbacks> getFeedbacks({
    int? gradeId,
    List<int>? categoryId,
    int? readingId,
    int? rating,
    String? orderBy,
  });
  Future<bool> createFeedback(Map<String, dynamic> data);

  Future<bool> likeFeedback(
    int feedbackId,
  );

  Future<bool> unLikeFeedback(
    int feedbackId,
  );

  Future<bool> replyFeedback(int feedbackId, Map<String, dynamic> data);

  Future<bool> deleteFeedback(
    int feedbackId,
  );
}
