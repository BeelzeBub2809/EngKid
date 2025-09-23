import 'dart:convert';

import 'package:EngKid/data/core/remote/api/reading_api/reading_api.dart';
import 'package:EngKid/data/core/remote/api/student_reading_api/student_reading_api.dart';
import 'package:EngKid/data/core/remote/api_response_object/api_response_object.dart';
import 'package:EngKid/domain/core/entities/lesson/entities/entities.dart';
import 'package:EngKid/domain/reading/reading_repository.dart';
import 'package:EngKid/data/core/remote/api_response_object/api_response_object.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

class ReadingRepositoryImp implements ReadingRepository {
  final ReadingApi readingApi;
  final StudentReadingApi studentReadingApi;
  ReadingRepositoryImp(
      {required this.readingApi, required this.studentReadingApi});

  @override
  Future<List<Reading>> getByCateAndStudent(Map<String, dynamic> body) async {
    try {
      final ApiResponseObject response =
          await readingApi.getByCateAndStudent(body);
      final data = response.data;
      if (response.result && data != null && data['records'] != null) {
        final List<dynamic> records = data['records'];
        final s = records.map((e) => Reading.fromJson(e)).toList();
        return s;
      } else {
        return [];
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
      return [];
    }
  }

  @override
  Future<void> submitReadingResult(Map<String, dynamic> body) async {
    try {
      await studentReadingApi.submitReadingResult(body);
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
  Future<List<dynamic>> getListReading(String searchTerm) async {
    try {
      final ApiResponseObject response =
          await readingApi.getListReading(searchTerm);
      final data = response.data;
      if (response.result && data != null && data['records'] != null) {
        final List<dynamic> records = data['records'];
        return records;
      } else {
        return [];
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
      return [];
    }
  }

  @override
  Future<dynamic> getLeaderboard(Map<String, dynamic> body) async {
    try {
      final ApiResponseObject response =
          await studentReadingApi.getLeaderboard(body);
      final data = response.data;
      if (response.result && data != null) {
        return data;
      } else {
        return [];
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
      return [];
    }
  }

  @override
  Future<Map<String, dynamic>?> getReadingDetail(
      Map<String, dynamic> body) async {
    try {
      final readingId = body['readingId'];
      final ApiResponseObject response =
          await readingApi.getReadingDetail(readingId);
      final data = response.data;
      if (response.result && data != null) {
        return data as Map<String, dynamic>;
      } else {
        return null;
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
      return null;
    }
  }
}
