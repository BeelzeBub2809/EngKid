import 'dart:convert';

import 'package:EngKid/domain/ebook/ebook_usecases.dart';
import 'package:EngKid/domain/ebook/entities/ebook.dart';
import 'package:EngKid/domain/ebook_category/ebook_category_usecase.dart';
import 'package:EngKid/domain/ebook_category/entities/ebook_category.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:EngKid/data/core/local/share_preferences_manager.dart';
import 'package:EngKid/di/injection.dart';
import 'package:EngKid/domain/core/app_usecases.dart';
import 'package:EngKid/domain/topic/entities/entites.dart';
import 'package:EngKid/presentation/core/network_service.dart';
import 'package:EngKid/utils/lib_function.dart';

import '../../domain/core/entities/elibrary/elibrary.dart';
import 'user_service.dart';

class ElibraryService extends GetxService {
  final AppUseCases appUseCases;
  final EBookUsecases eBookUsecases;
  final EBookCategoryUsecases eBookCategoryUsecases;
  ElibraryService({required this.appUseCases, required this.eBookUsecases, required this.eBookCategoryUsecases});
  final UserService _userService = Get.find<UserService>();
  final _preferencesManager = getIt.get<SharedPreferencesManager>();
  final NetworkService _networkService = Get.find<NetworkService>();

  final RxList<EBookCategory> _categoryList = RxList<EBookCategory>.empty(growable: true);
  final RxInt _categoryIndex = 0.obs;
  final RxInt _bookIndex = 0.obs;
  final RxBool _isGetCategoryReadings = false.obs;
  final RxBool _isGetAllElibraryBooks = false.obs;
  final RxBool _isChangeBook = false.obs;
  final RxList<EBook> _bookList = RxList<EBook>.empty(growable: true);
  final RxList<EBook> _selectedCateBooks = RxList<EBook>.empty(growable: true);
  final RxInt _totalBook = 0.obs;
  final RxInt _completedBook = 0.obs;

  List<EBookCategory> get categoryList => _categoryList;
  int get categoryIndex => _categoryIndex.value;
  bool get isGetCategoryReadings => _isGetCategoryReadings.value;
  bool get isGetAllELibraryBooks => _isGetAllElibraryBooks.value;
  int get bookIndex => _bookIndex.value;
  List<EBook> get bookList => _bookList;
  List<EBook> get selectedCateBooks => _selectedCateBooks;
  final RxList<EBook> downloadAllReadingList = RxList<EBook>.empty(growable: true);
  bool get isChangeBook => _isChangeBook.value;
  int get totalBook => _totalBook.value;
  int get completedBook => _completedBook.value;
  @override
  void onInit() {
    super.onInit();
    debugPrint('Init Elibrary Service ');
  }

  set bookIndex(int value) {
    _bookIndex.value = value;
  }

  set completedBook(int value) {
    _completedBook.value = value;
  }

  set isChangeBook(bool value) {
    _isChangeBook.value = value;
  }

  Future<dynamic> getElibraryCategory() async {
    _isGetCategoryReadings.value = true;

    final categoriesData = await eBookCategoryUsecases.GetAllEBookCategory();

    _isGetCategoryReadings.value = false;
    // print(topic);
    //sample list of categories
    // final List<dynamic> categories = [
    //   {
    //     "id": 1,
    //     "name": "Science",
    //     "icon": "https://static.vecteezy.com/system/resources/previews/000/551/469/original/dynamic-atom-molecule-science-symbol-vector-icon.jpg",
    //     "thmb_img": "https://mir-s3-cdn-cf.behance.net/project_modules/fs/cc4c5131516629.565451f6bd878.png"
    //   },
    //   {
    //     "id": 2,
    //     "name": "Mathematics",
    //     "icon": "https://www.pngkit.com/png/full/137-1372107_calculator-icon-math-icon-png.png",
    //     "thmb_img": "https://cdn.dribbble.com/users/730703/screenshots/2457647/field.jpg"
    //   },
    //   {
    //     "id": 3,
    //     "name": "History",
    //     "icon": "https://icon-library.com/images/history-icon/history-icon-28.jpg",
    //     "thmb_img": "https://www.aiobot.com/wp-content/uploads/2021/11/Adidas-Yeezy-1050-Boot-AIO-Bot.jpg"
    //   }
    // ];
    _categoryList.clear();
    _categoryList.addAll(categoriesData);
  }

  Future<dynamic> getAllElibraryBooks() async {
    _isGetAllElibraryBooks.value = true;
    final book = await eBookUsecases.getByCategoryAndStudentM(_userService.currentUser.id);
    _isGetAllElibraryBooks.value = false;
    _bookList.addAll(book);
  }

  Future<void> getAllEbookWithCateAndStudentId(int categoryId) async {
    _isGetAllElibraryBooks.value = true;
    try {
      List<EBook> books = await eBookUsecases.getByCategoryAndStudentId(
          categoryId, _userService.currentUser.id);
      _selectedCateBooks.clear();
      _selectedCateBooks.addAll(books);
      prettyPrintJson(_selectedCateBooks, title: 'Updated _selectedCateBooks');
    } catch (e) {
      print('Error fetching ebooks for category $categoryId: $e');
      _selectedCateBooks.clear();
    } finally {
      _isGetAllElibraryBooks.value = false;
    }
  }


  Future<void> onChangeCategory(int index, int categoryId) async {
    if (!_networkService.networkConnection.value) {
      LibFunction.toast('require_network_to_topic');
      return;
    }

    try {

      _isGetCategoryReadings.value = true;
      _categoryIndex.value = index;
      _bookIndex.value = 0;

      await getAllEbookWithCateAndStudentId(categoryId);

      _totalBook.value = selectedCateBooks.length;
      _completedBook.value = selectedCateBooks.where((b) => b.isActive).length;

    } catch (e, stackTrace) {
      print('==================== ERROR CAUGHT ====================');
      print('Error Type: ${e.runtimeType}');
      print('Error Message: $e');
      print('Stack Trace: $stackTrace');
      print('======================================================');
      LibFunction.toast('Đã có lỗi xảy ra khi tải sách. Vui lòng thử lại.');
      selectedCateBooks.clear();
      _totalBook.value = 0;
      _completedBook.value = 0;

    } finally {
      _isGetCategoryReadings.value = false;
    }
  }

  Future<void> onChangeBook(int index) async {
    _isChangeBook.value = true;
    _bookIndex.value = index;
    await Future.delayed(const Duration(milliseconds: 1000), () {});
    _isChangeBook.value = false;
  }

  Future<void> saveBookToStorage() async {
    await _preferencesManager.putString(
      key:
          "${_userService.currentUser.id}_${bookList[bookIndex].id}_bookdatafile.json",
      value: jsonEncode(bookList[bookIndex].toJson()),
    );
  }

  Future<void> updateStatus(int studentId, int bookId, int status) async {
    // await appUseCases.updateElibraryStatus(
    //     _userService.currentUser.id, bookId, status);
  }
  void prettyPrintJson(dynamic data, {String title = 'DATA'}) {
    // Sử dụng JsonEncoder với indent (thụt lề) để tạo ra chuỗi JSON đẹp mắt
    const JsonEncoder encoder = JsonEncoder.withIndent('  '); // '  ' là 2 dấu cách
    final String prettyJson = encoder.convert(data);

    print('╔══════════════════════════════════════════════════════');
    print('║ ✅ $title');
    print('╟──────────────────────────────────────────────────────');
    prettyJson.split('\n').forEach((line) => print('║ $line'));
    print('╚══════════════════════════════════════════════════════');
  }
}
