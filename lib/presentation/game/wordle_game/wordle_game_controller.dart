import 'package:EngKid/presentation/core/topic_service.dart';
import 'package:EngKid/presentation/core/user_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;
import 'package:flutter_tts/flutter_tts.dart';
import 'package:EngKid/utils/lib_function.dart';
import 'package:EngKid/widgets/dialog/dialog_wordle_result.dart';
import 'package:EngKid/widgets/dialog/dialog_word_definition.dart';
import '../../../domain/entities/word/word_entity.dart';
import '../../../domain/word/get_words_by_game_id_usecase.dart';

enum LetterStatus { correct, wrongPosition, notInWord, empty }

class WordleLetter {
  final String letter;
  final LetterStatus status;

  WordleLetter({required this.letter, required this.status});
}

class WordleGameController extends GetxController {
  final dio.Dio _dio = dio.Dio();
  late FlutterTts _flutterTts;
  final GetWordsByGameIdUseCase _getWordsByGameIdUseCase;

  // Game data from navigation arguments
  Map<String, dynamic>? _gameData;
  int get gameId => _gameData?['game_id'] ?? 2;
  int get learningPathId => _gameData?['learning_path_id'] ?? 1;

  // ignore: constant_identifier_names
  static const String DICTIONARY_API_URL =
      'https://api.dictionaryapi.dev/api/v2/entries/en';

  // Constructor with dependency injection
  WordleGameController(this._getWordsByGameIdUseCase);

  final TopicService _topicService = Get.find<TopicService>();
  final UserService _userService = Get.find<UserService>();

  // Game state
  final RxString _targetWord = ''.obs;
  final RxString _targetWordImageUrl = ''.obs;
  final RxString _targetWordDefinition = ''.obs;
  final RxList<WordEntity> _gameWords = <WordEntity>[].obs;
  final RxList<List<WordleLetter>> _guesses = <List<WordleLetter>>[].obs;
  final RxInt _currentRow = 0.obs;
  final RxInt _currentCol = 0.obs;
  final RxBool _gameFinished = false.obs;
  final RxBool _gameWon = false.obs;
  final RxString _currentGuess = ''.obs;
  final RxBool _isKeyboardVisible = false.obs;
  final RxBool _isLoading = false.obs;
  final RxBool _isLoadingDefinition = false.obs;

  // Getters
  String get targetWord => _targetWord.value;
  String get targetWordImageUrl => _targetWordImageUrl.value;
  String get targetWordDefinition => _targetWordDefinition.value;
  List<List<WordleLetter>> get guesses => _guesses;
  int get currentRow => _currentRow.value;
  int get currentCol => _currentCol.value;
  bool get gameFinished => _gameFinished.value;
  bool get gameWon => _gameWon.value;
  String get currentGuess => _currentGuess.value;
  bool get isKeyboardVisible => _isKeyboardVisible.value;
  bool get isLoading => _isLoading.value;
  bool get isLoadingDefinition => _isLoadingDefinition.value;

  int get wordLength => _targetWord.value.length;
  int get maxAttempts => 6;

  @override
  void onInit() {
    super.onInit();
    _gameData = Get.arguments as Map<String, dynamic>?;
    _initTts();
    startNewGame();
  }

  void _initTts() async {
    _flutterTts = FlutterTts();
    await _flutterTts.setLanguage('en-US');
    await _flutterTts.setSpeechRate(0.5);
    await _flutterTts.setVolume(1.0);
    await _flutterTts.setPitch(1.0);
  }

  Future<void> _loadWordsFromAPI() async {
    try {
      _isLoading.value = true;

      // Fetch words from API using game ID
      final fetchedWords = await _getWordsByGameIdUseCase.call(gameId);
      _gameWords.value = fetchedWords;
      print(
          'Loaded ${_gameWords.length} words from API for Wordle game (ID: $gameId)');

      if (_gameWords.isEmpty) {
        throw Exception('No words found for Wordle game (ID: $gameId)');
      }
    } catch (e) {
      print('Error loading words from API: $e');
      _gameWords.clear();
    } finally {
      _isLoading.value = false;
    }
  }

