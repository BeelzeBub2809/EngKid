import 'dart:async';
import 'dart:math';
import 'package:EngKid/presentation/core/topic_service.dart';
import 'package:EngKid/presentation/core/user_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../../../domain/word/get_words_by_game_id_usecase.dart';
import '../../../domain/entities/word/word_entity.dart';

enum MemoryGameType { cardMatching }

enum GameState { loading, playing, finished }

enum CardType { word, image }

class MemoryCard {
  final int id;
  final int pairId; // ID to identify matching pairs
  final String content; // Either word or empty for image cards
  final String word; // Original word
  final String image; // Word image URL
  final CardType type; // word or image
  final Color color;
  bool isFlipped;
  bool isMatched;

  MemoryCard({
    required this.id,
    required this.pairId,
    required this.content,
    required this.word,
    required this.image,
    required this.type,
    required this.color,
    this.isFlipped = false,
    this.isMatched = false,
  });
}

class MemoryGameController extends GetxController {
  final GetWordsByGameIdUseCase _getWordsByGameIdUseCase;

  MemoryGameController(this._getWordsByGameIdUseCase);

  final TopicService _topicService = Get.find<TopicService>();
  final UserService _userService = Get.find<UserService>();
  // Game state
  final _gameState = GameState.loading.obs;
  final _gameInProgress = false.obs;
  final _gameFinished = false.obs;
  final _isLoading = true.obs;
  final _timerActive = false.obs;

  // Game data from navigation arguments
  Map<String, dynamic>? _gameData;
  int get gameId => _gameData?['game_id'] ?? 2;
  int get learningPathId => _gameData?['learning_path_id'] ?? 1;

  // Game progress
  final _score = 0.obs;
  final _attempts = 0.obs;
  final _correctAttempts = 0.obs;
  final _gameTime = 180.obs; // 3 minutes default

  // Card matching specific
  final _cards = <MemoryCard>[].obs;
  final _flippedCards = <int>[].obs;
  final _canFlipCards = true.obs;
  final _matchedPairs = 0.obs;

  // Words from API
  final _words = <WordEntity>[].obs;
  final _errorMessage = ''.obs;

  Timer? _gameTimer;
  late FlutterTts _flutterTts;

  // Getters
  GameState get gameState => _gameState.value;
  bool get gameInProgress => _gameInProgress.value;
  bool get gameFinished => _gameFinished.value;
  bool get isLoading => _isLoading.value;
  bool get timerActive => _timerActive.value;

  int get score => _score.value;
  int get attempts => _attempts.value;
  int get correctAttempts => _correctAttempts.value;
  int get gameTime => _gameTime.value;

  List<MemoryCard> get cards => _cards;
  List<int> get flippedCards => _flippedCards;
  bool get canFlipCards => _canFlipCards.value;
  int get matchedPairs => _matchedPairs.value;
  List<WordEntity> get words => _words;
  String get errorMessage => _errorMessage.value;

