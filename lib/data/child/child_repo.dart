import 'dart:developer';

import 'package:EngKid/data/core/remote/api/auth_api/auth_api.dart';
import 'package:EngKid/data/core/remote/api/child_api/child_api.dart';
import 'package:EngKid/data/core/remote/api_response_object/api_response_object.dart';
import 'package:EngKid/domain/core/entities/child_profile/child_profiles.dart';
import 'package:EngKid/domain/core/entities/child_profile/child_repository.dart';
import 'package:dio/dio.dart';

class ChildRepositoryImp implements ChildRepository {
  final ChildApi childApi;
  ChildRepositoryImp({required this.childApi});

  @override
  Future<ChildProfiles> getAllKid(int kidParentId) async {
    try {

      final ApiResponseObject response = await childApi.getAllKid(kidParentId);

      final data = response.data;
      print("------------------------------");
      print(data);
      print(response.result);
      if (response.result && data != null) {
        final childProfiles = ChildProfiles.fromJson(data);
        return childProfiles;
      } else {
        return new ChildProfiles();
      }
    } catch (e, stackTrace) {
      if (e is DioException) {
        print('[ChildRepository] DioException occurred:');
        print('  → Type: ${e.type}');
        print('  → Message: ${e.message}');
        print('  → Response: ${e.response?.data}');
        print('  → StatusCode: ${e.response?.statusCode}');
        print('  → StackTrace: $stackTrace');
      } else {
        print('[ChildRepository] Unknown exception: $e');
        print('[ChildRepository] StackTrace: $stackTrace');
      }
      return new ChildProfiles();
    }
  }

  @override
  Future<dynamic> createChild(Map<String, dynamic> body) async {
    try {
      final ApiResponseObject response = await childApi.createChild(body);
      if (response.result) {
        return response.data;
      } else {
        throw response.message;
      }
    } catch (error) {
      log('Error creating child: $error');
      return Future.error(error);
    }
  }
}