  WordEntity? _selectRandomWord() {
    if (_gameWords.isEmpty) return null;

    final random = DateTime.now().millisecondsSinceEpoch % _gameWords.length;
    return _gameWords[random];
  }

  Future<void> startNewGame() async {
    _isLoading.value = true;

    // Load words from API first
    await _loadWordsFromAPI();

    // Try to get random word from loaded words
    WordEntity? selectedWord = _selectRandomWord();

    if (selectedWord != null) {
      _targetWord.value = selectedWord.word.toUpperCase();
      _targetWordImageUrl.value = selectedWord.image;
      _targetWordDefinition.value = selectedWord.note;

      print('Selected Wordle word: ${_targetWord.value}');
      print('Word image URL: ${_targetWordImageUrl.value}');
    } else {
      // Fallback words if API fails
      List<String> fallbackWords = [
        'HOUSE',
        'WORLD',
        'WATER',
        'LIGHT',
        'MUSIC',
        'DREAM',
        'PEACE',
        'SMILE',
        'HEART',
        'HAPPY',
        'BRAVE',
        'LEARN',
        'MAGIC',
        'STORM',
        'EARTH',
        'OCEAN'
      ];
      _targetWord.value = fallbackWords[
          DateTime.now().millisecondsSinceEpoch % fallbackWords.length];
      _targetWordImageUrl.value = '';
      _targetWordDefinition.value = '';
      LibFunction.toast('Using offline word (API unavailable)');
    }

    // Initialize guesses grid
    _guesses.clear();
    for (int i = 0; i < maxAttempts; i++) {
      _guesses.add(List.generate(
        wordLength,
        (index) => WordleLetter(letter: '', status: LetterStatus.empty),
      ));
    }

    _currentRow.value = 0;
    _currentCol.value = 0;
    _gameFinished.value = false;
    _gameWon.value = false;
    _currentGuess.value = '';
    _isLoading.value = false;

    debugPrint(
        'New Wordle game started. Target word: $_targetWord ($wordLength letters)');
  }

  Future<Map<String, dynamic>?> fetchWordDefinition(String word) async {
    try {
      _isLoadingDefinition.value = true;

      // Fetch definition and image concurrently
      final List<Future> futures = [
        _dio.get('$DICTIONARY_API_URL/${word.toLowerCase()}')
      ];

      final results = await Future.wait(futures);
      final definitionResponse = results[0] as dio.Response;

      if (definitionResponse.statusCode == 200 &&
          definitionResponse.data is List &&
          definitionResponse.data.isNotEmpty) {
        final wordData = definitionResponse.data[0];

        // Extract definition
        String definition = 'Definition not available';
        if (wordData['meanings'] != null && wordData['meanings'].isNotEmpty) {
          final meaning = wordData['meanings'][0];
          if (meaning['definitions'] != null &&
              meaning['definitions'].isNotEmpty) {
            definition = meaning['definitions'][0]['definition'] ??
                'Definition not available';
          }
        }

        // Extract pronunciation
        String pronunciation = 'Pronunciation not available';
        String audioUrl = '';
        if (wordData['phonetics'] != null && wordData['phonetics'].isNotEmpty) {
          for (var phonetic in wordData['phonetics']) {
            if (phonetic['text'] != null &&
                phonetic['text'].toString().isNotEmpty) {
              pronunciation = phonetic['text'];
              if (phonetic['audio'] != null &&
                  phonetic['audio'].toString().isNotEmpty) {
                audioUrl = phonetic['audio'];
                break;
              }
            }
          }
        }

        return {
          'word': word,
          'definition': definition,
          'pronunciation': pronunciation,
          'audioUrl': audioUrl,
          'partOfSpeech': wordData['meanings']?[0]?['partOfSpeech'] ?? 'Unknown'
        };
      }
      return null;
    } catch (e) {
      debugPrint('Error fetching word definition: $e');
      return null;
    } finally {
      _isLoadingDefinition.value = false;
    }
  }

