// ignore_for_file: non_constant_identifier_names

import 'package:EngKid/data/core/remote/api/ebook_api/ebook_api.dart';
import 'package:EngKid/data/core/remote/api_response_object/api_response_object.dart';
import 'package:EngKid/domain/ebook/ebook_repository.dart';
import 'package:EngKid/domain/ebook/entities/ebook.dart';
import 'package:dio/dio.dart';

import '../../utils/lib_function.dart';

class EbookRepoImp implements EbookRepoitory {
  final EBookApi eBookApi;
  EbookRepoImp({required this.eBookApi});

  @override
  Future<List<EBook>> getByCategoryAndStudentM(int kidUserId) async {
    final ApiResponseObject response = await eBookApi.getEBookByStudentIdM(kidUserId);

    final List<dynamic> data = response.data;

    if (data != null) {
      final List<EBook> books = data.map((e) => EBook.fromJson(e)).toList() as List<EBook>;
      return books;
    } else {
      return [];
    }
  }

  @override
  Future<List<EBook>> getByCategoryAndStudentId(int categoryId, int kidId) async {
    try {
      final ApiResponseObject response = await eBookApi.getEBookByStudentIdAndCategoryId(categoryId, kidId);
      final data = response.data;
      if (response.result && data != null && data['records'] != null) {
        final List<dynamic> records = data['records'];
        final s = records.map((e) => EBook.fromJson(e)).toList();
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
}
