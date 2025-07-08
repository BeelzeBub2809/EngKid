
import 'package:EngKid/domain/ebook/entities/ebook.dart';

abstract class EbookRepoitory {
  Future<List<EBook>> getByCategoryAndStudentM(int kidUserId);
}
