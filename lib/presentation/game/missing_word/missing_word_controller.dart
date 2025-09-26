import 'dart:async';
import 'dart:math';
import 'dart:convert';
import 'package:EngKid/presentation/core/topic_service.dart';
import 'package:EngKid/presentation/core/user_service.dart';
import 'package:get/get.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:http/http.dart' as http;
import '../../../utils/lib_function.dart';
import '../../../utils/translation_service.dart';
import '../../../domain/entities/word/word_entity.dart';
import '../../../domain/word/get_words_by_game_id_usecase.dart';

enum MissingWordGameState { loading, playing, finished }

class WordData {
  final String word;
  final String imageUrl;
  final String pronunciation;

  WordData({
    required this.word,
    required this.imageUrl,
    required this.pronunciation,
  });
}

class MissingLetterData {
  final String word;
  final String imageUrl;
  final String pronunciation;
  final String definition;
  final List<int> missingIndices;
  final List<String> missingLetters;
  final String userInput;

  MissingLetterData({
    required this.word,
    required this.imageUrl,
    required this.pronunciation,
    this.definition = '',
    required this.missingIndices,
    required this.missingLetters,
    this.userInput = '',
  });

  MissingLetterData copyWith({
    String? word,
    String? imageUrl,
    String? pronunciation,
    String? definition,
    List<int>? missingIndices,
    List<String>? missingLetters,
    String? userInput,
  }) {
    return MissingLetterData(
      word: word ?? this.word,
      imageUrl: imageUrl ?? this.imageUrl,
      pronunciation: pronunciation ?? this.pronunciation,
      definition: definition ?? this.definition,
      missingIndices: missingIndices ?? this.missingIndices,
      missingLetters: missingLetters ?? this.missingLetters,
      userInput: userInput ?? this.userInput,
    );
  }
}

class MissingWordController extends GetxController {
  final GetWordsByGameIdUseCase _getWordsByGameIdUseCase;

  MissingWordController(this._getWordsByGameIdUseCase);
  final TopicService _topicService = Get.find<TopicService>();
  final UserService _userService = Get.find<UserService>();

  final _gameState = MissingWordGameState.loading.obs;
  final _isLoading = false.obs;
  final _score = 0.obs;
  final _currentLevel = 1.obs;
  final _consecutiveCorrect = 0.obs;
  final _gameTime = 300.obs; // 5 minutes for endless mode
  final _timeRemaining = 300.obs;
  final _gameInProgress = false.obs;
  final _showResult = false.obs;
  final _bonusMultiplier = 1.0.obs;
  final _isKeyboardVisible = false.obs;

  // API integration properties
  List<WordEntity> _gameWords = [];
  int _currentWordIndex = 0;
  Map<String, dynamic>? _gameData;
  int get gameId => _gameData?['game_id'] ?? 2;
  int get learningPathId => _gameData?['learning_path_id'] ?? 1;

  final _currentWord = Rx<MissingLetterData?>(null);
  final _userInput = ''.obs;
  final _showFeedback = false.obs;
  final _isCorrectAnswer = false.obs;
  final _canInputLetter = true.obs;
  final _disabledKeys = <String>[].obs;

  Timer? _gameTimer;
  FlutterTts? _flutterTts;

  final Random _random = Random();

  // API endpoints for random words with dynamic parameters
  static const String _baseNounApiUrl =
      'https://random-word-api-eight.vercel.app/word/english/noun';
  static const String _baseVerbApiUrl =
      'https://random-word-api-eight.vercel.app/word/english/verb';
  static const String _baseAdjectiveApiUrl =
      'https://random-word-api-eight.vercel.app/word/english/adjective';

  // Dictionary API for pronunciation
  static const String _dictionaryApiUrl =
      'https://api.dictionaryapi.dev/api/v2/entries/en';

  // Cache for storing fetched words to reduce API calls
  final List<String> _cachedNouns = [];
  final List<String> _cachedVerbs = [];
  final List<String> _cachedAdjectives = [];
  final int _maxCacheSize = 50;

  // Cache for storing pronunciations
  final Map<String, String> _pronunciationCache = {};

  // Cache for storing definitions
  final Map<String, String> _definitionCache = {};

