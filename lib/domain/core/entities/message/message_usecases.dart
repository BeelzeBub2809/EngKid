import 'package:EzLish/domain/core/entities/feedback/entities/categories/categories.dart';
import 'package:EzLish/domain/core/entities/message/entities/message/message.dart';

import 'message_responsitory.dart';

class MessageUseCases {
  final MessageRepository _feedbackRepository;
  MessageUseCases(this._feedbackRepository);

  Future<Categories> getCategories() => _feedbackRepository.getCategories();
  Future<Message> getMessages({
    int? gradeId,
    int? categoryId,
    int? readingId,
    int? rating,
    String? orderBy,
  }) =>
      _feedbackRepository.getMessages(
        gradeId: gradeId,
        categoryId: categoryId,
        readingId: readingId,
        rating: rating,
      );

  Future<bool> createMessage(Map<String, dynamic> data) =>
      _feedbackRepository.createMessage(data);

  Future<bool> likeMessage(int feedbackId) =>
      _feedbackRepository.likeMessage(feedbackId);

  Future<bool> replyMessage(int feedbackId, Map<String, dynamic> data) =>
      _feedbackRepository.replyMessage(feedbackId, data);

  Future<bool> deleteMessage(int feedbackId) =>
      _feedbackRepository.deleteMessage(feedbackId);
}
