import 'package:EngKid/domain/entities/word/word_entity.dart';
import 'package:EngKid/domain/word/get_words_by_game_id_usecase.dart';
import 'package:EngKid/presentation/core/topic_service.dart';
import 'package:EngKid/presentation/core/user_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:EngKid/utils/lib_function.dart';
import 'package:EngKid/widgets/dialog/dialog_four_pics_result.dart';

class FourPicsOneWordQuestion {
  final String word;
  final String imagePaths;
  final String hint;
  final int difficulty; // 1: easy, 2: medium, 3: hard

  FourPicsOneWordQuestion({
    required this.word,
    required this.imagePaths,
    required this.hint,
    this.difficulty = 1,
  });
}

class FourPicsOneWordController extends GetxController {
  late FlutterTts _flutterTts;
  final GetWordsByGameIdUseCase _getWordsByGameIdUseCase;
  FourPicsOneWordController(this._getWordsByGameIdUseCase);

  final TopicService _topicService = Get.find<TopicService>();
  final UserService _userService = Get.find<UserService>();
  // Game state variables - chỉ có 1 question
  final Rx<FourPicsOneWordQuestion?> _currentQuestion = Rx<FourPicsOneWordQuestion?>(null);
  final RxString _currentAnswer = ''.obs;
  final RxString _playerInput = ''.obs;
  final RxList<String> _availableLetters = <String>[].obs;
  final RxList<String> _selectedLetters = <String>[].obs;
  final RxBool _gameFinished = false.obs;
  final RxBool _isCorrect = false.obs;
  final RxInt _score = 0.obs;
  final RxBool _answeredCorrectly = false.obs;
  final RxInt _hints = 3.obs;
  final RxBool _isLoading = true.obs;
  final RxBool _showHint = false.obs;
  Map<String, dynamic>? _gameData;
  int get gameId => _gameData?['game_id'] ?? 2;
  int get learningPathId => _gameData?['learning_path_id'] ?? 1;
  final _words = <WordEntity>[].obs;
  final RxInt _hintRevealedCount = 0.obs;

  // Getters
  FourPicsOneWordQuestion? get currentQuestion => _currentQuestion.value;
  String get currentAnswer => _currentAnswer.value;
  String get playerInput => _playerInput.value;
  List<String> get availableLetters => _availableLetters;
  List<String> get selectedLetters => _selectedLetters;
  bool get gameFinished => _gameFinished.value;
  bool get isCorrect => _isCorrect.value;
  int get score => _score.value;
  bool get answeredCorrectly => _answeredCorrectly.value;
  int get hints => _hints.value;
  bool get isLoading => _isLoading.value;
  bool get showHint => _showHint.value;

  @override
  void onInit() {
    super.onInit();
    _initializeTTS();
    _gameData = Get.arguments as Map<String, dynamic>?;
    _loadGameData();
  }

  @override
  void onClose() {
    _flutterTts.stop();
    super.onClose();
  }

  void _initializeTTS() {
    _flutterTts = FlutterTts();
    _flutterTts.setLanguage('en-US');
    _flutterTts.setSpeechRate(0.5);
    _flutterTts.setVolume(0.8);
    _flutterTts.setPitch(1.0);
  }

  Future<void> _loadGameData() async {
    try {
      _isLoading.value = true;
      final fetchedWords = await _getWordsByGameIdUseCase.call(gameId);
      if (fetchedWords.isEmpty) {
        throw Exception('No words found for this game');
      }
      _words.value = fetchedWords;
      final question = FourPicsOneWordQuestion(
        word: _words[0].word,
        imagePaths: _words[0].image,
        hint: '',
      );
      _hints.value = (question.word.length - 1).clamp(0, question.word.length);
      _currentQuestion.value = question;

      // Start game
      await Future.delayed(const Duration(milliseconds: 500));
      _startGame();

    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load game data: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      _isLoading.value = false;
    }
  }

  void _startGame() {
    if (_currentQuestion.value != null) {
      final question = _currentQuestion.value!;
      _currentAnswer.value = question.word.toUpperCase();
      _playerInput.value = '';
      _selectedLetters.clear();
      _isCorrect.value = false;
      _showHint.value = false;
      _gameFinished.value = false;
      _answeredCorrectly.value = false;
      _generateAvailableLetters();
    }
  }

  void _generateAvailableLetters() {
    final answer = _currentAnswer.value;
    final answerLetters = answer.split('');

    // Add extra random letters to make it challenging
    final extraLetters = ['A', 'E', 'I', 'O', 'U', 'R', 'S'];
    final neededExtra = (16 - answerLetters.length).clamp(0, extraLetters.length);

    final allLetters = <String>[];
    allLetters.addAll(answerLetters);

    // Add random extra letters
    for (int i = 0; i < neededExtra; i++) {
      allLetters.add(extraLetters[i % extraLetters.length]);
    }

    // Shuffle the letters
    allLetters.shuffle();
    _availableLetters.assignAll(allLetters);
  }

