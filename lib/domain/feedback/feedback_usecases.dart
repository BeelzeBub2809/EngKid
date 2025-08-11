import 'package:EngKid/domain/feedback/feedback_repository.dart';

class FeedbackUsecases {
  final FeedbackRepository _feedbackRepository;
  FeedbackUsecases(this._feedbackRepository);

  Future<dynamic> sendFeedback({
    required int userId,
    int? readingId,
    int? rating,
    String? comment,
  }) async =>
      _feedbackRepository.sendFeedback(
        userId: userId,
        readingId: readingId,
        rating: rating,
        comment: comment,
      );
}
