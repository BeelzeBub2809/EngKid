import 'dart:async';
import 'package:EngKid/data/core/remote/api/child_api/child_api.dart';
import 'package:EngKid/data/core/remote/api/ebook_category_api/ebook_category_api.dart';
import 'package:EngKid/data/core/remote/api/question_api/question_api.dart';
import 'package:EngKid/data/core/remote/api/reading_api/reading_api.dart';
import 'package:EngKid/data/core/remote/api/student_reading_api/student_reading_api.dart';
import 'package:EngKid/data/core/remote/api/topic_api/topic_api.dart';
import 'package:EngKid/data/core/remote/api/ebook_api/ebook_api.dart';
import 'package:EngKid/domain/ebook_category/entities/ebook_category.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:EngKid/data/core/local/share_preferences_manager.dart';
import 'package:EngKid/data/core/remote/api/auth_api/auth_api.dart';
import 'package:EngKid/data/core/remote/api/user_api/user_api.dart';
import 'package:EngKid/utils/key_shared_preferences.dart';
import 'package:EngKid/utils/lib_function.dart';
import '../injection.dart';

class ApiModule {
  Future<void> provides(String baseUrl) async {
    // The getIt instance is used to register dependencies in the service locator pattern.
    final dio = await setup(baseUrl);
    // The registerSingleton<T>(instance) method from getIt is used here to register a single, shared instance of each dependency (Dio, UserApi, AuthApi).
    // This ensures that throughout the app, the same instance is reused wherever T is requested from getIt, supporting efficient resource use and consistent state.
    // If you need to update or replace a dependency, be sure to unregister the old singleton first to avoid conflicts.
    getIt.registerSingleton(dio);

    // register api
    getIt.registerSingleton(UserApi(dio, baseUrl: dio.options.baseUrl));
    getIt.registerSingleton(AuthApi(dio, baseUrl: dio.options.baseUrl));
    getIt.registerSingleton(TopicApi(dio, baseUrl: dio.options.baseUrl));
    getIt.registerSingleton(EBookApi(dio, baseUrl: dio.options.baseUrl));
    getIt.registerSingleton(EBookCategoryApi(dio, baseUrl: dio.options.baseUrl));
    getIt.registerSingleton(ChildApi(dio, baseUrl: dio.options.baseUrl));
    getIt.registerSingleton(ReadingApi(dio, baseUrl: dio.options.baseUrl));
    getIt.registerSingleton(QuestionApi(dio, baseUrl: dio.options.baseUrl));
    getIt.registerSingleton(StudentReadingApi(dio, baseUrl: dio.options.baseUrl));
  }

  static FutureOr<Dio> setup(String baseUrl) async {
    final preferencesManager = getIt.get<SharedPreferencesManager>();
    final options = BaseOptions(
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      baseUrl: baseUrl,
    );
    final Dio dio = Dio(options);

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          options.headers['Content-Type'] = 'application/json';

          final String? storageToken = preferencesManager.getString(KeySharedPreferences.token);

          if (storageToken != null && storageToken.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $storageToken';
          }

          // ignore: prefer_interpolation_to_compose_strings
          debugPrint(
            '${options.method} --- ${options.baseUrl} --- ${options.path} --- data: ${options.data.toString()} --- header: ${options.headers.toString()} --- query: ${options.queryParameters.toString()}',
          );

          return handler.next(options);
        },
        onResponse: (response, handler) async {
          if (response.statusCode == 200 ||
              response.statusCode == 204 ||
              response.statusCode == 201) {
            return handler.next(response);
          } else {
            throw 'data not found';
          }
        },
        onError: (e, handler) {
          debugPrint(
              'Api Error: ${e.error} -- response: ${e.response!.data!} -- type: ${e.type} -- path: ${e.requestOptions.path}');
          switch (e.type) {
            case DioExceptionType.connectionTimeout:
            case DioExceptionType.receiveTimeout:
              LibFunction.toast('unstable_network_connection');
              break;
            case DioExceptionType.badResponse:
              if (e.requestOptions.path != "reading/star-settings" ||
                  e.requestOptions.path != "settings-automatic-notification") {
                if (e.response!.data["message"] == "Unauthenticated") {
                  LibFunction.toast('sesion_expired');
                } else if (e.response!.data["message"] == "User not found") {
                  LibFunction.toast('invalid_account');
                } else {
                  LibFunction.toast('connection_failed');
                }
              }
              break;
            default:
              break;
          }
          handler.reject(e);
        },
      ),
    );
    return dio;
  }
}
