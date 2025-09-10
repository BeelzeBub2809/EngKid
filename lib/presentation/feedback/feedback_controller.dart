import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:EngKid/domain/reading/reading_usecases.dart';
import 'package:EngKid/domain/feedback/feedback_usecases.dart';
import 'package:EngKid/domain/core/entities/lesson/entities/entities.dart';
import 'package:EngKid/data/core/local/share_preferences_manager.dart';
import 'package:EngKid/utils/key_shared_preferences.dart';
import 'dart:async';
import 'dart:convert';
import 'package:EngKid/di/injection.dart';

class FeedbackController extends GetxController with WidgetsBindingObserver {
  final ReadingUsecases _readingUsecases = Get.find<ReadingUsecases>();
  final FeedbackUsecases _feedbackUsecases = Get.find<FeedbackUsecases>();
  final _preferencesManager = getIt.get<SharedPreferencesManager>();

  final formKey = GlobalKey<FormState>();
  final commentController = TextEditingController();
  final searchController = TextEditingController();

  final selectedStory = Rxn<Reading>();
  final selectedStoryId = Rxn<int>();
  final rating = 0.obs;
  final isLoading = false.obs;
  final isSearching = false.obs;
  final showSearchResults = false.obs;

  final RxList<Reading> searchResults = <Reading>[].obs;

  Timer? _debounceTimer;

  @override
  void onInit() {
    super.onInit();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    _setupSearchListener();
  }

  void _setupSearchListener() {
    searchController.addListener(() {
      _debounceTimer?.cancel();
      _debounceTimer = Timer(const Duration(milliseconds: 300), () {
        _performSearch(searchController.text);
      });
    });
  }

  void _performSearch(String query) async {
    if (query.isEmpty) {
      searchResults.clear();
      showSearchResults.value = false;
      return;
    }

    isSearching.value = true;
    try {
      var dynamicList = await _readingUsecases.getListReading(query);

      searchResults.clear();

      for (var item in dynamicList) {
        if (item is Map<String, dynamic>) {
          try {
            var reading = Reading.fromJson(item);
            searchResults.add(reading);
          } catch (e) {
            print('Error parsing reading: $e');
          }
        }
      }

      showSearchResults.value = searchResults.isNotEmpty;
    } catch (e) {
      print('Error searching readings: $e');
      searchResults.clear();
      showSearchResults.value = false;
    } finally {
      isSearching.value = false;
    }
  }

  void selectStory(Reading reading) {
    selectedStory.value = reading;
    selectedStoryId.value = reading.id;
    searchController.text = reading.name;
    showSearchResults.value = false;
  }

  void clearSearch() {
    searchController.clear();
    searchResults.clear();
    showSearchResults.value = false;
    selectedStory.value = null;
    selectedStoryId.value = null;
  }

  void setRating(int value) {
    rating.value = value;
  }

  int? _getCurrentUserId() {
    try {
      final currentUserString =
          _preferencesManager.getString(KeySharedPreferences.userLogin);
      if (currentUserString != null && currentUserString.isNotEmpty) {
        final userData = jsonDecode(currentUserString);
        if (userData is Map<String, dynamic> && userData.containsKey('id')) {
          return userData['id'] as int?;
        }
      }
    } catch (e) {
      print('Error getting current user ID: $e');
    }
    return null;
  }

  void submitFeedback() async {
    if (formKey.currentState?.validate() ?? false) {
      isLoading.value = true;

      try {
        final userId = _getCurrentUserId();
        if (userId == null) {
          Get.snackbar(
            'Lỗi',
            'Không thể xác định người dùng. Vui lòng đăng nhập lại.',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
          return;
        }

        await _feedbackUsecases.sendFeedback(
          userId: userId,
          readingId: selectedStoryId.value,
          rating: rating.value == 0 ? null : rating.value,
          comment: commentController.text.trim().isEmpty
              ? null
              : commentController.text.trim(),
        );

        Get.snackbar(
          'Thành công',
          'Cảm ơn bạn đã gửi phản hồi!',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        clearForm();
      } catch (e) {
        Get.snackbar(
          'Lỗi',
          'Có lỗi xảy ra khi gửi phản hồi: $e',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      } finally {
        isLoading.value = false;
      }
    }
  }

  void clearForm() {
    selectedStory.value = null;
    selectedStoryId.value = null;
    rating.value = 0;
    commentController.clear();
    clearSearch();
  }

  @override
  void onClose() {
    _debounceTimer?.cancel();
    commentController.dispose();
    searchController.dispose();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    super.onClose();
  }
}
