abstract class FeedbackRepository {
  Future<dynamic> sendFeedback({
    required int userId,
    int? readingId,
    int? rating,
    String? comment,
  });
}
