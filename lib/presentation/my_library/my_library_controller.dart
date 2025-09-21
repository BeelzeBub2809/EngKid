import 'dart:async';
import 'package:get/get.dart';
import 'package:EngKid/utils/app_route.dart';
import 'package:EngKid/utils/audios.dart';
import 'package:EngKid/utils/lib_function.dart';

import '../core/network_service.dart';

class MyLibraryController extends GetxController {
  MyLibraryController();

  final NetworkService _networkService = Get.find<NetworkService>();

  // Pagination variables
  final int itemsPerPage = 4; // Changed to 4 for 2x2 grid layout
  final RxInt _currentPage = 0.obs;

  int get currentPage => _currentPage.value;
  int get totalPages => (learningPaths.length / itemsPerPage).ceil();
  bool get hasNextPage => currentPage < totalPages - 1;
  bool get hasPreviousPage => currentPage > 0;

  final RxList<Map<String, dynamic>> learningPaths = <Map<String, dynamic>>[
    {
      'id': 1,
      'name': 'Basic English',
      'description':
          'Học tiếng Anh cơ bản từ đầu với các từ vựng và cấu trúc câu đơn giản',
      'image': 'assets/images/elibrary_book_icon.png',
    },
    {
      'id': 2,
      'name': 'Vocabulary',
      'description':
          'Mở rộng vốn từ vựng với các chủ đề hấp dẫn và bài tập thực hành',
      'image': 'assets/images/elibrary_book_icon.png',
    },
    {
      'id': 3,
      'name': 'Grammar',
      'description':
          'Nắm vững ngữ pháp tiếng Anh qua các bài học và ví dụ sinh động',
      'image': 'assets/images/elibrary_book_icon.png',
    },
    {
      'id': 4,
      'name': 'Speaking',
      'description':
          'Luyện tập kỹ năng nói với các tình huống giao tiếp thực tế',
      'image': 'assets/images/elibrary_book_icon.png',
    },
    {
      'id': 5,
      'name': 'Reading',
      'description':
          'Phát triển kỹ năng đọc hiểu qua các câu chuyện và bài đọc thú vị',
      'image': 'assets/images/elibrary_book_icon.png',
    },
    {
      'id': 6,
      'name': 'Writing',
      'description':
          'Học cách viết tiếng Anh từ câu đơn giản đến đoạn văn hoàn chỉnh',
      'image': 'assets/images/elibrary_book_icon.png',
    },
    {
      'id': 7,
      'name': 'Listening',
      'description': 'Rèn luyện khả năng nghe hiểu qua âm thanh và video',
      'image': 'assets/images/elibrary_book_icon.png',
    },
    {
      'id': 8,
      'name': 'Pronunciation',
      'description': 'Học cách phát âm chuẩn với hệ thống nhận diện giọng nói',
      'image': 'assets/images/elibrary_book_icon.png',
    },
    {
      'id': 9,
      'name': 'Conversation',
      'description':
          'Thực hành đối thoại và giao tiếp trong các tình huống khác nhau',
      'image': 'assets/images/elibrary_book_icon.png',
    },
    {
      'id': 10,
      'name': 'Advanced',
      'description': 'Nâng cao trình độ tiếng Anh với nội dung chuyên sâu',
      'image': 'assets/images/elibrary_book_icon.png',
    },
    {
      'id': 11,
      'name': 'Practice',
      'description': 'Luyện tập tổng hợp tất cả kỹ năng đã học',
      'image': 'assets/images/elibrary_book_icon.png',
    },
    {
      'id': 12,
      'name': 'Learning',
      'description': 'Khám phá các phương pháp học tiếng Anh hiệu quả',
      'image': 'assets/images/elibrary_book_icon.png',
    },
  ].obs;

  // Get current page items
  List<Map<String, dynamic>> get currentPageItems {
    final startIndex = currentPage * itemsPerPage;
    final endIndex = (startIndex + itemsPerPage).clamp(0, learningPaths.length);
    return learningPaths.sublist(startIndex, endIndex);
  }

  // Pagination methods
  void nextPage() {
    if (hasNextPage) {
      _currentPage.value++;
    }
  }

  void previousPage() {
    if (hasPreviousPage) {
      _currentPage.value--;
    }
  }

  void goToPage(int pageIndex) {
    if (pageIndex >= 0 && pageIndex < totalPages) {
      _currentPage.value = pageIndex;
    }
  }

  @override
  Future<void> onInit() async {
    super.onInit();
    Future.delayed(const Duration(milliseconds: 1000), () {
      LibFunction.playAudioLocal(LocalAudio.chooseGrade);
    });
  }

  void onBackPress() async {
    await LibFunction.effectExit();
    Get.back();
  }

  void onPressLearningPath(Map<String, dynamic> learningPath) async {
    await LibFunction.effectConfirmPop();
    if (_networkService.networkConnection.value) {
      Get.toNamed(AppRoute.readingSpace, arguments: learningPath);
    } else {
      LibFunction.toast('require_network_to_grade');
    }
  }
}
