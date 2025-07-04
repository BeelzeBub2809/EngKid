import 'dart:developer';

import 'package:EngKid/data/core/remote/api/auth_api/auth_api.dart';
import 'package:EngKid/data/core/remote/api/topic_api/topic_api.dart';
import 'package:EngKid/data/core/remote/api_response_object/api_response_object.dart';
import 'package:EngKid/domain/topic/entities/topic/topic.dart';
import 'package:EngKid/domain/topic/topic_reading_repository.dart';
import 'package:dio/dio.dart';

class TopicReadingRepositoryImp implements TopicReadingRepository {
  final TopicApi topicApi;
  TopicReadingRepositoryImp({required this.topicApi});

  @override
  Future<List<Topic>> getAll(Map<String, dynamic> body) async {
    try {

      final ApiResponseObject response = await topicApi.getAll(body);

      final data = response.data;

      if (response.result && data != null && data['records'] != null) {
        final List<dynamic> records = data['records'];
        final topics = records.map((e) => Topic.fromJson(e)).toList();
        return topics;
      } else {
        return [];
      }
    } catch (e, stackTrace) {
      if (e is DioException) {
        print('[TopicRepository] DioException occurred:');
        print('  → Type: ${e.type}');
        print('  → Message: ${e.message}');
        print('  → Response: ${e.response?.data}');
        print('  → StatusCode: ${e.response?.statusCode}');
        print('  → StackTrace: $stackTrace');
      } else {
        print('[TopicRepository] Unknown exception: $e');
        print('[TopicRepository] StackTrace: $stackTrace');
      }
      return [];
    }
  }

  @override
  Future<List<Topic>> getByGrade(int gradeId) async {
    try {

      final ApiResponseObject response = await topicApi.getByGrade(gradeId);

      final data = response.data;

      if (response.result && data != null) {
        final List<dynamic> records = data;
        final topics = records.map((e) => Topic.fromJson(e)).toList();
        return topics;
      } else {
        return [];
      }
    } catch (e, stackTrace) {
      if (e is DioException) {
        print('[TopicRepository] DioException occurred:');
        print('  → Type: ${e.type}');
        print('  → Message: ${e.message}');
        print('  → Response: ${e.response?.data}');
        print('  → StatusCode: ${e.response?.statusCode}');
        print('  → StackTrace: $stackTrace');
      } else {
        print('[TopicRepository] Unknown exception: $e');
        print('[TopicRepository] StackTrace: $stackTrace');
      }
      return [];
    }
  }
}