  // Cache for storing translated definitions
  final Map<String, String> _translatedDefinitionCache = {};

  // Translation state
  final RxBool _isTranslationEnabled = false.obs;
  bool get isTranslationEnabled => _isTranslationEnabled.value;

  final List<String> _allWords = [
    'cat',
    'dog',
    'bat',
    'sun',
    'car',
    'bus',
    'pen',
    'cup',
    'hat',
    'bag',
    'box',
    'fox',
    'egg',
    'pig',
    'bee',
    'ant',
    'key',
    'toy',
    'eye',
    'ear',
    'apple',
    'house',
    'water',
    'green',
    'happy',
    'chair',
    'table',
    'flower',
    'tiger',
    'clock',
    'paper',
    'money',
    'party',
    'beach',
    'ocean',
    'music',
    'friend',
    'family',
    'school',
    'garden',
    'yellow',
    'orange',
    'purple',
    'elephant',
    'beautiful',
    'computer',
    'butterfly',
    'mountain',
    'telephone',
    'wonderful',
    'important',
    'chocolate',
    'birthday',
    'hamburger',
    'fantastic',
    'umbrella',
    'basketball',
    'adventure',
    'breakfast',
    'Christmas',
    'dinosaur',
    'helicopter',
    'refrigerator',
    'transportation',
    'information',
    'communication',
    'organization',
    'entertainment',
    'development',
    'environment',
    'construction'
  ];

  // Getters
  MissingWordGameState get gameState => _gameState.value;
  bool get isLoading => _isLoading.value;
  int get score => _score.value;
  int get currentLevel => _currentLevel.value;
  int get consecutiveCorrect => _consecutiveCorrect.value;
  int get gameTime => _gameTime.value;
  int get timeRemaining => _timeRemaining.value;
  bool get gameInProgress => _gameInProgress.value;
  bool get showResult => _showResult.value;
  double get bonusMultiplier => _bonusMultiplier.value;
  MissingLetterData? get currentWord => _currentWord.value;
  String get userInput => _userInput.value;
  bool get showFeedback => _showFeedback.value;
  bool get isCorrectAnswer => _isCorrectAnswer.value;
  bool get canInputLetter => _canInputLetter.value;
  bool get isKeyboardVisible => _isKeyboardVisible.value;
  List<String> get disabledKeys => _disabledKeys;

  // Additional getters for progressive difficulty info
  String get currentWordType => _getApiTypeForLevel(_currentLevel.value);
  int get currentMinLength => (currentLevel <= 3)
      ? 3
      : (currentLevel <= 6)
          ? 4
          : (currentLevel <= 9)
              ? 5
              : 6;
  int get currentMaxLength => (currentLevel <= 3)
      ? 6
      : (currentLevel <= 6)
          ? 8
          : (currentLevel <= 9)
              ? 12
              : 18;

  // Pronunciation getter
  String get currentWordPronunciation => getPronunciationText();

  // Definition getter
  String get currentWordDefinition => getDefinitionText();

  // Translation methods
  void toggleTranslation() {
    _isTranslationEnabled.value = !_isTranslationEnabled.value;
    update();
  }

  Future<String> _translateDefinition(String definition) async {
    if (definition.isEmpty) return definition;

    final cacheKey = 'translated_$definition';
    if (_translatedDefinitionCache.containsKey(cacheKey)) {
      return _translatedDefinitionCache[cacheKey]!;
    }

    try {
      final translatedText =
          await TranslationService.translateToVietnamese(definition);
      _translatedDefinitionCache[cacheKey] = translatedText;
      return translatedText;
    } catch (e) {
      print('Translation error: $e');
      return definition;
    }
  }

  @override
  void onInit() {
    super.onInit();
    _gameData = Get.arguments as Map<String, dynamic>?;
    _initTts();
    startGame();
  }

  @override
  void onClose() {
    _gameTimer?.cancel();
    _flutterTts?.stop();
    super.onClose();
  }

