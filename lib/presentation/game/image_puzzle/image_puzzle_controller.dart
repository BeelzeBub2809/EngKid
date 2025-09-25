import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:EngKid/domain/entities/word/word_entity.dart';
import 'package:EngKid/domain/word/get_pronunciation_usecase.dart';
import 'package:EngKid/domain/word/get_words_by_game_id_usecase.dart';
import 'package:EngKid/presentation/core/topic_service.dart';
import 'package:EngKid/presentation/core/user_service.dart';
import 'package:EngKid/utils/lib_function.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';

// Entity classes
class PuzzleData {
  final String word;
  final String backgroundImagePath;
  final String? audioPath;

  PuzzleData({
    required this.word,
    required this.backgroundImagePath,
    this.audioPath,
  });
}

class ImagePuzzleGameController extends GetxController {
  final TopicService _topicService = Get.find<TopicService>();
  final UserService _userService = Get.find<UserService>();
  final GetWordsByGameIdUseCase _getWordsByGameIdUseCase;
  final GetPronunciationUrlUseCase _getPronunciationUrlUseCase;
  ImagePuzzleGameController(this._getWordsByGameIdUseCase, this._getPronunciationUrlUseCase);
  // Observable states
  final RxBool isLoading = false.obs;
  final RxBool showingCompleteImage = true.obs;
  final RxInt previewCountdown = 10.obs;
  final RxBool gameCompleted = false.obs;
  final RxInt draggedIndex = (-1).obs;
  final RxList<int> currentOrder = <int>[].obs;

  Map<String, dynamic>? _gameData;
  int get gameId => _gameData?['game_id'] ?? 2;
  int get learningPathId => _gameData?['learning_path_id'] ?? 1;
  final _words = <WordEntity>[].obs;

  // Make currentPuzzle observable
  final Rx<PuzzleData?> currentPuzzle = Rx<PuzzleData?>(null);

  // Game data
  late AudioPlayer _audioPlayer;
  Timer? _previewTimer;

  // Getters
  bool get isNetworkImage => currentPuzzle.value?.backgroundImagePath.startsWith('http') ?? false;

  @override
  void onInit() {
    super.onInit();
    _audioPlayer = AudioPlayer();
    _gameData = Get.arguments as Map<String, dynamic>?;
    _initializeGame();
  }

  @override
  void onClose() {
    _previewTimer?.cancel();
    _audioPlayer.dispose();
    super.onClose();
  }

  Future<void> _initializeGame() async {
    isLoading.value = true;

    try {
      final fetchedWords = await _getWordsByGameIdUseCase.call(gameId);
      if (fetchedWords.isEmpty) {
        throw Exception('No words found for this game');
      }
      _words.value = fetchedWords;
      currentPuzzle.value = PuzzleData(
        word: _words[0].word,
        backgroundImagePath: _words[0].image,
        audioPath: null,
      );

      _setupPuzzleOrder();
      _startPreviewTimer();

      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      print("Fail to load word in image puzzle game");
      print(e);
    }
  }

  void _setupPuzzleOrder() {
    if (currentPuzzle.value == null) return;

    // Initialize with correct order first
    final wordLength = currentPuzzle.value!.word.length;
    currentOrder.value = List.generate(wordLength, (index) => index);

    // Shuffle after preview
    Future.delayed(const Duration(milliseconds: 500), () {
      _shufflePieces();
    });
  }

  void _shufflePieces() {
    if (currentPuzzle.value == null) return;

    final shuffled = List<int>.from(currentOrder);
    shuffled.shuffle(Random());

    // Make sure it's actually shuffled (not in correct order)
    while (_isInCorrectOrder(shuffled) && shuffled.length > 1) {
      shuffled.shuffle(Random());
    }

    currentOrder.value = shuffled;
  }

  bool _isInCorrectOrder(List<int> order) {
    for (int i = 0; i < order.length; i++) {
      if (order[i] != i) return false;
    }
    return true;
  }

  void _startPreviewTimer() {
    showingCompleteImage.value = true;
    previewCountdown.value = 10;

    _previewTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      previewCountdown.value--;
      if (previewCountdown.value <= 0) {
        timer.cancel();
        // Auto start game after preview
        Future.delayed(const Duration(milliseconds: 500), () {
          startGame();
        });
      }
    });
  }

  void startGame() {
    _previewTimer?.cancel();
    showingCompleteImage.value = false;
    gameCompleted.value = false;
    _shufflePieces();
  }

  void startDragging(int index) {
    draggedIndex.value = index;
  }

  void stopDragging() {
    draggedIndex.value = -1;
  }

  void swapPieces(int fromIndex, int toIndex) {
    if (fromIndex == toIndex) return;

    print('🔄 BEFORE SWAP: currentOrder = $currentOrder');
    print('🔄 Swapping fromIndex: $fromIndex, toIndex: $toIndex');

    final newOrder = List<int>.from(currentOrder);
    final temp = newOrder[fromIndex];
    newOrder[fromIndex] = newOrder[toIndex];
    newOrder[toIndex] = temp;

    currentOrder.value = newOrder;

    print('🔄 AFTER SWAP: currentOrder = $currentOrder');

    // Force UI update
    currentOrder.refresh();

    // Check if game is completed
    _checkGameCompletion();
  }

  void _checkGameCompletion() {
    if (_isInCorrectOrder(currentOrder)) {
      gameCompleted.value = true;
      LibFunction.playAudioLocal('assets/audios/correct.wav');
      _playCompletionSound();
      _showFireworksAnimation();
    }
  }

  void _playCompletionSound() async {
    try {
      final word = currentPuzzle.value?.word;
      if (word != null) {
        // Gọi API lấy audio path
        final audioUrl = await _getPronunciationUrlUseCase.call(word);
        if (audioUrl != null && audioUrl.isNotEmpty) {
          await _audioPlayer.setUrl(audioUrl);
          await _audioPlayer.play();
        } else {
          print("⚠️ No audio found for $word");
        }
      }
    } catch (e) {
      print('Error playing completion sound: $e');
    }
  }

  Future<void> _showFireworksAnimation() async {
    Get.dialog(
      Center(
        child: Image.asset(
          "assets/gifs/fireworks.gif",
          fit: BoxFit.cover,
        ),
      ),
      barrierDismissible: false,
    );

    await _topicService.submitReadingResult(_userService.currentUser.id, null, 5, 1, 0, learningPathId, gameId);

    Future.delayed(const Duration(seconds: 6), () {
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }
      Get.back(result: true);
    });
  }


  void resetGame() {
    gameCompleted.value = false;
    showingCompleteImage.value = true;
    previewCountdown.value = 10;
    draggedIndex.value = -1;
    _initializeGame();
  }
}
