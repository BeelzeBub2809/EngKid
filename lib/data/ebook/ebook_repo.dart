// ignore_for_file: non_constant_identifier_names

import 'package:EngKid/data/core/remote/api/ebook_api/ebook_api.dart';
import 'package:EngKid/data/core/remote/api_response_object/api_response_object.dart';
import 'package:EngKid/domain/ebook/ebook_repository.dart';
import 'package:EngKid/domain/ebook/entities/ebook.dart';

import '../../utils/lib_function.dart';

class EbookRepoImp implements EbookRepoitory {
  final EBookApi eBookApi;
  EbookRepoImp({required this.eBookApi});

  @override
  Future<List<EBook>> getByCategoryAndStudentM(int kidUserId) async {
    final ApiResponseObject response = await eBookApi.getEBookByStudentIdM(kidUserId);

    final List<dynamic> data = response.data;

    if (data != null) {
      final List<EBook> books = data.map((e) => EBook.fromJson(e)).toList() as List<EBook>;
      return books;
    } else {
      return [];
    }
  }
}