  void selectLetter(String letter, int index) {
    if (_selectedLetters.length < _currentAnswer.value.length && !_gameFinished.value) {
      _selectedLetters.add(letter);
      _availableLetters.removeAt(index);
      _updatePlayerInput();

      // Auto-check when word is complete
      if (_selectedLetters.length == _currentAnswer.value.length) {
        Future.delayed(const Duration(milliseconds: 300), () {
          _checkAnswer();
        });
      }
    }
  }

  void removeLetter(int index) {
    if (index < _selectedLetters.length && !_gameFinished.value) {
      final letter = _selectedLetters.removeAt(index);
      _availableLetters.add(letter);
      _updatePlayerInput();
    }
  }

  void _updatePlayerInput() {
    _playerInput.value = _selectedLetters.join('');
  }

  void _checkAnswer() {
    if (_playerInput.value == _currentAnswer.value) {
      _handleCorrectAnswer();
    } else {
      _handleWrongAnswer();
    }
  }

  void _handleCorrectAnswer() {
    _isCorrect.value = true;
    _answeredCorrectly.value = true;
    final points = (currentQuestion?.difficulty ?? 1) * 10;
    _score.value += points;

    // Play success sound
    LibFunction.playAudioLocal('assets/audios/correct.wav');

    // Speak the correct word
    _flutterTts.speak(_currentAnswer.value);

    // Show success feedback
    Get.snackbar(
      'Excellent! 🎉',
      'Correct! The answer is ${_currentAnswer.value}',
      backgroundColor: Colors.green,
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
      snackPosition: SnackPosition.TOP,
    );

    // End game after delay since we only have 1 question
    Future.delayed(const Duration(seconds: 2), () {
      _endGame();
    });
  }

  void _handleWrongAnswer() {
    // Clear selection and return letters
    _availableLetters.addAll(_selectedLetters);
    _selectedLetters.clear();
    _playerInput.value = '';

    // Play wrong sound
    LibFunction.playAudioLocal('assets/audios/wrong.wav');

    // Show feedback
    Get.snackbar(
      'Try Again! 🤔',
      'Not quite right. Give it another try!',
      backgroundColor: Colors.orange,
      colorText: Colors.white,
      duration: const Duration(seconds: 1),
      snackPosition: SnackPosition.TOP,
    );
  }

  void useHint() {
    final answer = _currentAnswer.value;

    if (_hints.value > 0 && _hintRevealedCount.value < answer.length) {
      _hints.value--;

      final revealIndex = _hintRevealedCount.value;
      final letterToReveal = answer[revealIndex];

      _hintRevealedCount.value++;

      Get.snackbar(
        'Hint! 💡',
        'The ${revealIndex + 1} letter is "$letterToReveal"',
        backgroundColor: Colors.blue,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
        snackPosition: SnackPosition.TOP,
      );
    } else if (_hints.value <= 0) {
      Get.snackbar(
        'No Hints Left! 😅',
        'You\'ve used all your hints for this game.',
        backgroundColor: Colors.grey,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
    } else {
      Get.snackbar(
        'All Letters Revealed!',
        'The whole word is already revealed.',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
    }
  }



  Future<void> _endGame() async {
    _gameFinished.value = true;
    await _topicService.submitGameResult(_userService.currentUser.id, null, 5, 1, "00:00", learningPathId, gameId);
    _showGameResult();
  }

  void restartGame() {
    _score.value = 0;
    _hints.value = 3;
    _gameFinished.value = false;
    _answeredCorrectly.value = false;
    _startGame();
  }

  void _showGameResult() {
    final finalScore = _score.value;
    final wasCorrect = _answeredCorrectly.value;

    // Play finish sound
    LibFunction.playAudioLocal('assets/audios/finish.mp3');

    // Show result dialog
    Get.dialog(
      DialogFourPicsResult(
        score: finalScore,
        totalQuestions: 1,
        correctAnswers: wasCorrect ? 1 : 0,
        onRestart: () {
          Get.back();
          restartGame();
        },
        onExit: () {
          Get.back();
          Get.back();
        },
      ),
      barrierDismissible: false,
    );
  }

  void speakWord(String word) {
    _flutterTts.speak(word);
  }

  void playBackgroundMusic() {
    LibFunction.playAudioLocal('assets/audios/sound_in_quiz.mp3');
  }

  void stopBackgroundMusic() {
    LibFunction.effectFinish();
  }
}
