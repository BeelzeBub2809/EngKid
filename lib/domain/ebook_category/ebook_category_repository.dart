import 'package:EngKid/domain/ebook_category/entities/ebook_category.dart';

abstract class EbookCategoryRepository {
  Future<List<EBookCategory>> GetAllEBookCategory();
}
