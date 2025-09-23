import 'package:dio/dio.dart';
import 'package:EngKid/data/core/remote/api_response_object/api_response_object.dart';
import 'package:retrofit/http.dart';
part 'reading_api.g.dart';

@RestApi()
abstract class ReadingApi {
  factory ReadingApi(Dio dio, {String baseUrl}) = _ReadingApi;

  @POST('kid-reading/getByCateAndStudent')
  Future<ApiResponseObject> getByCateAndStudent(
      @Body() Map<String, dynamic> body);

  @GET('kid-reading/getListReading')
  Future<ApiResponseObject> getListReading(
    @Query("searchTerm") String searchTerm,
  );

  @GET('kid-reading/{readingId}')
  Future<ApiResponseObject> getReadingDetail(
    @Path("readingId") int readingId,
  );
}