  // API methods for fetching random words
  String _buildApiUrl(String baseUrl, int level) {
    // Progressive difficulty: start with short words, gradually increase
    int minLength = (level <= 3)
        ? 3
        : (level <= 6)
            ? 4
            : (level <= 9)
                ? 5
                : 6;

    int maxLength = (level <= 6)
        ? 8
        : (level <= 6)
            ? 12
            : (level <= 9)
                ? 12
                : 18;

    // Ensure minLength doesn't exceed 9 and maxLength doesn't exceed 18
    minLength = minLength.clamp(3, 9);
    maxLength = maxLength.clamp(minLength + 1, 18);

    return '$baseUrl?minLength=$minLength&maxLength=$maxLength';
  }

  String _getApiTypeForLevel(int level) {
    final apiTypes = ['noun', 'verb', 'adjective'];
    return apiTypes[_random.nextInt(apiTypes.length)];
  }

  String _getBaseApiUrlForType(String type) {
    switch (type) {
      case 'noun':
        return _baseNounApiUrl;
      case 'verb':
        return _baseVerbApiUrl;
      case 'adjective':
        return _baseAdjectiveApiUrl;
      default:
        return _baseNounApiUrl;
    }
  }

  List<String> _getCacheForType(String type) {
    switch (type) {
      case 'noun':
        return _cachedNouns;
      case 'verb':
        return _cachedVerbs;
      case 'adjective':
        return _cachedAdjectives;
      default:
        return _cachedNouns;
    }
  }

