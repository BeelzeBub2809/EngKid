// ignore_for_file: non_constant_identifier_names

import 'package:dio/dio.dart';
import 'package:EngKid/data/core/remote/api_response_object/api_response_object.dart';
import 'package:retrofit/http.dart';

part 'ebook_api.g.dart';

@RestApi()
abstract class EBookApi {
  factory EBookApi(Dio dio, {String baseUrl}) = _EBookApi;

  @POST('e-book/student-M/{studentId}')
  Future<ApiResponseObject> getEBookByStudentIdM(
    @Path("studentId") int id,
  );
}
