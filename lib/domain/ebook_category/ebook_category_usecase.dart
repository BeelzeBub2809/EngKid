

import 'package:EngKid/domain/ebook_category/ebook_category_repository.dart';
import 'package:EngKid/domain/ebook_category/entities/ebook_category.dart';

import 'entities/ebook_category.dart';

class EBookCategoryUsecases {
  final EbookCategoryRepository _ebookCategoryRepository;
  EBookCategoryUsecases(this._ebookCategoryRepository);

  Future<List<EBookCategory>> GetAllEBookCategory() async =>
      _ebookCategoryRepository.GetAllEBookCategory();
}