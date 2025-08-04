import 'dart:io';
import 'package:EngKid/data/core/remote/api_response_array/api_response_array.dart';
import 'package:EngKid/domain/core/app_reponsitory.dart';
import 'package:EngKid/domain/core/entities/app_setting/entities/entities.dart';
import 'package:EngKid/domain/core/entities/entities.dart';
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
}
