import 'dart:io';
import 'package:EngKid/data/core/remote/api_response_array/api_response_array.dart';
import 'package:EngKid/domain/core/app_reponsitory.dart';
import 'package:EngKid/domain/core/entities/app_setting/entities/entities.dart';
import 'package:EngKid/domain/core/entities/entities.dart';
import 'package:EngKid/domain/core/entities/advice/advice_response.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'api/user_api/user_api.dart';
import 'api_response_object/api_response_object.dart';

class AppRepositoryImp extends AppRepository {
  final UserApi userApi;

  AppRepositoryImp({
    required this.userApi,
  });

  @override
  Future<UserInfo> getUserInfo(int id) async {
    try {
      final ApiResponseObject response = await userApi.getUserInfo(id);
      if (response.result) {
        return UserInfo.fromJson(response.data);
      } else {
        throw '';
      }
    } catch (error) {
      return Future.error(error);
    }
  }

  @override
  Future<ChildProfiles> getChildProfiles(int parentUserId) async {
    try {
      final ApiResponseObject response =
      await userApi.getChildProfiles(parentUserId);
      if (response.result) {
        return ChildProfiles.fromJson(response.data);
      } else {
        throw '';
      }
    } catch (error) {
      return Future.error(error);
    }
  }

  @override
  Future<dynamic> updateParentProfile(int id, FormData formData) async {
    try {
      final ApiResponseObject response = await userApi.updateParentProfile(
          id, formData);
      if (response.result) {
        return response.data;
      } else {
        throw response.message;
      }
    } catch (e, stackTrace) {
      if (e is DioException) {
        print('[Repository] DioException occurred:');
        print('  → Type: ${e.type}');
        print('  → Message: ${e.message}');
        print('  → Response: ${e.response?.data}');
        print('  → StatusCode: ${e.response?.statusCode}');
        print('  → StackTrace: $stackTrace');
      } else {
        print('[Repository] Unknown exception: $e');
        print('[Repository] StackTrace: $stackTrace');
      }
    }
  }

  @override
  Future<AdviceResponse> getAdviceFromAI(String endpoint) async {
    try {
      final ApiResponseObject response = await userApi.getAdviceFromAI(endpoint);

      print('🔍 [DEBUG] ApiResponseObject result: ${response.result}');
      print('🔍 [DEBUG] ApiResponseObject message: ${response.message}');
      print('🔍 [DEBUG] ApiResponseObject code: ${response.code}');

      if (response.result && response.data != null) {
        final Map<String, dynamic> dataMap = response.data as Map<String, dynamic>;
        print('🔍 [DEBUG] Parsing AdviceData from raw response...');
        final adviceData = AdviceData.fromJson(dataMap);
        print('🔍 [DEBUG] ✅ Successfully parsed AdviceData');
        final adviceResponse = AdviceResponse(
          success: response.result,
          message: response.message ?? 'Success',
          status: response.code ?? 200,
          errors: null,
          data: adviceData,
        );
        return adviceResponse;

      } else {
        print('🔍 [DEBUG] ❌ API returned error - result: ${response.result}, data: ${response.data}');
        throw Exception('API returned error: ${response.message}');
      }
    } catch (error, stackTrace) {
      print('🔍 [DEBUG] ❌ Error in getAdviceFromAI: $error');
      print('🔍 [DEBUG] Error type: ${error.runtimeType}');
      print('🔍 [DEBUG] StackTrace: $stackTrace');
      return Future.error(error);
    }
  }
}
