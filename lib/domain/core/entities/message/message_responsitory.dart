import 'package:EzLish/domain/core/entities/feedback/entities/categories/categories.dart';
import 'package:EzLish/domain/core/entities/message/entities/message/message.dart';

abstract class MessageRepository {
  Future<Categories> getCategories();
  Future<Message> getMessages({
    int? gradeId,
    int? categoryId,
    int? readingId,
    int? rating,
    String? orderBy,
  });
  Future<bool> createMessage(Map<String, dynamic> data);

  Future<bool> likeMessage(
    int feedbackId,
  );

  Future<bool> replyMessage(int feedbackId, Map<String, dynamic> data);

  Future<bool> deleteMessage(
    int feedbackId,
  );
}