  @override
  void onInit() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    _gameData = Get.arguments as Map<String, dynamic>?;
    _initializeTts();
    _initializeGame();
    super.onInit();
  }

  void _initializeTts() {
    _flutterTts = FlutterTts();
    _flutterTts.setLanguage('en-US');
    _flutterTts.setSpeechRate(0.6);
    _flutterTts.setVolume(1.0);
    _flutterTts.setPitch(1.0);
  }

  Future<void> _initializeGame() async {
    await _loadWordsAndStartGame();
  }

  Future<void> _loadWordsAndStartGame() async {
    _gameState.value = GameState.loading;
    _isLoading.value = true;
    _errorMessage.value = '';

    try {
      // Fetch words from API using game ID from arguments
      final fetchedWords = await _getWordsByGameIdUseCase.call(gameId);
      _words.value = fetchedWords;

      if (fetchedWords.isEmpty) {
        throw Exception('No words found for this game');
      }

      // Generate cards from words
      await _generateCardsFromWords();

      // Start the game
      _gameState.value = GameState.playing;
      _gameInProgress.value = true;
      _timerActive.value = true;
      _isLoading.value = false;
      _startGameTimer();
    } catch (e) {
      _errorMessage.value = e.toString();
      _isLoading.value = false;
      _gameState.value = GameState.loading; // Stay in loading to show error

      Get.snackbar(
        'Error',
        'Failed to load game: ${e.toString()}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    }
  }

  Future<void> _generateCardsFromWords() async {
    _cards.clear();

    // Limit to maximum 12 words (24 cards total) for better gameplay
    final wordsToUse = _words.take(12).toList();

    final colors = [
      Colors.red,
      Colors.blue,
      Colors.green,
      Colors.yellow,
      Colors.purple,
      Colors.orange,
      Colors.pink,
      Colors.cyan,
      Colors.lime,
      Colors.indigo,
      Colors.teal,
      Colors.amber,
    ];

    final cardPairs = <MemoryCard>[];

    for (int i = 0; i < wordsToUse.length; i++) {
      final word = wordsToUse[i];
      final color = colors[i % colors.length];

      // Create word card (with text and pronunciation button)
      cardPairs.add(MemoryCard(
        id: i * 2,
        pairId: i,
        content: word.word,
        word: word.word,
        image: word.image,
        type: CardType.word,
        color: color,
      ));

      // Create image card (with word image)
      cardPairs.add(MemoryCard(
        id: i * 2 + 1,
        pairId: i,
        content: '', // Empty content for image cards
        word: word.word,
        image: word.image,
        type: CardType.image,
        color: color,
      ));
    }

    // Shuffle the cards
    final random = Random();
    cardPairs.shuffle(random);
    _cards.value = cardPairs;

    // Adjust game time based on number of cards
    final cardCount = _cards.length;
    if (cardCount <= 12) {
      _gameTime.value = 120; // 2 minutes for small games
    } else if (cardCount <= 16) {
      _gameTime.value = 150; // 2.5 minutes for medium games
    } else {
      _gameTime.value = 180; // 3 minutes for large games
    }
  }

  void _startGameTimer() {
    _gameTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_gameTime.value > 0 && _gameInProgress.value) {
        _gameTime.value--;
      } else if (_gameTime.value == 0) {
        timer.cancel();
        _gameOver(false);
      }
    });
  }

  Future<void> playPronunciation(String word) async {
    try {
      await _flutterTts.speak(word);
    } catch (e) {
      print('Error playing pronunciation: $e');
    }
  }

  void flipCard(int cardIndex) {
    if (!_canFlipCards.value ||
        _cards[cardIndex].isFlipped ||
        _cards[cardIndex].isMatched ||
        _flippedCards.length >= 2) return;

    _cards[cardIndex].isFlipped = true;
    _flippedCards.add(cardIndex);
    _cards.refresh();

    // Auto-play pronunciation when card is flipped
    playPronunciation(_cards[cardIndex].word);

    if (_flippedCards.length == 2) {
      _canFlipCards.value = false;
      _checkMatch();
    }
  }

  void _checkMatch() {
    final card1 = _cards[_flippedCards[0]];
    final card2 = _cards[_flippedCards[1]];

    // Check if they have the same pairId and different types (word vs image)
    if (card1.pairId == card2.pairId && card1.type != card2.type) {
      // Match found - word matches its image
      card1.isMatched = true;
      card2.isMatched = true;
      _matchedPairs.value++;
      _score.value += 10;
      _correctAttempts.value++;
      _flippedCards.clear();
      _canFlipCards.value = true;

      // Check if game is complete
      final totalPairs = _cards.length ~/ 2;
      if (_matchedPairs.value >= totalPairs) {
        _gameComplete();
      }
    } else {
      // No match
      Future.delayed(const Duration(seconds: 1), () {
        card1.isFlipped = false;
        card2.isFlipped = false;
        _flippedCards.clear();
        _canFlipCards.value = true;
        _cards.refresh();
      });
    }

    _attempts.value++;
    _cards.refresh();
  }

  Future<void> _gameComplete() async {
    _gameState.value = GameState.finished;
    _gameFinished.value = true;
    _gameInProgress.value = false;
    _timerActive.value = false;
    _gameTimer?.cancel();

    // Bonus points for time remaining
    _score.value += _gameTime.value;
    await _topicService.submitGameResult(_userService.currentUser.id, null, 5, 1, "00:00", learningPathId, gameId);
    Get.snackbar(
      'Congratulations!',
      'You completed the memory game with score: ${_score.value}',
      backgroundColor: Colors.green,
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
    );
  }

  void _gameOver(bool won) {
    _gameState.value = GameState.finished;
    _gameFinished.value = true;
    _gameInProgress.value = false;
    _timerActive.value = false;
    _gameTimer?.cancel();

    Get.snackbar(
      won ? 'Well Done!' : 'Time\'s Up!',
      won ? 'You won the game!' : 'Better luck next time!',
      backgroundColor: won ? Colors.green : Colors.red,
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
    );
  }

  void pauseGame() {
    _gameInProgress.value = false;
    _timerActive.value = false;
    _gameTimer?.cancel();
  }

  void resumeGame() {
    _gameInProgress.value = true;
    _timerActive.value = true;
    _startGameTimer();
  }

  void resetGame() {
    _gameState.value = GameState.loading;
    _gameFinished.value = false;
    _gameInProgress.value = false;
    _score.value = 0;
    _attempts.value = 0;
    _correctAttempts.value = 0;
    _timerActive.value = false;
    _matchedPairs.value = 0;
    _isLoading.value = true;
    _errorMessage.value = '';

    _cards.clear();
    _flippedCards.clear();
    _gameTimer?.cancel();

    // Reload the game
    _initializeGame();
  }

  @override
  void onClose() {
    _gameTimer?.cancel();
    _flutterTts.stop();
    // Restore normal orientation when controller is disposed
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
    super.onClose();
  }
}
