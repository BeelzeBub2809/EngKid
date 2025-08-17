

import 'package:EngKid/domain/ebook/ebook_repository.dart';

import 'entities/ebook.dart';

class EBookUsecases {
  final EbookRepoitory _ebookRepo;
  EBookUsecases(this._ebookRepo);

  Future<List<EBook>> getByCategoryAndStudentM(int kidUserId) async =>
    _ebookRepo.getByCategoryAndStudentM(kidUserId);
  Future<List<EBook>> getByCategoryAndStudentId(int categoryId, int kidId) async =>
      _ebookRepo.getByCategoryAndStudentId(categoryId, kidId);
}