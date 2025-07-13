
import 'package:dio/dio.dart';
import 'package:EngKid/data/core/remote/api_response_object/api_response_object.dart';
import 'package:retrofit/http.dart';
part 'student_reading_api.g.dart';
@RestApi()
abstract class StudentReadingApi {
  factory StudentReadingApi(Dio dio, {String baseUrl}) = _StudentReadingApi;

  @POST('student-reading/report')
  Future<ApiResponseObject> getReadingHistory(@Body() Map<String, dynamic> body);
}
