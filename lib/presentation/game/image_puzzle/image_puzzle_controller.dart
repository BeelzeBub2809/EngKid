import 'dart:async';
import 'dart:math';
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
  // Observable states
  final RxBool isLoading = false.obs;
  final RxBool showingCompleteImage = true.obs;
  final RxInt previewCountdown = 10.obs;
  final RxBool gameCompleted = false.obs;
  final RxInt draggedIndex = (-1).obs;
  final RxList<int> currentOrder = <int>[].obs;

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
    _initializeGame();
  }

  @override
  void onClose() {
    _previewTimer?.cancel();
    _audioPlayer.dispose();
    super.onClose();
  }

  void _initializeGame() {
    isLoading.value = true;

    // Mock data for testing
    currentPuzzle.value = PuzzleData(
      word: "CAT",
      backgroundImagePath: "https://images.unsplash.com/photo-1514888286974-6c03e2ca1dba?ixlib=rb-4.0.3&auto=format&fit=crop&w=400&q=80",
      audioPath: "https://www.soundjay.com/misc/sounds/cat.mp3",
    );

    _setupPuzzleOrder();
    _startPreviewTimer();

    isLoading.value = false;
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
      _playCompletionSound();
      Future.delayed(const Duration(seconds: 3), () {
        _showCompletionDialog();
      });
    }
  }

  void _playCompletionSound() async {
    try {
      if (currentPuzzle.value?.audioPath != null) {
        await _audioPlayer.setUrl(currentPuzzle.value!.audioPath!);
        await _audioPlayer.play();
      }
    } catch (e) {
      print('Error playing completion sound: $e');
    }
  }

  void _showCompletionDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text('🎉 Chúc mừng!'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Bạn đã hoàn thành từ: ${currentPuzzle.value?.word ?? ''}'),
            const SizedBox(height: 16),
            const Text('Bạn đã ghép đúng tất cả các mảnh!'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
              resetGame();
            },
            child: const Text('Chơi lại'),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              Get.back(); // Return to previous screen
            },
            child: const Text('Thoát'),
          ),
        ],
      ),
    );
  }

  void resetGame() {
    gameCompleted.value = false;
    showingCompleteImage.value = true;
    previewCountdown.value = 10;
    draggedIndex.value = -1;
    _initializeGame();
  }
}
