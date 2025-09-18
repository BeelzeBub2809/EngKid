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
  final int itemsPerPage = 5;
  final RxInt _currentPage = 0.obs;

  int get currentPage => _currentPage.value;
  int get totalPages => (learningPaths.length / itemsPerPage).ceil();
  bool get hasNextPage => currentPage < totalPages - 1;
  bool get hasPreviousPage => currentPage > 0;

  final RxList<Map<String, dynamic>> learningPaths = <Map<String, dynamic>>[
    {
      'id': 1,
      'name': 'Basic English',
      'image': 'assets/images/elibrary_book_icon.png',
      'isOpen': true,
    },
    {
      'id': 2,
      'name': 'Vocabulary',
      'image': 'assets/images/elibrary_book_icon.png',
      'isOpen': true,
    },
    {
      'id': 3,
      'name': 'Grammar',
      'image': 'assets/images/elibrary_book_icon.png',
      'isOpen': false,
    },
    {
      'id': 4,
      'name': 'Speaking',
      'image': 'assets/images/elibrary_book_icon.png',
      'isOpen': false,
    },
    {
      'id': 5,
      'name': 'Reading',
      'image': 'assets/images/elibrary_book_icon.png',
      'isOpen': true,
    },
    {
      'id': 6,
      'name': 'Writing',
      'image': 'assets/images/elibrary_book_icon.png',
      'isOpen': false,
    },
    {
      'id': 7,
      'name': 'Listening',
      'image': 'assets/images/elibrary_book_icon.png',
      'isOpen': true,
    },
    {
      'id': 8,
      'name': 'Pronunciation',
      'image': 'assets/images/elibrary_book_icon.png',
      'isOpen': false,
    },
    {
      'id': 9,
      'name': 'Conversation',
      'image': 'assets/images/elibrary_book_icon.png',
      'isOpen': true,
    },
    {
      'id': 10,
      'name': 'Advanced',
      'image': 'assets/images/elibrary_book_icon.png',
      'isOpen': false,
    },
    {
      'id': 11,
      'name': 'Practice',
      'image': 'assets/images/elibrary_book_icon.png',
      'isOpen': true,
    },
    {
      'id': 12,
      'name': 'Learning',
      'image': 'assets/images/elibrary_book_icon.png',
      'isOpen': true,
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
    if (!learningPath['isOpen']) {
      LibFunction.playAudioLocal(LocalAudio.lock);
    } else {
      await LibFunction.effectConfirmPop();
      if (_networkService.networkConnection.value) {
        Get.toNamed(AppRoute.readingSpace, arguments: learningPath);
      } else {
        LibFunction.toast('require_network_to_grade');
      }
    }
  }
}
