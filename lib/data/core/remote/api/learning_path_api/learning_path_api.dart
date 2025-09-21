import 'package:dio/dio.dart';
import 'package:EngKid/data/core/remote/api_response_object/api_response_object.dart';
import 'package:retrofit/http.dart';

part 'learning_path_api.g.dart';

@RestApi()
abstract class LearningPathApi {
  factory LearningPathApi(Dio dio, {String baseUrl}) = _LearningPathApi;

  @GET('/learning-path/mobile/{pathId}/categories')
  Future<ApiResponseObject> getLearningPathCategories(
    @Path("pathId") int pathId,
  );

  @GET(
      '/learning-path/mobile/{pathId}/categories/{categoryId}/{studentId}/items')
  Future<ApiResponseObject> getLearningPathItems(
    @Path("pathId") int pathId,
    @Path("categoryId") int categoryId,
    @Path("studentId") int studentId,
  );
}
