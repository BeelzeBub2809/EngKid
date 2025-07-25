import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum MemoryGameType {
  cardMatching,
  sequenceMemory,
  wordMemory,
  colorPattern,
  numberSequence,
}

enum MemoryDifficulty {
  easy,
  medium,
  hard,
}

class MemoryCard {
  final int id;
  final String content;
  final Color color;
  bool isFlipped;
  bool isMatched;
  bool isVisible;

  MemoryCard({
    required this.id,
    required this.content,
    required this.color,
    this.isFlipped = false,
    this.isMatched = false,
    this.isVisible = true,
  });

  MemoryCard copyWith({
    int? id,
    String? content,
    Color? color,
    bool? isFlipped,
    bool? isMatched,
    bool? isVisible,
  }) {
    return MemoryCard(
      id: id ?? this.id,
      content: content ?? this.content,
      color: color ?? this.color,
      isFlipped: isFlipped ?? this.isFlipped,
      isMatched: isMatched ?? this.isMatched,
      isVisible: isVisible ?? this.isVisible,
    );
  }
}

class SequenceItem {
  final int index;
  final String content;
  final Color color;
  bool isHighlighted;

  SequenceItem({
    required this.index,
    required this.content,
    required this.color,
    this.isHighlighted = false,
  });
}

class MemoryGameController extends GetxController with WidgetsBindingObserver {
  // Game state observables
  final RxBool _isLoading = false.obs;
  final RxBool _gameStarted = false.obs;
  final RxBool _gameFinished = false.obs;
  final RxBool _showResult = false.obs;
  final RxBool _timerActive = false.obs;
  final RxBool _gameInProgress = false.obs;

  // Game configuration
  final Rx<MemoryGameType> _selectedGameType = MemoryGameType.cardMatching.obs;
  final Rx<MemoryDifficulty> _selectedDifficulty = MemoryDifficulty.easy.obs;
  final RxInt _gameTimeLimit = 60.obs; // seconds
  final RxInt _rounds = 5.obs;

  // Current game state
  final RxInt _currentRound = 0.obs;
  final RxInt _score = 0.obs;
  final RxInt _timeRemaining = 0.obs;
  final RxInt _attempts = 0.obs;
  final RxInt _correctAttempts = 0.obs;

  // Card matching game
  final RxList<MemoryCard> _cards = <MemoryCard>[].obs;
  final RxList<int> _flippedCards = <int>[].obs;
  final RxBool _canFlipCards = true.obs;

  // Sequence memory game
  final RxList<SequenceItem> _sequence = <SequenceItem>[].obs;
  final RxList<int> _playerSequence = <int>[].obs;
  final RxBool _showingSequence = false.obs;
  final RxBool _waitingForInput = false.obs;
  final RxInt _sequenceStep = 0.obs;

  // Word/Pattern memory
  final RxList<String> _wordsToMemorize = <String>[].obs;
  final RxList<String> _availableWords = <String>[].obs;
  final RxList<String> _selectedWords = <String>[].obs;
  final RxBool _showMemoryItems = false.obs;
  final RxInt _memoryTime = 5.obs; // seconds to memorize

  Timer? _gameTimer;
  Timer? _sequenceTimer;
  Timer? _memoryTimer;

  // Getters
  bool get isLoading => _isLoading.value;
  bool get gameStarted => _gameStarted.value;
  bool get gameFinished => _gameFinished.value;
  bool get showResult => _showResult.value;
  bool get timerActive => _timerActive.value;
  bool get gameInProgress => _gameInProgress.value;

  MemoryGameType get selectedGameType => _selectedGameType.value;
  MemoryDifficulty get selectedDifficulty => _selectedDifficulty.value;
  int get gameTimeLimit => _gameTimeLimit.value;
  int get rounds => _rounds.value;

  int get currentRound => _currentRound.value;
  int get score => _score.value;
  int get timeRemaining => _timeRemaining.value;
  int get attempts => _attempts.value;
  int get correctAttempts => _correctAttempts.value;

