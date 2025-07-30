import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_tts/flutter_tts.dart';

enum MemoryGameType { cardMatching }

enum MemoryDifficulty { easy, medium, hard }

enum GameState { setup, loading, playing, finished }

enum CardType { word, phonetic }

class WordData {
  final String word;
  final String pronunciation;
  final String phonetic;

  WordData({
    required this.word,
    required this.pronunciation,
    required this.phonetic,
  });

  factory WordData.fromJson(Map<String, dynamic> json) {
    return WordData(
      word: json['word'] ?? '',
      pronunciation: json['pronunciation'] ?? '',
      phonetic: json['phonetic'] ?? '',
    );
  }
}

class RandomWordResponse {
  final String word;

  RandomWordResponse({required this.word});

  factory RandomWordResponse.fromJson(Map<String, dynamic> json) {
    return RandomWordResponse(word: json['word'] ?? '');
  }
}

class MemoryCard {
  final int id;
  final int pairId; // ID to identify matching pairs
  final String content; // Either word or phonetic
  final String word; // Original word
  final String pronunciation;
  final String phonetic;
  final CardType type; // word or phonetic
  final Color color;
  bool isFlipped;
  bool isMatched;

  MemoryCard({
    required this.id,
    required this.pairId,
    required this.content,
    required this.word,
    required this.pronunciation,
    required this.phonetic,
    required this.type,
    required this.color,
    this.isFlipped = false,
    this.isMatched = false,
  });
}

class MemoryGameController extends GetxController {
  // Game state
  final _gameState = GameState.setup.obs;
  final _gameStarted = false.obs;
  final _gameInProgress = false.obs;
  final _gameFinished = false.obs;
  final _isLoading = false.obs;
  final _showResult = false.obs;
  final _timerActive = false.obs;

  // Game settings
  final _selectedGameType = MemoryGameType.cardMatching.obs;
  final _selectedDifficulty = MemoryDifficulty.easy.obs;
  final _rounds = 1.obs;
  final _currentRound = 0.obs;

  // Game progress
  final _score = 0.obs;
  final _attempts = 0.obs;
  final _correctAttempts = 0.obs;
  final _round = 1.obs;
  final _gameTime = 120.obs; // 2 minutes for card matching

  // Card matching specific
  final _cards = <MemoryCard>[].obs;
  final _flippedCards = <int>[].obs;
  final _canFlipCards = true.obs;
  final _matchedPairs = 0.obs;

  Timer? _gameTimer;

  // Getters
  GameState get gameState => _gameState.value;
  bool get gameStarted => _gameStarted.value;
  bool get gameInProgress => _gameInProgress.value;
  bool get gameFinished => _gameFinished.value;
  bool get isLoading => _isLoading.value;
  bool get showResult => _showResult.value;
  bool get timerActive => _timerActive.value;

  MemoryGameType get selectedGameType => _selectedGameType.value;
  MemoryDifficulty get selectedDifficulty => _selectedDifficulty.value;
  String get selectedDifficultyString =>
      _selectedDifficulty.value.name.capitalize!;
  int get rounds => _rounds.value;
  int get currentRound => _currentRound.value;

  int get score => _score.value;
  int get attempts => _attempts.value;
  int get correctAttempts => _correctAttempts.value;
  int get round => _round.value;
  int get gameTime => _gameTime.value;

  List<MemoryCard> get cards => _cards;
  List<int> get flippedCards => _flippedCards;
  bool get canFlipCards => _canFlipCards.value;
  int get matchedPairs => _matchedPairs.value;

  // Add TTS and API constants
  static const String RANDOM_WORD_API_URL =
      'https://random-word-api-eight.vercel.app/word/multiple';
  static const String DICTIONARY_API_URL =
      'https://api.dictionaryapi.dev/api/v2/entries/en';

  late FlutterTts _flutterTts;
  final _isLoadingWords = false.obs;

  // Getters for loading state
  bool get isLoadingWords => _isLoadingWords.value;

