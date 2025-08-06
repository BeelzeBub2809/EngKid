import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;
import 'package:EngKid/utils/lib_function.dart';
import 'package:EngKid/widgets/dialog/dialog_wordle_result.dart';
import 'package:EngKid/widgets/dialog/dialog_word_definition.dart';

enum LetterStatus { correct, wrongPosition, notInWord, empty }

class WordleLetter {
  final String letter;
  final LetterStatus status;

  WordleLetter({required this.letter, required this.status});
}

class WordleGameController extends GetxController {
  final dio.Dio _dio = dio.Dio();
  // ignore: constant_identifier_names
  static const List<String> API_URLS = [
    'https://random-word-api-eight.vercel.app/word/english/noun',
    'https://random-word-api-eight.vercel.app/word/english/verb',
    'https://random-word-api-eight.vercel.app/word/english/adjective',
  ];
  // ignore: constant_identifier_names
  static const String DICTIONARY_API_URL =
      'https://api.dictionaryapi.dev/api/v2/entries/en';

  // Game state
  final RxString _targetWord = ''.obs;
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
    startNewGame();
  }

  Future<String?> _fetchRandomWord() async {
    try {
      _isLoading.value = true;

      // Randomly select one of the API endpoints
      final random = DateTime.now().millisecondsSinceEpoch % API_URLS.length;
      final selectedApiUrl = API_URLS[random];

      debugPrint('Fetching word from: $selectedApiUrl');
      final response = await _dio.get(selectedApiUrl);
      if (response.statusCode == 200) {
        print('API Response: ${response.data}');

        // Handle the new API response format: {"word": "Kemp", "definition": "...", "pronunciation": "..."}
        String word = '';
        if (response.data is Map<String, dynamic> &&
            response.data['word'] != null) {
          word = response.data['word'].toString().toUpperCase();
        }

        if (word.isNotEmpty) {
          return word;
        }
      }
      return null;
    } catch (e) {
      debugPrint('Error fetching random word: $e');
      return null;
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> startNewGame() async {
    _isLoading.value = true;

    // Try to get word from API, fallback to default words if failed
    String? apiWord = await _fetchRandomWord();

    if (apiWord != null) {
      _targetWord.value = apiWord;
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

  void _submitGuess() {
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

  void showHint() {
    if (_gameFinished.value) return;

    String hint = _targetWord.value[0]; // Show first letter as hint
    LibFunction.toast('Hint: Word starts with "$hint"');
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

  void _showResultDialog() {
    Get.dialog(
      DialogWordleResult(
        gameWon: _gameWon.value,
        attempts: _currentRow.value,
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