  // Card matching getters
  List<MemoryCard> get cards => _cards;
  List<int> get flippedCards => _flippedCards;
  bool get canFlipCards => _canFlipCards.value;

  // Sequence memory getters
  List<SequenceItem> get sequence => _sequence;
  List<int> get playerSequence => _playerSequence;
  bool get showingSequence => _showingSequence.value;
  bool get waitingForInput => _waitingForInput.value;
  int get sequenceStep => _sequenceStep.value;

  // Word memory getters
  List<String> get wordsToMemorize => _wordsToMemorize;
  List<String> get availableWords => _availableWords;
  List<String> get selectedWords => _selectedWords;
  bool get showMemoryItems => _showMemoryItems.value;
  int get memoryTime => _memoryTime.value;

  double get progress => rounds > 0 ? (_currentRound.value + 1) / rounds : 0.0;
  double get accuracy => attempts > 0 ? correctAttempts / attempts : 0.0;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    _generateGame();
  }

  @override
  void onClose() {
    _gameTimer?.cancel();
    _sequenceTimer?.cancel();
    _memoryTimer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.onClose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      pauseGame();
    }
  }

  // Game configuration methods
  void setGameType(MemoryGameType type) {
    _selectedGameType.value = type;
    if (!_gameStarted.value) {
      _generateGame();
    }
  }

  void setDifficulty(MemoryDifficulty difficulty) {
    _selectedDifficulty.value = difficulty;
    if (!_gameStarted.value) {
      _generateGame();
    }
  }

  void setTimeLimit(int seconds) {
    _gameTimeLimit.value = seconds;
  }

  void setRounds(int roundCount) {
    _rounds.value = roundCount;
  }

  // Game control methods
  void startGame() {
    if (_cards.isEmpty && _sequence.isEmpty && _wordsToMemorize.isEmpty) {
      _generateGame();
    }

    _gameStarted.value = true;
    _gameFinished.value = false;
    _gameInProgress.value = true;
    _currentRound.value = 0;
    _score.value = 0;
    _attempts.value = 0;
    _correctAttempts.value = 0;
    _showResult.value = false;

    if (_gameTimeLimit.value > 0) {
      _startTimer();
    }

    _startCurrentRound();
  }

  void pauseGame() {
    _timerActive.value = false;
    _gameTimer?.cancel();
    _sequenceTimer?.cancel();
    _memoryTimer?.cancel();
  }

  void resumeGame() {
    if (_gameStarted.value &&
        !_gameFinished.value &&
        _gameTimeLimit.value > 0) {
      _startTimer();
    }
  }

  void _startTimer() {
    _timeRemaining.value = _gameTimeLimit.value;
    _timerActive.value = true;

    _gameTimer?.cancel();
    _gameTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeRemaining.value > 0) {
        _timeRemaining.value--;
      } else {
        _endGame();
        timer.cancel();
      }
    });
  }

  void _startCurrentRound() {
    switch (_selectedGameType.value) {
      case MemoryGameType.cardMatching:
        _startCardMatchingRound();
        break;
      case MemoryGameType.sequenceMemory:
        _startSequenceRound();
        break;
      case MemoryGameType.wordMemory:
        _startWordMemoryRound();
        break;
      case MemoryGameType.colorPattern:
        _startColorPatternRound();
        break;
      case MemoryGameType.numberSequence:
        _startNumberSequenceRound();
        break;
    }
  }

  void _startCardMatchingRound() {
    _generateCardMatchingGame();
    _canFlipCards.value = true;
    _flippedCards.clear();
  }

  void _startSequenceRound() {
    _generateSequenceGame();
    _playerSequence.clear();
    _showingSequence.value = true;
    _waitingForInput.value = false;
    _showSequence();
  }

  void _startWordMemoryRound() {
    _generateWordMemoryGame();
    _selectedWords.clear();
    _showMemoryItems.value = true;
    _startMemoryTimer();
  }

  void _startColorPatternRound() {
    _generateColorPatternGame();
    _playerSequence.clear();
    _showingSequence.value = true;
    _waitingForInput.value = false;
    _showSequence();
  }

  void _startNumberSequenceRound() {
    _generateNumberSequenceGame();
    _playerSequence.clear();
    _showingSequence.value = true;
    _waitingForInput.value = false;
    _showSequence();
  }

  void _showSequence() {
    _sequenceStep.value = 0;
    _sequenceTimer?.cancel();

    _sequenceTimer = Timer.periodic(const Duration(milliseconds: 800), (timer) {
      if (_sequenceStep.value < _sequence.length) {
        // Highlight current item
        for (int i = 0; i < _sequence.length; i++) {
          _sequence[i].isHighlighted = i == _sequenceStep.value;
        }
        _sequence.refresh();
        _sequenceStep.value++;
      } else {
        // Clear all highlights
        for (var item in _sequence) {
          item.isHighlighted = false;
        }
        _sequence.refresh();
        _showingSequence.value = false;
        _waitingForInput.value = true;
        timer.cancel();
      }
    });
  }

  void _startMemoryTimer() {
    _memoryTimer?.cancel();
    _memoryTimer = Timer(Duration(seconds: _memoryTime.value), () {
      _showMemoryItems.value = false;
      _waitingForInput.value = true;
    });
  }

  // Card matching game methods
  void flipCard(int cardIndex) {
    if (!_canFlipCards.value ||
        _cards[cardIndex].isFlipped ||
        _cards[cardIndex].isMatched) {
      return;
    }

    _cards[cardIndex] = _cards[cardIndex].copyWith(isFlipped: true);
    _flippedCards.add(cardIndex);

    if (_flippedCards.length == 2) {
      _canFlipCards.value = false;
      _attempts.value++;

      Future.delayed(const Duration(milliseconds: 1000), () {
        _checkCardMatch();
      });
    }
  }

  void _checkCardMatch() {
    final card1 = _cards[_flippedCards[0]];
    final card2 = _cards[_flippedCards[1]];

    if (card1.content == card2.content) {
      // Match found
      _cards[_flippedCards[0]] = card1.copyWith(isMatched: true);
      _cards[_flippedCards[1]] = card2.copyWith(isMatched: true);
      _correctAttempts.value++;
      _score.value += 10;

      // Check if all cards are matched
      if (_cards.every((card) => card.isMatched)) {
        _nextRound();
      }
    } else {
      // No match, flip cards back
      _cards[_flippedCards[0]] = card1.copyWith(isFlipped: false);
      _cards[_flippedCards[1]] = card2.copyWith(isFlipped: false);
    }

    _flippedCards.clear();
    _canFlipCards.value = true;
  }

  // Sequence game methods
  void addToPlayerSequence(int index) {
    if (!_waitingForInput.value) return;

    _playerSequence.add(index);

    // Check if current input is correct
    final currentIndex = _playerSequence.length - 1;
    if (_playerSequence[currentIndex] != _sequence[currentIndex].index) {
      // Wrong sequence
      _attempts.value++;
      _showResult.value = true;
      Future.delayed(const Duration(seconds: 1), () {
        _nextRound();
      });
      return;
    }

    // Check if sequence is complete
    if (_playerSequence.length == _sequence.length) {
      // Correct sequence completed
      _correctAttempts.value++;
      _attempts.value++;
      _score.value += 15;
      _showResult.value = true;
      Future.delayed(const Duration(seconds: 1), () {
        _nextRound();
      });
    }
  }

  // Word memory methods
  void selectWord(String word) {
    if (!_waitingForInput.value) return;

    if (_selectedWords.contains(word)) {
      _selectedWords.remove(word);
    } else {
      _selectedWords.add(word);
    }
  }

  void submitWordSelection() {
    if (!_waitingForInput.value) return;

    _attempts.value++;
    final correctWords = _wordsToMemorize.toSet();
    final selectedWordsSet = _selectedWords.toSet();

    final correctSelections =
        correctWords.intersection(selectedWordsSet).length;
    final totalCorrect = correctWords.length;

    if (correctSelections == totalCorrect &&
        selectedWordsSet.length == totalCorrect) {
      _correctAttempts.value++;
      _score.value += 20;
    }

    _showResult.value = true;
    Future.delayed(const Duration(seconds: 2), () {
      _nextRound();
    });
  }

  void _nextRound() {
    _showResult.value = false;
    _waitingForInput.value = false;

    if (_currentRound.value < _rounds.value - 1) {
      _currentRound.value++;
      _startCurrentRound();
    } else {
      _endGame();
    }
  }

  void _endGame() {
    _gameFinished.value = true;
    _gameInProgress.value = false;
    _timerActive.value = false;
    _gameTimer?.cancel();
    _sequenceTimer?.cancel();
    _memoryTimer?.cancel();

    // Show final results
    Get.dialog(
      _buildResultDialog(),
      barrierDismissible: false,
    );
  }

  Widget _buildResultDialog() {
    final percentage = (accuracy * 100).round();

    return AlertDialog(
      title: const Text('Game Complete!'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Final Score: $score points'),
          Text('Accuracy: ${correctAttempts}/${attempts} (${percentage}%)'),
          Text('Rounds Completed: ${currentRound + 1}/$rounds'),
          const SizedBox(height: 16),
          Text(_getPerformanceMessage(percentage)),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Get.back(); // Close dialog
            resetGame();
          },
          child: const Text('Play Again'),
        ),
        TextButton(
          onPressed: () {
            Get.back(); // Close dialog
            Get.back(); // Return to previous screen
          },
          child: const Text('Exit'),
        ),
      ],
    );
  }

  String _getPerformanceMessage(int percentage) {
    if (percentage >= 90) return 'Amazing Memory! 🧠✨';
    if (percentage >= 75) return 'Great Memory Skills! 🎯';
    if (percentage >= 60) return 'Good Memory Work! 👍';
    if (percentage >= 40) return 'Keep Training! 💪';
    return 'Practice Makes Perfect! 🎯';
  }

  void resetGame() {
    _gameStarted.value = false;
    _gameFinished.value = false;
    _gameInProgress.value = false;
    _currentRound.value = 0;
    _score.value = 0;
    _attempts.value = 0;
    _correctAttempts.value = 0;
    _showResult.value = false;
    _timerActive.value = false;
    _waitingForInput.value = false;
    _showingSequence.value = false;
    _showMemoryItems.value = false;

    _cards.clear();
    _sequence.clear();
    _wordsToMemorize.clear();
    _selectedWords.clear();
    _playerSequence.clear();
    _flippedCards.clear();

    _generateGame();
  }

  void _generateGame() {
    _isLoading.value = true;

    switch (_selectedGameType.value) {
      case MemoryGameType.cardMatching:
        _generateCardMatchingGame();
        break;
      case MemoryGameType.sequenceMemory:
        _generateSequenceGame();
        break;
      case MemoryGameType.wordMemory:
        _generateWordMemoryGame();
        break;
      case MemoryGameType.colorPattern:
        _generateColorPatternGame();
        break;
      case MemoryGameType.numberSequence:
        _generateNumberSequenceGame();
        break;
    }

    _isLoading.value = false;
  }

  void _generateCardMatchingGame() {
    _cards.clear();
    final random = Random();

    int pairCount;
    switch (_selectedDifficulty.value) {
      case MemoryDifficulty.easy:
        pairCount = 6; // 3x4 grid
        break;
      case MemoryDifficulty.medium:
        pairCount = 8; // 4x4 grid
        break;
      case MemoryDifficulty.hard:
        pairCount = 12; // 4x6 grid
        break;
    }

    final emojis = [
      '🐶',
      '🐱',
      '🐭',
      '🐹',
      '🐰',
      '🦊',
      '🐻',
      '🐼',
      '🐨',
      '🐯',
      '🦁',
      '🐮'
    ];
    final colors = [
      Colors.red,
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.pink
    ];

    List<MemoryCard> cardPairs = [];
    for (int i = 0; i < pairCount; i++) {
      final content = emojis[i % emojis.length];
      final color = colors[i % colors.length];

      cardPairs.add(MemoryCard(id: i * 2, content: content, color: color));
      cardPairs.add(MemoryCard(id: i * 2 + 1, content: content, color: color));
    }

    cardPairs.shuffle(random);
    _cards.addAll(cardPairs);
  }

  void _generateSequenceGame() {
    _sequence.clear();
    final random = Random();

    int sequenceLength;
    switch (_selectedDifficulty.value) {
      case MemoryDifficulty.easy:
        sequenceLength = 4;
        break;
      case MemoryDifficulty.medium:
        sequenceLength = 6;
        break;
      case MemoryDifficulty.hard:
        sequenceLength = 8;
        break;
    }

    final colors = [
      Colors.red,
      Colors.blue,
      Colors.green,
      Colors.yellow,
      Colors.purple,
      Colors.orange
    ];
    final gridSize = 6; // 2x3 or 3x2 grid

    for (int i = 0; i < sequenceLength; i++) {
      final index = random.nextInt(gridSize);
      final color = colors[index % colors.length];
      _sequence.add(SequenceItem(
        index: index,
        content: '${index + 1}',
        color: color,
      ));
    }
  }

  void _generateWordMemoryGame() {
    _wordsToMemorize.clear();
    _availableWords.clear();

    int wordCount;
    switch (_selectedDifficulty.value) {
      case MemoryDifficulty.easy:
        wordCount = 5;
        _memoryTime.value = 8;
        break;
      case MemoryDifficulty.medium:
        wordCount = 7;
        _memoryTime.value = 6;
        break;
      case MemoryDifficulty.hard:
        wordCount = 10;
        _memoryTime.value = 5;
        break;
    }

    final allWords = [
      'APPLE',
      'BANANA',
      'ORANGE',
      'GRAPE',
      'MANGO',
      'PEACH',
      'PEAR',
      'CHERRY',
      'LEMON',
      'LIME',
      'PLUM',
      'BERRY',
      'MELON',
      'KIWI',
      'PAPAYA',
      'COCONUT',
      'HOUSE',
      'TREE',
      'FLOWER',
      'MOUNTAIN',
      'RIVER',
      'OCEAN',
      'STAR',
      'MOON',
      'SUN',
      'CLOUD',
      'RAIN',
      'SNOW',
      'WIND',
      'FIRE',
      'EARTH',
      'WATER'
    ];

    allWords.shuffle();
    _wordsToMemorize.addAll(allWords.take(wordCount));

    // Add some extra words as distractors
    final remainingWords =
        allWords.skip(wordCount).take(wordCount * 2).toList();
    _availableWords.addAll(_wordsToMemorize);
    _availableWords.addAll(remainingWords);
    _availableWords.shuffle();
  }

  void _generateColorPatternGame() {
    _sequence.clear();
    final random = Random();

    int patternLength;
    switch (_selectedDifficulty.value) {
      case MemoryDifficulty.easy:
        patternLength = 4;
        break;
      case MemoryDifficulty.medium:
        patternLength = 6;
        break;
      case MemoryDifficulty.hard:
        patternLength = 8;
        break;
    }

    final colors = [
      Colors.red,
      Colors.blue,
      Colors.green,
      Colors.yellow,
      Colors.purple,
      Colors.orange,
      Colors.pink,
      Colors.cyan
    ];

    for (int i = 0; i < patternLength; i++) {
      final colorIndex = random.nextInt(colors.length);
      _sequence.add(SequenceItem(
        index: colorIndex,
        content: '',
        color: colors[colorIndex],
      ));
    }
  }

  void _generateNumberSequenceGame() {
    _sequence.clear();
    final random = Random();

    int sequenceLength;
    switch (_selectedDifficulty.value) {
      case MemoryDifficulty.easy:
        sequenceLength = 5;
        break;
      case MemoryDifficulty.medium:
        sequenceLength = 7;
        break;
      case MemoryDifficulty.hard:
        sequenceLength = 10;
        break;
    }

    for (int i = 0; i < sequenceLength; i++) {
      final number = random.nextInt(9) + 1; // 1-9
      _sequence.add(SequenceItem(
        index: number - 1,
        content: number.toString(),
        color: Colors.blue,
      ));
    }
  }
}
