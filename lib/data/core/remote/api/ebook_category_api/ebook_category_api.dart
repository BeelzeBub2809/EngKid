// ignore_for_file: non_constant_identifier_names

import 'package:dio/dio.dart';
import 'package:EngKid/data/core/remote/api_response_object/api_response_object.dart';
import 'package:retrofit/http.dart';
part 'ebook_category_api.g.dart';

@RestApi()
abstract class EBookCategoryApi {
  factory EBookCategoryApi(Dio dio, {String baseUrl}) = _EBookCategoryApi;

  @GET('e-book-category/all-M')
  Future<ApiResponseObject> GetAllEBookCategory();
}
