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
    final book = await eBookUsecases.getByCategoryAndStudentM(1);
    _isGetAllElibraryBooks.value = true;
    // final data =
    //     {
    //       "books": [
    //         {
    //           "id": 1,
    //           "name": "Science Book 1",
    //           "categories": "Category A",
    //           "thum_img": "https://images-na.ssl-images-amazon.com/images/I/91Qu7aSa0aL.jpg",
    //           "background": "https://example.com/science_background.jpg",
    //           "reading_video": "https://example.com/science_video.mp4",
    //           "status": true
    //         },
    //         {
    //           "id": 2,
    //           "name": "Science Book 2",
    //           "categories": "Category B",
    //           "thum_img": "https://lifeatthezoo.com/wp/wp-content/uploads/2015/12/science-activities-books-for-kids.jpg",
    //           "background": "https://example.com/science_background2.jpg",
    //           "reading_video": "https://example.com/science_video2.mp4",
    //           "status": true
    //         },
    //         {
    //           "id": 3,
    //           "name": "Math Book 1",
    //           "categories": "Category C",
    //           "thum_img": "https://media.karousell.com/media/photos/products/2025/6/9/grade_9_mathematics_textbook_1749446506_2d158f5d.jpg",
    //           "background": "https://example.com/math_background.jpg",
    //           "reading_video": "https://example.com/math_video.mp4",
    //           "status": true
    //         }
    //       ]
    //     };
    _isGetAllElibraryBooks.value = false;
    _bookList.addAll(book);
  }

  Future<dynamic> onChangeCategory(int index, int categoryId) async {
    if (_networkService.networkConnection.value) {
      _isGetCategoryReadings.value = true;
      selectedCateBooks.clear();
      _categoryIndex.value = index;
      //call api get list of books in category
      // final data = {
      //   "books": [
      //     {
      //       "id": 1,
      //       "name": "Science Book 1",
      //       "categories": "Category A",
      //       "thum_img": "https://images-na.ssl-images-amazon.com/images/I/91Qu7aSa0aL.jpg",
      //       "background": "https://example.com/science_background.jpg",
      //       "reading_video": "https://example.com/science_video.mp4",
      //       "status": true
      //     },
      //     {
      //       "id": 2,
      //       "name": "Science Book 2",
      //       "categories": "Category B",
      //       "thum_img": "https://lifeatthezoo.com/wp/wp-content/uploads/2015/12/science-activities-books-for-kids.jpg",
      //       "background": "https://example.com/science_background2.jpg",
      //       "reading_video": "https://example.com/science_video2.mp4",
      //       "status": true
      //     },
      //     {
      //       "id": 3,
      //       "name": "Math Book 1",
      //       "categories": "Category C",
      //       "thum_img": "https://media.karousell.com/media/photos/products/2025/6/9/grade_9_mathematics_textbook_1749446506_2d158f5d.jpg",
      //       "background": "https://example.com/math_background.jpg",
      //       "reading_video": "https://example.com/math_video.mp4",
      //       "status": true
      //     }
      //   ],
      //   "total_books": 3,
      //   "completed_books": 1,
      // };
      _isGetCategoryReadings.value = false;

      final List<EBook> books = bookList.where((book) => book.categories.any((c) => c == categoryId)).toList();

      _totalBook.value = books.length as int;
      _completedBook.value = books.where((b) => b.isRead).length as int;

      selectedCateBooks.addAll(books);

      _bookIndex.value = 0;
    } else {
      LibFunction.toast('require_network_to_topic');
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
}
