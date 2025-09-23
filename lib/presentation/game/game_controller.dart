import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:EngKid/utils/app_route.dart';
import 'package:EngKid/utils/lib_function.dart';

class GameController extends GetxController with WidgetsBindingObserver {
  GameController();

  // Observable variables
  final RxBool _isLoading = true.obs;
  final Rxn<Map<String, dynamic>> _gameData = Rxn<Map<String, dynamic>>();
  final RxString _gameTitle = ''.obs;
  final RxString _gameType = ''.obs;
  final RxInt _gameId = 0.obs;

  // Getters
  bool get isLoading => _isLoading.value;
  Map<String, dynamic>? get gameData => _gameData.value;
  String get gameTitle => _gameTitle.value;
  String get gameType => _gameType.value;
  int get gameId => _gameId.value;

  @override
  void onInit() {
    super.onInit();
    final arguments = Get.arguments;
    if (arguments != null && arguments is Map<String, dynamic>) {
      _gameId.value = arguments['gameId'] ?? 0;
      _initializeGameData();
    }
  }

  // Mock game data - sẽ được thay thế bằng API call thật trong tương lai
  Future<void> _initializeGameData() async {
    try {
      _isLoading.value = true;

      // Simulate API call delay
      await Future.delayed(const Duration(milliseconds: 500));

      final mockGameData = _getMockGameData(_gameId.value);

      if (mockGameData != null) {
        _gameData.value = mockGameData;
        _gameTitle.value = mockGameData['game_title'] ?? '';
        _gameType.value = mockGameData['game_type'] ?? '';

        // Auto navigate to specific game after loading data
        await _navigateToSpecificGame();
      } else {
        Get.snackbar('Lỗi', 'Không tìm thấy thông tin game');
        Get.back();
      }
    } catch (e) {
      Get.snackbar('Lỗi', 'Có lỗi xảy ra khi tải dữ liệu game');
      Get.back();
    } finally {
      _isLoading.value = false;
    }
  }

  // Mock data structure - có thể thay đổi fields trong tương lai
  Map<String, dynamic>? _getMockGameData(int gameId) {
    final mockGames = {
      1: {
        'game_id': 1,
        'game_title': 'Trò chơi từ vựng về đường xá',
        'game_type':
            'wordle', // wordle, puzzle, memory, missing_word, image_puzzle, four_pics_one_word
        'game_description': 'Học từ vựng liên quan đến an toàn đường xá',
        'difficulty_level': 1,
        'estimated_time': 300, // seconds
        'max_score': 100,
        'thumbnail': 'https://example.com/game1_thumb.jpg',
        'instructions': 'Tìm từ đúng liên quan đến biển báo giao thông',
        'prerequisite_reading_id': 1,
        'is_active': true,
        'created_at': '2023-01-01T00:00:00Z',
        'updated_at': '2023-01-01T00:00:00Z',
      },
      2: {
        'game_id': 2,
        'game_title': 'Ghép hình biển báo',
        'game_type': 'puzzle',
        'game_description': 'Ghép các mảnh tạo thành biển báo hoàn chỉnh',
        'difficulty_level': 2,
        'estimated_time': 240,
        'max_score': 150,
        'thumbnail': 'https://example.com/game2_thumb.jpg',
        'instructions': 'Kéo thả các mảnh ghép để tạo thành biển báo',
        'prerequisite_reading_id': 1,
        'is_active': true,
        'created_at': '2023-01-01T00:00:00Z',
        'updated_at': '2023-01-01T00:00:00Z',
      },
      3: {
        'game_id': 3,
        'game_title': 'Trí nhớ giao thông',
        'game_type': 'memory',
        'game_description': 'Tìm cặp thẻ giống nhau về giao thông',
        'difficulty_level': 1,
        'estimated_time': 180,
        'max_score': 120,
        'thumbnail': 'https://example.com/game3_thumb.jpg',
        'instructions': 'Lật thẻ và tìm cặp hình giống nhau',
        'prerequisite_reading_id': 4,
        'is_active': true,
        'created_at': '2023-01-01T00:00:00Z',
        'updated_at': '2023-01-01T00:00:00Z',
      },
    };

    return mockGames[gameId];
  }

  // Navigate to specific game based on game_type
  Future<void> _navigateToSpecificGame() async {
    await LibFunction.effectConfirmPop();

    switch (_gameType.value) {
      case 'wordle':
        Get.offNamed(AppRoute.wordleGame, arguments: _gameData.value);
        break;
      case 'puzzle':
        Get.offNamed(AppRoute.puzzleGame, arguments: _gameData.value);
        break;
      case 'memory':
        Get.offNamed(AppRoute.memoryGame, arguments: _gameData.value);
        break;
      case 'missing_word':
        Get.offNamed(AppRoute.missingWordGame, arguments: _gameData.value);
        break;
      case 'image_puzzle':
        Get.offNamed(AppRoute.imagePuzzleGame, arguments: _gameData.value);
        break;
      case 'four_pics_one_word':
        Get.offNamed(AppRoute.fourPicsOneWordGame, arguments: _gameData.value);
        break;
      default:
        Get.snackbar('Lỗi', 'Loại game không được hỗ trợ: ${_gameType.value}');
        Get.back();
        break;
    }
  }

  // Utility method để lấy game info (có thể sử dụng trong UI)
  String getGameInfo() {
    if (_gameData.value == null) return 'Đang tải...';

    final data = _gameData.value!;
    return '''
      Tên game: ${data['game_title']}
      Loại: ${data['game_type']}
      Độ khó: ${data['difficulty_level']}
      Thời gian ước tính: ${data['estimated_time']}s
      Điểm tối đa: ${data['max_score']}
      ''';
  }

  @override
  void onClose() {
    super.onClose();
  }
}
