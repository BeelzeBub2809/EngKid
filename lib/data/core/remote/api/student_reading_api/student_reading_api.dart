import 'package:dio/dio.dart';
import 'package:EngKid/data/core/remote/api_response_object/api_response_object.dart';
import 'package:retrofit/http.dart';
part 'student_reading_api.g.dart';

@RestApi()
abstract class StudentReadingApi {
  factory StudentReadingApi(Dio dio, {String baseUrl}) = _StudentReadingApi;

  @POST('student-reading/report')
  Future<ApiResponseObject> getReadingHistory(
      @Body() Map<String, dynamic> body);

  @POST('student-reading/create')
  Future<ApiResponseObject> submitReadingResult(
      @Body() Map<String, dynamic> body);

  @GET('student-reading/leaderboard')
  Future<ApiResponseObject> getLeaderboard(
    @Body() Map<String, dynamic> body,
  );

  @GET(
      'student-stars/students/{kid_student_id}/learning-paths/{learning_path_id}/stars')
  Future<ApiResponseObject> getLearningPathStars(
    @Path('kid_student_id') int studentId,
    @Path('learning_path_id') int learningPathId,
  );
}
