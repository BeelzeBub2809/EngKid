
import 'package:EngKid/domain/ebook/entities/ebook.dart';

abstract class EbookRepoitory {
  Future<List<EBook>> getByCategoryAndStudentM(int kidUserId);
  Future<List<EBook>> getByCategoryAndStudentId(int categoryId, int kidId);
}