  Future<String?> _fetchRandomWord(String apiUrl) async {
    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data is Map<String, dynamic> && data['word'] != null) {
          return data['word'].toString().toLowerCase();
        }
      }
    } catch (e) {
      print('Error fetching word from API: $e');
    }
    return null;
  }

  Future<String?> _fetchWordPronunciation(String word) async {
    // Check cache first
    final cacheKey = word.toLowerCase();
    if (_pronunciationCache.containsKey(cacheKey)) {
      return _pronunciationCache[cacheKey];
    }

    try {
      final response = await http.get(
        Uri.parse('$_dictionaryApiUrl/${word.toLowerCase()}'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data is List && data.isNotEmpty) {
          final wordData = data[0];

          String? pronunciation;

          // Look for pronunciation in phonetics array
          if (wordData['phonetics'] != null && wordData['phonetics'] is List) {
            final phonetics = wordData['phonetics'] as List;
            for (var phonetic in phonetics) {
              if (phonetic['text'] != null &&
                  phonetic['text'].toString().isNotEmpty) {
                pronunciation = phonetic['text'].toString();
                break;
              }
            }
          }

          // Fallback: look for pronunciation in word data
          if (pronunciation == null && wordData['phonetic'] != null) {
            pronunciation = wordData['phonetic'].toString();
          }

          // Cache the result (even if null)
          if (pronunciation != null) {
            _pronunciationCache[cacheKey] = pronunciation;
            return pronunciation;
          }
        }
      }
    } catch (e) {
      print('Error fetching pronunciation: $e');
    }

    // Cache null result to avoid repeated API calls
    _pronunciationCache[cacheKey] = '';
    return null;
  }

  Future<String?> _fetchWordDefinition(String word) async {
    // Check cache first
    final cacheKey = word.toLowerCase();
    if (_definitionCache.containsKey(cacheKey)) {
      return _definitionCache[cacheKey];
    }

    try {
      final response = await http.get(
        Uri.parse('$_dictionaryApiUrl/${word.toLowerCase()}'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data is List && data.isNotEmpty) {
          final wordData = data[0];

          String? definition;

          // Look for definition in meanings array
          if (wordData['meanings'] != null && wordData['meanings'] is List) {
            final meanings = wordData['meanings'] as List;
            if (meanings.isNotEmpty) {
              final firstMeaning = meanings[0];
              if (firstMeaning['definitions'] != null &&
                  firstMeaning['definitions'] is List) {
                final definitions = firstMeaning['definitions'] as List;
                if (definitions.isNotEmpty &&
                    definitions[0]['definition'] != null) {
                  definition = definitions[0]['definition'].toString();
                }
              }
            }
          }

          // Cache the result (even if null)
          if (definition != null) {
            _definitionCache[cacheKey] = definition;
            return definition;
          }
        }
      }
    } catch (e) {
      print('Error fetching definition: $e');
    }

    // Cache null result to avoid repeated API calls
    _definitionCache[cacheKey] = '';
    return null;
  }

  Future<String> _getRandomWordFromAPI() async {
    // Determine API type based on current level (cycle through noun, verb, adjective)
    final apiType = _getApiTypeForLevel(_currentLevel.value);
    final cache = _getCacheForType(apiType);

    // Try to get from cache first
    if (cache.isNotEmpty) {
      final word = cache.removeAt(_random.nextInt(cache.length));
      return word;
    }

    // Fetch multiple words to populate cache
    await _populateCache(apiType);

    // If cache still empty, use fallback
    if (cache.isEmpty) {
      return _getFallbackWord();
    }

    return cache.removeAt(_random.nextInt(cache.length));
  }

  Future<void> _populateCache(String apiType) async {
    final baseApiUrl = _getBaseApiUrlForType(apiType);
    final apiUrl = _buildApiUrl(baseApiUrl, _currentLevel.value);
    final cache = _getCacheForType(apiType);

    // Fetch multiple words in parallel
    final futures = List.generate(10, (_) => _fetchRandomWord(apiUrl));
    final results = await Future.wait(futures);

    for (final word in results) {
      if (word != null &&
          !cache.contains(word) &&
          cache.length < _maxCacheSize) {
        cache.add(word);
      }
    }
  }

  String _getFallbackWord() {
    // Use static words as fallback when API fails
    final levelWords = _getWordsForLevel(_currentLevel.value);
    return levelWords[_random.nextInt(levelWords.length)];
  }

  void _initTts() async {
    _flutterTts = FlutterTts();
    await _flutterTts?.setLanguage('en-US');
    await _flutterTts?.setSpeechRate(0.25);
    await _flutterTts?.setVolume(1.0);
    await _flutterTts?.setPitch(1.0);
  }

  void startGame() async {
    _gameState.value = MissingWordGameState.loading;
    _isLoading.value = true;

    _resetGameData();

    // Fetch words from API
    await _loadWordsFromAPI();

    if (_gameWords.isNotEmpty) {
      await _generateNextWord();
      _gameState.value = MissingWordGameState.playing;
      _gameInProgress.value = true;
      _isLoading.value = false;
      _startGameTimer();
    } else {
      // Fallback to original random API if game API fails
      await _fallbackToRandomAPI();
    }
  }

  Future<void> _loadWordsFromAPI() async {
    try {
      // Fetch words from API using game ID from arguments
      final fetchedWords = await _getWordsByGameIdUseCase.call(gameId);
      _gameWords = fetchedWords;
      print(
          'Loaded ${_gameWords.length} words from API for Missing Word game (ID: $gameId)');

      if (_gameWords.isEmpty) {
        throw Exception('No words found for Missing Word game (ID: $gameId)');
      }
    } catch (e) {
      print('Error loading words from API: $e');
      _gameWords = [];
    }
  }

  Future<void> _fallbackToRandomAPI() async {
    // Use original random word logic as fallback
    _populateCache('noun'); // Get some nouns
    _populateCache('verb'); // Get some verbs
    _populateCache('adjective'); // Get some adjectives

    await _generateNextWord();

    _gameState.value = MissingWordGameState.playing;
    _gameInProgress.value = true;
    _isLoading.value = false;
    _startGameTimer();
  }

  void _resetGameData() {
    _score.value = 0;
    _currentLevel.value = 1;
    _consecutiveCorrect.value = 0;
    _bonusMultiplier.value = 1.0;
    _userInput.value = '';
    _showFeedback.value = false;
    _isCorrectAnswer.value = false;
    _canInputLetter.value = true;
    _timeRemaining.value = _gameTime.value;
    _isKeyboardVisible.value = false;
    _currentWordIndex = 0; // Reset word progression
  }

  void _startGameTimer() {
    _gameTimer?.cancel();
    _gameTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeRemaining.value > 0) {
        _timeRemaining.value--;
      } else {
        _endGame();
      }
    });
  }

  Future<void> _generateNextWord() async {
    try {
      String selectedWord;
      String wordImageUrl = '';

      if (_gameWords.isNotEmpty &&
          _currentWordIndex >= 0 &&
          _currentWordIndex < _gameWords.length) {
        // Use word from API
        final wordEntity = _gameWords[_currentWordIndex];
        selectedWord = wordEntity.word;
        wordImageUrl = wordEntity.image;
        print(
            'Using word from API: $selectedWord (${_currentWordIndex + 1}/${_gameWords.length})');
      } else {
        // Fallback to random word API if no more game words
        selectedWord = await _getRandomWordFromAPI();
        print('Using fallback random word: $selectedWord');
      }

      // Fetch pronunciation and definition from dictionary API concurrently
      final futures = [
        _fetchWordPronunciation(selectedWord),
        _fetchWordDefinition(selectedWord),
      ];
      final results = await Future.wait(futures);
      final pronunciation = results[0];
      final definition = results[1];

      final missingCount = _getMissingLetterCount(_currentLevel.value);
      final missingIndices =
          _generateMissingIndices(selectedWord, missingCount);
      final missingLetters = missingIndices
          .map((index) => selectedWord[index].toLowerCase())
          .toList();

      _currentWord.value = MissingLetterData(
        word: selectedWord,
        imageUrl: wordImageUrl,
        pronunciation: pronunciation ??
            selectedWord, // Use API pronunciation or fallback to word
        definition: definition ?? '', // Use API definition or empty string
        missingIndices: missingIndices,
        missingLetters: missingLetters,
      );

      _userInput.value = '';
      print('Generated word: $selectedWord');
      await _speakWord(selectedWord);
    } catch (e) {
      print('Error generating word: $e');
      // Complete fallback to static words
      final selectedWords = _getWordsForLevel(_currentLevel.value);
      final randomWord = selectedWords[_random.nextInt(selectedWords.length)];

      final missingCount = _getMissingLetterCount(_currentLevel.value);
      final missingIndices = _generateMissingIndices(randomWord, missingCount);
      final missingLetters = missingIndices
          .map((index) => randomWord[index].toLowerCase())
          .toList();

      _currentWord.value = MissingLetterData(
        word: randomWord,
        imageUrl: '',
        pronunciation: randomWord, // Fallback pronunciation
        definition: '', // No definition for fallback words
        missingIndices: missingIndices,
        missingLetters: missingLetters,
      );

      _userInput.value = '';
      await _speakWord(randomWord);
    }
  }

  List<String> _getWordsForLevel(int level) {
    if (level <= 3) {
      return _allWords.where((word) => word.length <= 4).toList();
    } else if (level <= 7) {
      return _allWords
          .where((word) => word.length >= 4 && word.length <= 7)
          .toList();
    } else if (level <= 12) {
      return _allWords
          .where((word) => word.length >= 6 && word.length <= 10)
          .toList();
    } else {
      return _allWords.where((word) => word.length >= 8).toList();
    }
  }

  int _getMissingLetterCount(int level) {
    // Progressive difficulty for missing letters
    // Start with 1 missing letter, gradually increase
    if (level <= 2) return 1; // Level 1-2: 1 missing letter
    if (level <= 4) return 2; // Level 3-4: 2 missing letters
    if (level <= 6) return 3; // Level 5-6: 3 missing letters
    if (level <= 8) return 4; // Level 7-8: 4 missing letters
    if (level <= 12) return 5; // Level 9-12: 5 missing letters
    return 6; // Level 13+: 6 missing letters (max)
  }

  List<int> _generateMissingIndices(String word, int count) {
    final indices = <int>[];
    final availableIndices = List.generate(word.length, (index) => index);
    availableIndices.shuffle(_random);

    for (int i = 0; i < count && i < word.length; i++) {
      indices.add(availableIndices[i]);
    }

    indices.sort();
    return indices;
  }

  Future<void> _speakWord(String word) async {
    await _flutterTts?.speak(word);
  }

  void showKeyboard() {
    _isKeyboardVisible.value = true;
  }

  void hideKeyboard() {
    _isKeyboardVisible.value = false;
  }

  void onKeyPressed(String key) {
    if (!_canInputLetter.value) return;

    if (key == 'ENTER') {
      _checkAnswer();
    } else if (key == 'BACKSPACE') {
      if (_userInput.value.isNotEmpty) {
        _userInput.value =
            _userInput.value.substring(0, _userInput.value.length - 1);
        _updateCurrentWordInput();
      }
    } else if (key.length == 1 &&
        _userInput.value.length < _currentWord.value!.missingLetters.length) {
      // Check if the input letter is correct for current position
      final currentPosition = _userInput.value.length;
      final expectedLetter =
          _currentWord.value!.missingLetters[currentPosition].toLowerCase();

      if (key.toLowerCase() == expectedLetter) {
        // Correct letter
        _userInput.value += key.toLowerCase();
        _updateCurrentWordInput();
      } else {
        // Wrong letter - don't disable any keys, just give penalty
        _consecutiveCorrect.value = 0;
        _bonusMultiplier.value = 1.0;
        _updateScore(false); // Reduce score for wrong input

        // Play wrong sound effect
        LibFunction.effectWrongAnswer();

        // Show brief feedback
        _showBriefWrongFeedback();
      }
    }
  }

  void _showBriefWrongFeedback() async {
    _showFeedback.value = true;
    _isCorrectAnswer.value = false;

    await Future.delayed(const Duration(milliseconds: 800));

    _showFeedback.value = false;
  }

  void _updateCurrentWordInput() {
    if (_currentWord.value != null) {
      _currentWord.value =
          _currentWord.value!.copyWith(userInput: _userInput.value);
    }
  }

  void _checkAnswer() async {
    if (_userInput.value.length != _currentWord.value!.missingLetters.length)
      return;

    final isCorrect =
        _userInput.value == _currentWord.value!.missingLetters.join('');
    _isCorrectAnswer.value = isCorrect;
    _showFeedback.value = true;
    _canInputLetter.value = false;

    if (isCorrect) {
      await LibFunction.effectTrueAnswer();
      _consecutiveCorrect.value++;
      _updateBonusMultiplier();
      _updateScore(true);

      await Future.delayed(const Duration(milliseconds: 1500));
      _nextLevel();
    } else {
      await LibFunction.effectWrongAnswer();
      _consecutiveCorrect.value = 0;
      _bonusMultiplier.value = 1.0;

      await Future.delayed(const Duration(milliseconds: 2000));
      _resetForNextTry();
    }
  }

  void _updateBonusMultiplier() {
    if (_consecutiveCorrect.value >= 3) {
      _bonusMultiplier.value = 2.0;
    } else if (_consecutiveCorrect.value >= 5) {
      _bonusMultiplier.value = 3.0;
    } else if (_consecutiveCorrect.value >= 8) {
      _bonusMultiplier.value = 4.0;
    }
  }

  void _updateScore(bool isCorrect) {
    if (isCorrect) {
      int baseScore = 10 + (_currentLevel.value * 2);
      final missingCount = _currentWord.value?.missingLetters.length ?? 1;
      baseScore += missingCount * 5;

      final bonusScore = (baseScore * _bonusMultiplier.value).round();
      _score.value += bonusScore;
    } else {
      // Deduct points for wrong input
      int penalty = 5;
      _score.value = (_score.value - penalty).clamp(0, double.infinity).toInt();
    }
  }

  void _nextLevel() async {
    _currentWordIndex++; // Move to next word from API

    // Check if we've completed all words from API
    if (_gameWords.isNotEmpty && _currentWordIndex >= _gameWords.length) {
      // All words completed - end the game
      _endGame();
      return;
    }

    _currentLevel.value++;
    _userInput.value = '';
    _showFeedback.value = false;
    _canInputLetter.value = true;
    _isKeyboardVisible.value = false;
    _disabledKeys.clear(); // Reset disabled keys for new word

    await _generateNextWord();
  }

  void _resetForNextTry() {
    _userInput.value = '';
    _showFeedback.value = false;
    _canInputLetter.value = true;
    _isKeyboardVisible.value = false;
    _disabledKeys.clear(); // Reset disabled keys for retry
    _updateCurrentWordInput();
  }

  Future<void> _endGame() async {
    _gameTimer?.cancel();
    _gameInProgress.value = false;
    _gameState.value = MissingWordGameState.finished;
    _showResult.value = true;
    _isKeyboardVisible.value = false;
    await _topicService.submitGameResult(_userService.currentUser.id, null, 5, 1, "00:00", learningPathId, gameId);

    LibFunction.effectFinish();
  }

  void restartGame() {
    _gameState.value = MissingWordGameState.loading;
    _showResult.value = false;
    _gameInProgress.value = false;
    _gameTimer?.cancel();

    // Reset word progression
    _currentWordIndex = 0;
    _gameWords.clear();

    // Clear cached words, pronunciations and definitions for fresh experience
    _cachedNouns.clear();
    _cachedVerbs.clear();
    _cachedAdjectives.clear();
    _pronunciationCache.clear();
    _definitionCache.clear();
    _translatedDefinitionCache.clear();

    startGame();
  }

  void playWordPronunciation() {
    if (_currentWord.value != null) {
      _speakWord(_currentWord.value!.word);
    }
  }

  void playPronunciationGuide() {
    if (_currentWord.value != null &&
        _currentWord.value!.pronunciation.isNotEmpty) {
      // If we have phonetic pronunciation, speak the word with emphasis
      _speakWord(_currentWord.value!.word);
    }
  }

  String getPronunciationText() {
    if (_currentWord.value?.pronunciation != null &&
        _currentWord.value!.pronunciation != _currentWord.value!.word) {
      return _currentWord.value!.pronunciation;
    }
    return '';
  }

  String getDefinitionText() {
    if (_currentWord.value?.definition != null &&
        _currentWord.value!.definition.isNotEmpty) {
      // Format definition: capitalize first letter and ensure it ends with period
      String definition = _currentWord.value!.definition.trim();
      if (definition.isNotEmpty) {
        definition = definition[0].toUpperCase() + definition.substring(1);
        if (!definition.endsWith('.') &&
            !definition.endsWith('!') &&
            !definition.endsWith('?')) {
          definition += '.';
        }
      }
      return definition;
    }
    return '';
  }

  Future<String> getTranslatedDefinitionText() async {
    final englishDefinition = getDefinitionText();
    if (englishDefinition.isEmpty) return '';

    if (isTranslationEnabled) {
      return await _translateDefinition(englishDefinition);
    }
    return englishDefinition;
  }

  String getDisplayWord() {
    if (_currentWord.value == null) return '';

    final word = _currentWord.value!.word;
    final missingIndices = _currentWord.value!.missingIndices;
    final userInput = _currentWord.value!.userInput;

    String result = '';
    int inputIndex = 0;

    for (int i = 0; i < word.length; i++) {
      if (missingIndices.contains(i)) {
        if (inputIndex < userInput.length) {
          result += userInput[inputIndex].toUpperCase();
          inputIndex++;
        } else {
          result += '_';
        }
      } else {
        result += word[i].toUpperCase();
      }
    }

    return result;
  }

  String getTimeFormatted() {
    final minutes = _timeRemaining.value ~/ 60;
    final seconds = _timeRemaining.value % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  int getCurrentWordLength() {
    return _currentWord.value?.word.length ?? 0;
  }

  int getMissingLetterCount() {
    return _currentWord.value?.missingLetters.length ?? 0;
  }

  // Debug method to get level info
  String getLevelInfo() {
    final pronunciationInfo = currentWordPronunciation.isNotEmpty
        ? ' [$currentWordPronunciation]'
        : '';
    return 'Level $currentLevel - ${currentWordType.toUpperCase()} ($currentMinLength-$currentMaxLength letters, ${_getMissingLetterCount(currentLevel)} missing)$pronunciationInfo';
  }

  // Progress tracking methods
  String getProgressText() {
    if (_gameWords.isEmpty) return '';
    final current = _gameWords.isEmpty
        ? 0
        : (_currentWordIndex + 1).clamp(1, _gameWords.length);
    return 'Word $current/${_gameWords.length}';
  }

  double getProgressValue() {
    if (_gameWords.isEmpty) return 0.0;
    return (_currentWordIndex + 1) / _gameWords.length;
  }

  int getTotalWords() => _gameWords.length;

  int getCurrentWordNumber() {
    if (_gameWords.isEmpty) return 0;
    return (_currentWordIndex + 1).clamp(1, _gameWords.length);
  }

  String getCurrentWordImageUrl() {
    if (currentWord == null) return '';
    return currentWord!.imageUrl;
  }
}
