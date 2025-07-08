// ignore_for_file: non_constant_identifier_names


import 'package:EngKid/data/core/remote/api/ebook_category_api/ebook_category_api.dart';
import 'package:EngKid/data/core/remote/api_response_object/api_response_object.dart';
import 'package:EngKid/domain/ebook_category/ebook_category_repository.dart';
import 'package:EngKid/domain/ebook_category/entities/ebook_category.dart';

class EbookCategoryRepoImp implements EbookCategoryRepository {
  final EBookCategoryApi eBookCateApi;
  EbookCategoryRepoImp({required this.eBookCateApi});

  @override
  Future<List<EBookCategory>> GetAllEBookCategory() async {
    final ApiResponseObject response = await eBookCateApi.GetAllEBookCategory();

    final List<dynamic> data = response.data;

    if (data != null) {
      print(data);
      final List<EBookCategory> categories = data.map((e) => EBookCategory.fromJson(e)).toList() as List<EBookCategory>;
      print(categories);
      return categories;
    } else {
      return [];
    }
  }
}