  void showWordDefinition() async {
    if (_targetWord.value.isEmpty) return;
    LibFunction.showLoading();
    final wordInfo = await fetchWordDefinition(_targetWord.value);
    LibFunction.hideLoading();
    if (wordInfo != null) {
      Get.dialog(
        DialogWordDefinition(wordInfo: wordInfo),
        barrierDismissible: true,
      );
    } else {
      LibFunction.hideLoading();
      LibFunction.toast('Could not fetch word definition');
    }
  }

  void onKeyPressed(String key) {
    if (_gameFinished.value) return;

    if (key == 'ENTER') {
      _submitGuess();
    } else if (key == 'BACKSPACE') {
      _deleteLetter();
    } else if (key.length == 1 && key.contains(RegExp(r'[A-Z]'))) {
      _addLetter(key);
    }
  }

  void _addLetter(String letter) {
    if (_currentCol.value < wordLength) {
      _guesses[_currentRow.value][_currentCol.value] = WordleLetter(
        letter: letter,
        status: LetterStatus.empty,
      );
      _currentCol.value++;
      _currentGuess.value = _getCurrentRowWord();
    }
  }

  void _deleteLetter() {
    if (_currentCol.value > 0) {
      _currentCol.value--;
      _guesses[_currentRow.value][_currentCol.value] = WordleLetter(
        letter: '',
        status: LetterStatus.empty,
      );
      _currentGuess.value = _getCurrentRowWord();
    }
  }

  String _getCurrentRowWord() {
    return _guesses[_currentRow.value].map((letter) => letter.letter).join('');
  }

  Future<void> _submitGuess() async {
    if (_currentCol.value != wordLength) {
      LibFunction.toast('Complete the word first!');
      return;
    }

    String guess = _getCurrentRowWord();

    // Check if the guess is valid (you could add dictionary validation here)
    if (guess.length != wordLength) {
      LibFunction.toast('Invalid word length!');
      return;
    }

    // Update letter statuses
    _updateLetterStatuses(guess);

    // Check if won
    if (guess == _targetWord.value) {
      _gameWon.value = true;
      _gameFinished.value = true;
      _isKeyboardVisible.value = false; // Auto-close keyboard
      LibFunction.toast('Congratulations! You won!');
      await _topicService.submitGameResult(_userService.currentUser.id, null, 5,
          1, "00:00", learningPathId, gameId);
      // Show result dialog after a brief delay
      Future.delayed(const Duration(milliseconds: 500), () {
        _showResultDialog();
      });
      return;
    }

    // Move to next row
    _currentRow.value++;
    _currentCol.value = 0;
    _currentGuess.value = '';

    // Check if game over
    if (_currentRow.value >= maxAttempts) {
      _gameFinished.value = true;
      _isKeyboardVisible.value = false; // Auto-close keyboard
      LibFunction.toast('Game Over! The word was: ${_targetWord.value}');

      // Show result dialog after a brief delay
      Future.delayed(const Duration(milliseconds: 500), () {
        _showResultDialog();
      });
    }
  }