  @override
  void onInit() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    _initializeTts();
    super.onInit();
  }

  void _initializeTts() {
    _flutterTts = FlutterTts();
    _flutterTts.setLanguage('en-US');
    _flutterTts.setSpeechRate(0.6);
    _flutterTts.setVolume(1.0);
    _flutterTts.setPitch(1.0);
  }

  Future<void> playPronunciation(String word) async {
    try {
      await _flutterTts.speak(word);
    } catch (e) {
      print('Error playing pronunciation: $e');
    }
  }

  void setDifficulty(MemoryDifficulty difficulty) {
    _selectedDifficulty.value = difficulty;
  }

  Future<void> startGame() async {
    // Set state to loading first
    _gameState.value = GameState.loading;
    _isLoading.value = true;

    // Reset game values
    _gameStarted.value = true;
    _gameInProgress.value = false; // Don't start until cards are ready
    _gameFinished.value = false;
    _showResult.value = false;
    _timerActive.value = false;
    _score.value = 0;
    _attempts.value = 0;
    _correctAttempts.value = 0;
    _round.value = 1;
    _currentRound.value = 0;
    _matchedPairs.value = 0;

    // Set game time based on difficulty
    switch (_selectedDifficulty.value) {
      case MemoryDifficulty.easy:
        _gameTime.value = 180; // 3 minutes
        break;
      case MemoryDifficulty.medium:
        _gameTime.value = 150; // 2.5 minutes
        break;
      case MemoryDifficulty.hard:
        _gameTime.value = 120; // 2 minutes
        break;
    }

    try {
      await _generateGame();

      print('Cards generated: ${_cards.length}');

      if (_cards.isNotEmpty) {
        // Now start the actual game
        _gameState.value = GameState.playing;
        _gameInProgress.value = true;
        _timerActive.value = true;
        _isLoading.value = false;
        _startCurrentRound();
      } else {
        // Force fallback card generation if no cards were created
        print('No cards generated, using fallback');
        _generateFallbackCardsForCurrentDifficulty();

        if (_cards.isNotEmpty) {
          _gameState.value = GameState.playing;
          _gameInProgress.value = true;
          _timerActive.value = true;
          _isLoading.value = false;
          _startCurrentRound();
        } else {
          // Fallback if no cards generated
          _gameState.value = GameState.setup;
          _gameStarted.value = false;
          _isLoading.value = false;
          Get.snackbar(
            'Error',
            'Unable to load game data. Please try again.',
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      }
    } catch (e) {
      print('Error starting game: $e');
      _gameState.value = GameState.setup;
      _gameStarted.value = false;
      _isLoading.value = false;
      Get.snackbar(
        'Error',
        'Failed to start game. Please check your connection.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void pauseGame() {
    _gameInProgress.value = false;
    _timerActive.value = false;
    _gameTimer?.cancel();
  }

  void resumeGame() {
    _gameInProgress.value = true;
    _timerActive.value = true;
    _gameTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_gameTime.value > 0 && !_gameInProgress.value) {
        timer.cancel();
      } else if (_gameTime.value > 0) {
        _gameTime.value--;
      } else {
        timer.cancel();
        _gameOver(false);
      }
    });
  }

  void _startCurrentRound() {
    _startCardMatchingRound();
  }

  void _startCardMatchingRound() {
    // Cards should already be generated at this point
    _canFlipCards.value = true;
    _flippedCards.clear();

    // Start timer
    _gameTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_gameTime.value > 0 && _gameInProgress.value) {
        _gameTime.value--;
      } else if (_gameTime.value == 0) {
        timer.cancel();
        _gameOver(false);
      }
    });
  }

  // Card matching game methods
  void flipCard(int cardIndex) {
    if (!_canFlipCards.value ||
        _cards[cardIndex].isFlipped ||
        _cards[cardIndex].isMatched ||
        _flippedCards.length >= 2) return;

    _cards[cardIndex].isFlipped = true;
    _flippedCards.add(cardIndex);
    _cards.refresh();

    if (_flippedCards.length == 2) {
      _canFlipCards.value = false;
      _checkMatch();
    }
  }

  void _checkMatch() {
    final card1 = _cards[_flippedCards[0]];
    final card2 = _cards[_flippedCards[1]];

    // Check if they have the same pairId and different types (word vs phonetic)
    if (card1.pairId == card2.pairId && card1.type != card2.type) {
      // Match found - word matches its phonetic
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

  void _gameComplete() {
    _gameState.value = GameState.finished;
    _gameFinished.value = true;
    _gameInProgress.value = false;
    _timerActive.value = false;
    _gameTimer?.cancel();

    // Bonus points for time remaining
    _score.value += _gameTime.value;

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

  void resetGame() {
    _gameState.value = GameState.setup;
    _gameStarted.value = false;
    _gameFinished.value = false;
    _gameInProgress.value = false;
    _currentRound.value = 0;
    _score.value = 0;
    _attempts.value = 0;
    _correctAttempts.value = 0;
    _showResult.value = false;
    _timerActive.value = false;
    _matchedPairs.value = 0;
    _isLoading.value = false;

    _cards.clear();
    _flippedCards.clear();
    _gameTimer?.cancel();
  }

  Future<void> _generateGame() async {
    _isLoading.value = true;
    await _generateCardMatchingGame();
    _isLoading.value = false;
  }

  Future<List<String>> _fetchRandomWords(int count) async {
    try {
      final response = await http.get(
        Uri.parse(
            '$RANDOM_WORD_API_URL/$count/types?types=noun,verb,adjective'),
        headers: {'Accept': 'application/json'},
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data
            .map((item) => RandomWordResponse.fromJson(item).word)
            .toList();
      } else {
        throw Exception('Failed to fetch words: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching random words: $e');
      // Fallback words if API fails
      return _getFallbackWords(count);
    }
  }

  List<String> _getFallbackWords(int count) {
    final fallbackWords = [
      'cat',
      'dog',
      'bird',
      'fish',
      'tree',
      'house',
      'car',
      'book',
      'run',
      'jump',
      'sing',
      'dance',
      'happy',
      'sad',
      'big',
      'small',
      'red',
      'blue',
      'green',
      'yellow',
      'sun',
      'moon',
      'star',
      'water',
      'fire',
      'earth',
      'wind',
      'love',
      'hope',
      'dream',
      'play',
      'work'
    ];
    fallbackWords.shuffle();
    return fallbackWords.take(count).toList();
  }

  Future<WordData> _fetchWordPronunciation(String word) async {
    try {
      final response = await http.get(
        Uri.parse('$DICTIONARY_API_URL/$word'),
        headers: {'Accept': 'application/json'},
      ).timeout(const Duration(seconds: 8));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        if (data.isNotEmpty) {
          final wordEntry = data[0];
          String pronunciation = '';
          String phonetic = '';

          // Try to get phonetic transcription
          if (wordEntry['phonetic'] != null) {
            phonetic = wordEntry['phonetic'];
          }

          // Try to get pronunciation from phonetics array
          if (wordEntry['phonetics'] != null) {
            final phonetics = wordEntry['phonetics'] as List;
            for (var phoneticEntry in phonetics) {
              if (phoneticEntry['text'] != null &&
                  phoneticEntry['text'].toString().isNotEmpty) {
                phonetic = phoneticEntry['text'];
                break;
              }
            }
          }

          return WordData(
            word: word,
            pronunciation: pronunciation,
            phonetic: phonetic.isNotEmpty ? phonetic : '/$word/',
          );
        }
      }
    } catch (e) {
      print('Error fetching pronunciation for $word: $e');
    }

    // Return fallback data
    return WordData(
      word: word,
      pronunciation: '',
      phonetic: '/$word/',
    );
  }

  Future<void> _generateCardPairs() async {
    _cards.clear();
    _isLoadingWords.value = true;

    int pairCount;
    switch (_selectedDifficulty.value) {
      case MemoryDifficulty.easy:
        pairCount = 6; // 12 cards total
        break;
      case MemoryDifficulty.medium:
        pairCount = 8; // 16 cards total
        break;
      case MemoryDifficulty.hard:
        pairCount = 12; // 24 cards total
        break;
    }

    try {
      // Fetch random words
      final words = await _fetchRandomWords(pairCount);
      print('Fetched words: $words');

      // Fetch pronunciations for each word
      final List<WordData> wordDataList = [];
      for (String word in words) {
        final wordData = await _fetchWordPronunciation(word);
        wordDataList.add(wordData);
      }

      print('Word data list length: ${wordDataList.length}');

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

      for (int i = 0; i < wordDataList.length; i++) {
        final wordData = wordDataList[i];
        final color = colors[i % colors.length];

        // Create word card
        cardPairs.add(MemoryCard(
          id: i * 2,
          pairId: i,
          content: wordData.word,
          word: wordData.word,
          pronunciation: wordData.pronunciation,
          phonetic: wordData.phonetic,
          type: CardType.word,
          color: color,
        ));

        // Create phonetic card
        cardPairs.add(MemoryCard(
          id: i * 2 + 1,
          pairId: i,
          content: wordData.phonetic,
          word: wordData.word,
          pronunciation: wordData.pronunciation,
          phonetic: wordData.phonetic,
          type: CardType.phonetic,
          color: color,
        ));
      }

      final random = Random();
      cardPairs.shuffle(random);
      _cards.value = cardPairs;

      print('Total cards generated: ${_cards.length}');
    } catch (e) {
      print('Error generating card pairs: $e');
      // Use fallback words if everything fails
      _generateFallbackCards(pairCount);
      print('Fallback cards generated: ${_cards.length}');
    } finally {
      _isLoadingWords.value = false;
    }
  }

  void _generateFallbackCards(int pairCount) {
    final fallbackWords = _getFallbackWords(pairCount);
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
    final random = Random();

    for (int i = 0; i < fallbackWords.length; i++) {
      final word = fallbackWords[i];
      final color = colors[i % colors.length];
      final phonetic = '/$word/';

      // Create word card
      cardPairs.add(MemoryCard(
        id: i * 2,
        pairId: i,
        content: word,
        word: word,
        pronunciation: '',
        phonetic: phonetic,
        type: CardType.word,
        color: color,
      ));

      // Create phonetic card
      cardPairs.add(MemoryCard(
        id: i * 2 + 1,
        pairId: i,
        content: phonetic,
        word: word,
        pronunciation: '',
        phonetic: phonetic,
        type: CardType.phonetic,
        color: color,
      ));
    }

    cardPairs.shuffle(random);
    _cards.addAll(cardPairs);
  }

  void _generateFallbackCardsForCurrentDifficulty() {
    int pairCount;
    switch (_selectedDifficulty.value) {
      case MemoryDifficulty.easy:
        pairCount = 6; // 12 cards total
        break;
      case MemoryDifficulty.medium:
        pairCount = 8; // 16 cards total
        break;
      case MemoryDifficulty.hard:
        pairCount = 12; // 24 cards total
        break;
    }
    _generateFallbackCards(pairCount);
  }

  Future<void> _generateCardMatchingGame() async {
    await _generateCardPairs();
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
