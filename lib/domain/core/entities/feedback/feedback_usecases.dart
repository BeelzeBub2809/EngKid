import 'package:EngKid/domain/core/entities/feedback/entities/categories/categories.dart';
import 'package:EngKid/domain/core/entities/feedback/entities/feedbacks/feedbacks.dart';

import 'feedback_responsitory.dart';

class FeedbackUseCases {
  final FeedbackRepository _feedbackRepository;
  FeedbackUseCases(this._feedbackRepository);

  Future<Categories> getCategories() => _feedbackRepository.getCategories();
  Future<Feedbacks> getFeedbacks({
    int? gradeId,
    List<int>? categoryId,
    int? readingId,
    int? rating,
    String? orderBy,
  }) =>
      _feedbackRepository.getFeedbacks(
        gradeId: gradeId,
        categoryId: categoryId,
        readingId: readingId,
        rating: rating,
      );

  Future<bool> createFeedback(Map<String, dynamic> data) =>
      _feedbackRepository.createFeedback(data);

  Future<bool> likeFeedback(int feedbackId) =>
      _feedbackRepository.likeFeedback(feedbackId);

  Future<bool> unLikeFeedback(int feedbackId) =>
      _feedbackRepository.unLikeFeedback(feedbackId);

  Future<bool> replyFeedback(int feedbackId, Map<String, dynamic> data) =>
      _feedbackRepository.replyFeedback(feedbackId, data);

  Future<bool> deleteFeedback(int feedbackId) =>
      _feedbackRepository.deleteFeedback(feedbackId);
}