  void _updateLetterStatuses(String guess) {
    List<String> targetLetters = _targetWord.value.split('');
    List<String> guessLetters = guess.split('');
    List<bool> targetUsed = List.filled(targetLetters.length, false);
    List<LetterStatus> statuses =
        List.filled(guessLetters.length, LetterStatus.notInWord);

    // First pass: mark correct positions
    for (int i = 0; i < guessLetters.length; i++) {
      if (guessLetters[i] == targetLetters[i]) {
        statuses[i] = LetterStatus.correct;
        targetUsed[i] = true;
      }
    }

    // Second pass: mark wrong positions
    for (int i = 0; i < guessLetters.length; i++) {
      if (statuses[i] == LetterStatus.correct) continue;

      for (int j = 0; j < targetLetters.length; j++) {
        if (!targetUsed[j] && guessLetters[i] == targetLetters[j]) {
          statuses[i] = LetterStatus.wrongPosition;
          targetUsed[j] = true;
          break;
        }
      }
    }

    // Update the guess with correct statuses
    for (int i = 0; i < guessLetters.length; i++) {
      _guesses[_currentRow.value][i] = WordleLetter(
        letter: guessLetters[i],
        status: statuses[i],
      );
    }
  }

  Color getLetterColor(LetterStatus status) {
    switch (status) {
      case LetterStatus.correct:
        return Colors.green;
      case LetterStatus.wrongPosition:
        return Colors.orange;
      case LetterStatus.notInWord:
        return Colors.grey;
      case LetterStatus.empty:
        return Colors.white;
    }
  }

  Color getLetterBorderColor(LetterStatus status) {
    switch (status) {
      case LetterStatus.correct:
        return Colors.green;
      case LetterStatus.wrongPosition:
        return Colors.orange;
      case LetterStatus.notInWord:
        return Colors.grey;
      case LetterStatus.empty:
        return Colors.grey.shade300;
    }
  }

  void showHint() async {
    if (_gameFinished.value) return;

    // Speak the word
    await _flutterTts.speak(_targetWord.value);

    // Show image hint if available
    if (_targetWordImageUrl.value.isNotEmpty) {
      // Trigger image popup - this will be handled by UI
      Get.dialog(_buildImageHintDialog());
    } else {
      // Fallback to definition if no image
      if (_targetWordDefinition.value.isNotEmpty) {
        LibFunction.toast('Hint: ${_targetWordDefinition.value}');
      } else {
        LibFunction.toast('Hint: Listen to the pronunciation!');
      }
    }
  }

  Widget _buildImageHintDialog() {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: Get.height * 0.85,
          maxWidth: Get.width * 0.9,
          minHeight: Get.height * 0.4,
          minWidth: Get.width * 0.7,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Word Hint',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[700],
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Get.back(),
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.red[100],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Icon(
                          Icons.close,
                          size: 20,
                          color: Colors.red[700],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Image content
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Container(
                    constraints: BoxConstraints(
                      maxHeight: Get.height * 0.6,
                      maxWidth: Get.width * 0.7,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        _targetWordImageUrl.value,
                        fit: BoxFit.contain,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                  : null,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.blue[600]!),
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.error_outline,
                                  size: 48,
                                  color: Colors.grey[400],
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  'Failed to load hint image',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey[600],
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 8),
                                if (_targetWordDefinition.value.isNotEmpty)
                                  Text(
                                    _targetWordDefinition.value,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[700],
                                      fontStyle: FontStyle.italic,
                                    ),
                                    textAlign: TextAlign.center,
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void resetGame() {
    startNewGame();
  }

  void showKeyboard() {
    _isKeyboardVisible.value = true;
  }

  void hideKeyboard() {
    _isKeyboardVisible.value = false;
  }

  void toggleKeyboard() {
    _isKeyboardVisible.value = !_isKeyboardVisible.value;
  }

  @override
  void onClose() {
    _flutterTts.stop();
    super.onClose();
  }

  void _showResultDialog() {
    Get.dialog(
      DialogWordleResult(
        gameWon: _gameWon.value,
        attempts: _currentRow.value + 1,
        targetWord: _targetWord.value,
        onNewGame: () {
          Get.back(); // Close dialog
          resetGame();
        },
        onGoHome: () {
          Get.back(); // Close dialog
          Get.back(); // Go back to previous screen
        },
        onShowDefinition: () {
          showWordDefinition();
        },
      ),
      barrierDismissible: false, // Prevent dismissing by tapping outside
    );
  }
}
