import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum PuzzleType {
  wordScramble,
  fillInBlank,
  rhymeMatch,
  synonymAntonym,
  grammarFix,
}

enum GameDifficulty {
  easy,
  medium,
  hard,
}

class PuzzleQuestion {
  final String question;
  final List<String> options;
  final String correctAnswer;
  final String explanation;
  final PuzzleType type;
  final GameDifficulty difficulty;

  PuzzleQuestion({
    required this.question,
    required this.options,
    required this.correctAnswer,
    required this.explanation,
    required this.type,
    required this.difficulty,
  });
}

class PuzzleGameController extends GetxController with WidgetsBindingObserver {
  // Game state observables
  final RxBool _isLoading = false.obs;
  final RxBool _gameStarted = false.obs;
  final RxBool _gameFinished = false.obs;
  final RxBool _showResult = false.obs;
  final RxBool _timerActive = false.obs;

  // Game configuration
  final Rx<PuzzleType> _selectedPuzzleType = PuzzleType.wordScramble.obs;
  final Rx<GameDifficulty> _selectedDifficulty = GameDifficulty.easy.obs;
  final RxInt _gameTimeLimit = 60.obs; // seconds
  final RxInt _questionsPerGame = 10.obs;

  // Current game state
  final RxList<PuzzleQuestion> _questions = <PuzzleQuestion>[].obs;
  final RxInt _currentQuestionIndex = 0.obs;
  final RxInt _score = 0.obs;
  final RxInt _timeRemaining = 0.obs;
  final RxString _selectedAnswer = ''.obs;
  final RxList<String> _userAnswers = <String>[].obs;
  Timer? _gameTimer;

  // Getters
  bool get isLoading => _isLoading.value;
  bool get gameStarted => _gameStarted.value;
  bool get gameFinished => _gameFinished.value;
  bool get showResult => _showResult.value;
  bool get timerActive => _timerActive.value;

  PuzzleType get selectedPuzzleType => _selectedPuzzleType.value;
  GameDifficulty get selectedDifficulty => _selectedDifficulty.value;
  int get gameTimeLimit => _gameTimeLimit.value;
  int get questionsPerGame => _questionsPerGame.value;

  List<PuzzleQuestion> get questions => _questions;
  int get currentQuestionIndex => _currentQuestionIndex.value;
  int get score => _score.value;
  int get timeRemaining => _timeRemaining.value;
  String get selectedAnswer => _selectedAnswer.value;
  List<String> get userAnswers => _userAnswers;

  PuzzleQuestion? get currentQuestion =>
      _questions.isNotEmpty && _currentQuestionIndex.value < _questions.length
          ? _questions[_currentQuestionIndex.value]
          : null;

  int get totalQuestions => _questions.length;
  double get progress => totalQuestions > 0
      ? (_currentQuestionIndex.value + 1) / totalQuestions
      : 0.0;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    _generateQuestions();
  }

  @override
  void onClose() {
    _gameTimer?.cancel();
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
  void setPuzzleType(PuzzleType type) {
    _selectedPuzzleType.value = type;
    if (!_gameStarted.value) {
      _generateQuestions();
    }
  }

  void setDifficulty(GameDifficulty difficulty) {
    _selectedDifficulty.value = difficulty;
    if (!_gameStarted.value) {
      _generateQuestions();
    }
  }

  void setTimeLimit(int seconds) {
    _gameTimeLimit.value = seconds;
  }

  void setQuestionsPerGame(int count) {
    _questionsPerGame.value = count;
    if (!_gameStarted.value) {
      _generateQuestions();
    }
  }

  // Game control methods
  void startGame() {
    if (_questions.isEmpty) {
      _generateQuestions();
    }

    _gameStarted.value = true;
    _gameFinished.value = false;
    _currentQuestionIndex.value = 0;
    _score.value = 0;
    _userAnswers.clear();
    _selectedAnswer.value = '';
    _showResult.value = false;

    if (_gameTimeLimit.value > 0) {
      _startTimer();
    }
  }

  void pauseGame() {
    _timerActive.value = false;
    _gameTimer?.cancel();
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

  void selectAnswer(String answer) {
    if (_gameFinished.value) return;
    _selectedAnswer.value = answer;
  }

  void submitAnswer() {
    if (_gameFinished.value || _selectedAnswer.value.isEmpty) return;

    final currentQ = currentQuestion;
    if (currentQ == null) return;

    _userAnswers.add(_selectedAnswer.value);

    // Check if answer is correct
    if (_selectedAnswer.value == currentQ.correctAnswer) {
      _score.value++;
    }

    _showResult.value = true;

    // Auto-advance after showing result
    Future.delayed(const Duration(seconds: 2), () {
      nextQuestion();
    });
  }

  void nextQuestion() {
    _showResult.value = false;
    _selectedAnswer.value = '';

    if (_currentQuestionIndex.value < _questions.length - 1) {
      _currentQuestionIndex.value++;
    } else {
      _endGame();
    }
  }

  void _endGame() {
    _gameFinished.value = true;
    _timerActive.value = false;
    _gameTimer?.cancel();

    // Show final results
    Get.dialog(
      _buildResultDialog(),
      barrierDismissible: false,
    );
  }

  Widget _buildResultDialog() {
    final percentage = (score / totalQuestions * 100).round();

    return AlertDialog(
      title: const Text('Game Complete!'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Final Score: $score/$totalQuestions'),
          Text('Percentage: $percentage%'),
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
    if (percentage >= 90) return 'Excellent! 🌟';
    if (percentage >= 75) return 'Great job! 👏';
    if (percentage >= 60) return 'Good work! 👍';
    if (percentage >= 40) return 'Keep practicing! 📚';
    return 'Don\'t give up! Try again! 💪';
  }

  void resetGame() {
    _gameStarted.value = false;
    _gameFinished.value = false;
    _currentQuestionIndex.value = 0;
    _score.value = 0;
    _userAnswers.clear();
    _showResult.value = false;
    _selectedAnswer.value = '';
    _timerActive.value = false;
    _generateQuestions();
  }

  void _generateQuestions() {
    _isLoading.value = true;
    _questions.clear();

    switch (_selectedPuzzleType.value) {
      case PuzzleType.wordScramble:
        _generateWordScrambleQuestions();
        break;
      case PuzzleType.fillInBlank:
        _generateFillInBlankQuestions();
        break;
      case PuzzleType.rhymeMatch:
        _generateRhymeMatchQuestions();
        break;
      case PuzzleType.synonymAntonym:
        _generateSynonymAntonymQuestions();
        break;
      case PuzzleType.grammarFix:
        _generateGrammarFixQuestions();
        break;
    }

    _isLoading.value = false;
  }

  void _generateWordScrambleQuestions() {
    final words = _getWordsForDifficulty();

    for (int i = 0; i < _questionsPerGame.value && i < words.length; i++) {
      final word = words[i];
      final scrambled = _scrambleWord(word);
      final wrongOptions = _generateWrongOptions(word, words);

      final options = [word, ...wrongOptions];
      options.shuffle();

      _questions.add(PuzzleQuestion(
        question: 'Unscramble this word: "$scrambled"',
        options: options,
        correctAnswer: word,
        explanation: 'The correct word is "$word".',
        type: PuzzleType.wordScramble,
        difficulty: _selectedDifficulty.value,
      ));
    }
  }

  void _generateFillInBlankQuestions() {
    final sentences = _getSentencesForDifficulty();

    for (int i = 0; i < _questionsPerGame.value && i < sentences.length; i++) {
      final sentenceData = sentences[i];
      final sentence = sentenceData['sentence'] as String;
      final correctAnswer = sentenceData['answer'] as String;
      final options = sentenceData['options'] as List<String>;

      _questions.add(PuzzleQuestion(
        question: 'Fill in the blank: "$sentence"',
        options: options,
        correctAnswer: correctAnswer,
        explanation: 'The correct answer is "$correctAnswer".',
        type: PuzzleType.fillInBlank,
        difficulty: _selectedDifficulty.value,
      ));
    }
  }

  void _generateRhymeMatchQuestions() {
    final rhymes = _getRhymesForDifficulty();

    for (int i = 0; i < _questionsPerGame.value && i < rhymes.length; i++) {
      final rhymeData = rhymes[i];
      final word = rhymeData['word'] as String;
      final rhyme = rhymeData['rhyme'] as String;
      final wrongOptions = rhymeData['options'] as List<String>;

      final options = [rhyme, ...wrongOptions];
      options.shuffle();

      _questions.add(PuzzleQuestion(
        question: 'Which word rhymes with "$word"?',
        options: options,
        correctAnswer: rhyme,
        explanation: '"$rhyme" rhymes with "$word".',
        type: PuzzleType.rhymeMatch,
        difficulty: _selectedDifficulty.value,
      ));
    }
  }

  void _generateSynonymAntonymQuestions() {
    final synAnt = _getSynonymAntonymForDifficulty();

    for (int i = 0; i < _questionsPerGame.value && i < synAnt.length; i++) {
      final data = synAnt[i];
      final word = data['word'] as String;
      final correct = data['correct'] as String;
      final type = data['type'] as String;
      final wrongOptions = data['options'] as List<String>;

      final options = [correct, ...wrongOptions];
      options.shuffle();

      final questionType = type == 'synonym' ? 'synonym' : 'antonym';

      _questions.add(PuzzleQuestion(
        question: 'What is the $questionType of "$word"?',
        options: options,
        correctAnswer: correct,
        explanation: '"$correct" is the $questionType of "$word".',
        type: PuzzleType.synonymAntonym,
        difficulty: _selectedDifficulty.value,
      ));
    }
  }

  void _generateGrammarFixQuestions() {
    final grammar = _getGrammarQuestionsForDifficulty();

    for (int i = 0; i < _questionsPerGame.value && i < grammar.length; i++) {
      final grammarData = grammar[i];
      final incorrectSentence = grammarData['incorrect'] as String;
      final correctSentence = grammarData['correct'] as String;
      final options = grammarData['options'] as List<String>;

      _questions.add(PuzzleQuestion(
        question: 'Fix the grammar error: "$incorrectSentence"',
        options: options,
        correctAnswer: correctSentence,
        explanation: 'The correct sentence is: "$correctSentence".',
        type: PuzzleType.grammarFix,
        difficulty: _selectedDifficulty.value,
      ));
    }
  }

  // Helper methods for generating questions and data
  String _scrambleWord(String word) {
    List<String> letters = word.split('');
    letters.shuffle();
    return letters.join('');
  }

  List<String> _generateWrongOptions(
      String correctWord, List<String> allWords) {
    final wrongOptions =
        allWords.where((word) => word != correctWord).take(3).toList();

    // If not enough wrong options, add some generic ones
    while (wrongOptions.length < 3) {
      wrongOptions.add('${correctWord}S');
    }

    return wrongOptions;
  }

  List<String> _getWordsForDifficulty() {
    switch (_selectedDifficulty.value) {
      case GameDifficulty.easy:
        return [
          'CAT',
          'DOG',
          'SUN',
          'MOON',
          'BOOK',
          'TREE',
          'BIRD',
          'FISH',
          'HOUSE',
          'WATER',
          'HAPPY',
          'GREEN',
          'SMALL',
          'QUICK',
          'LIGHT'
        ];
      case GameDifficulty.medium:
        return [
          'ELEPHANT',
          'COMPUTER',
          'RAINBOW',
          'MOUNTAIN',
          'BEAUTIFUL',
          'AMAZING',
          'CHOCOLATE',
          'ADVENTURE',
          'LIBRARY',
          'BUTTERFLY',
          'TELEPHONE',
          'FANTASTIC',
          'EDUCATION',
          'WONDERFUL',
          'CELEBRATE'
        ];
      case GameDifficulty.hard:
        return [
          'ENCYCLOPEDIA',
          'MAGNIFICENT',
          'EXTRAORDINARY',
          'SOPHISTICATED',
          'INDEPENDENCE',
          'ARCHITECTURE',
          'RESPONSIBILITY',
          'TEMPERATURE',
          'COMMUNICATION',
          'PRONUNCIATION',
          'REFRIGERATOR',
          'PHOTOGRAPHER',
          'DETERMINATION',
          'CHARACTERISTICS',
          'TRANSPORTATION'
        ];
    }
  }

  List<Map<String, dynamic>> _getSentencesForDifficulty() {
    switch (_selectedDifficulty.value) {
      case GameDifficulty.easy:
        return [
          {
            'sentence': 'The cat _____ on the mat.',
            'answer': 'sits',
            'options': ['sits', 'sit', 'sitting', 'sat']
          },
          {
            'sentence': 'I _____ an apple every day.',
            'answer': 'eat',
            'options': ['eat', 'eats', 'eating', 'ate']
          },
          {
            'sentence': 'She _____ to school yesterday.',
            'answer': 'went',
            'options': ['went', 'go', 'goes', 'going']
          },
          {
            'sentence': 'The sun _____ bright today.',
            'answer': 'is',
            'options': ['is', 'are', 'was', 'were']
          },
          {
            'sentence': 'Birds _____ in the sky.',
            'answer': 'fly',
            'options': ['fly', 'flies', 'flying', 'flew']
          }
        ];
      case GameDifficulty.medium:
        return [
          {
            'sentence': 'If I _____ rich, I would travel the world.',
            'answer': 'were',
            'options': ['were', 'was', 'am', 'be']
          },
          {
            'sentence': 'She has _____ studying for three hours.',
            'answer': 'been',
            'options': ['been', 'being', 'be', 'was']
          },
          {
            'sentence': 'The book _____ by millions of people.',
            'answer': 'was read',
            'options': ['was read', 'read', 'reads', 'reading']
          },
          {
            'sentence': 'I wish I _____ speak French fluently.',
            'answer': 'could',
            'options': ['could', 'can', 'will', 'would']
          },
          {
            'sentence': 'The meeting _____ postponed until next week.',
            'answer': 'has been',
            'options': ['has been', 'have been', 'was', 'is']
          }
        ];
      case GameDifficulty.hard:
        return [
          {
            'sentence': 'Had she studied harder, she _____ passed the exam.',
            'answer': 'would have',
            'options': ['would have', 'will have', 'had', 'has']
          },
          {
            'sentence': 'The research _____ conducted over several years.',
            'answer': 'had been',
            'options': ['had been', 'has been', 'was', 'were']
          },
          {
            'sentence': 'Not only _____ he intelligent, but also hardworking.',
            'answer': 'is',
            'options': ['is', 'was', 'does', 'has']
          },
          {
            'sentence': 'I would rather you _____ not told him the truth.',
            'answer': 'had',
            'options': ['had', 'have', 'has', 'did']
          },
          {
            'sentence': 'Scarcely _____ he arrived when the meeting started.',
            'answer': 'had',
            'options': ['had', 'has', 'did', 'was']
          }
        ];
    }
  }

  List<Map<String, dynamic>> _getRhymesForDifficulty() {
    switch (_selectedDifficulty.value) {
      case GameDifficulty.easy:
        return [
          {
            'word': 'CAT',
            'rhyme': 'HAT',
            'options': ['DOG', 'SUN', 'TREE']
          },
          {
            'word': 'SUN',
            'rhyme': 'FUN',
            'options': ['MOON', 'STAR', 'CLOUD']
          },
          {
            'word': 'TREE',
            'rhyme': 'BEE',
            'options': ['LEAF', 'BIRD', 'NEST']
          },
          {
            'word': 'PLAY',
            'rhyme': 'DAY',
            'options': ['NIGHT', 'TIME', 'WORK']
          },
          {
            'word': 'LIGHT',
            'rhyme': 'BRIGHT',
            'options': ['DARK', 'LAMP', 'BULB']
          }
        ];
      case GameDifficulty.medium:
        return [
          {
            'word': 'MOUNTAIN',
            'rhyme': 'FOUNTAIN',
            'options': ['VALLEY', 'RIVER', 'STREAM']
          },
          {
            'word': 'EDUCATION',
            'rhyme': 'VACATION',
            'options': ['SCHOOL', 'LEARNING', 'TEACHING']
          },
          {
            'word': 'BEAUTIFUL',
            'rhyme': 'DUTIFUL',
            'options': ['UGLY', 'PRETTY', 'LOVELY']
          },
          {
            'word': 'ADVENTURE',
            'rhyme': 'VENTURE',
            'options': ['JOURNEY', 'TRAVEL', 'EXPLORE']
          },
          {
            'word': 'CELEBRATE',
            'rhyme': 'LATE',
            'options': ['PARTY', 'FESTIVAL', 'HAPPY']
          }
        ];
      case GameDifficulty.hard:
        return [
          {
            'word': 'SOPHISTICATED',
            'rhyme': 'COMPLICATED',
            'options': ['SIMPLE', 'ELEGANT', 'REFINED']
          },
          {
            'word': 'EXTRAORDINARY',
            'rhyme': 'ORDINARY',
            'options': ['SPECIAL', 'UNIQUE', 'AMAZING']
          },
          {
            'word': 'COMMUNICATION',
            'rhyme': 'INFORMATION',
            'options': ['SPEAKING', 'TALKING', 'LANGUAGE']
          },
          {
            'word': 'RESPONSIBILITY',
            'rhyme': 'ABILITY',
            'options': ['DUTY', 'OBLIGATION', 'TASK']
          },
          {
            'word': 'DETERMINATION',
            'rhyme': 'DESTINATION',
            'options': ['WILLPOWER', 'RESOLVE', 'STRENGTH']
          }
        ];
    }
  }

  List<Map<String, dynamic>> _getSynonymAntonymForDifficulty() {
    switch (_selectedDifficulty.value) {
      case GameDifficulty.easy:
        return [
          {
            'word': 'HAPPY',
            'correct': 'JOYFUL',
            'type': 'synonym',
            'options': ['SAD', 'ANGRY', 'TIRED']
          },
          {
            'word': 'BIG',
            'correct': 'SMALL',
            'type': 'antonym',
            'options': ['LARGE', 'HUGE', 'GIANT']
          },
          {
            'word': 'FAST',
            'correct': 'QUICK',
            'type': 'synonym',
            'options': ['SLOW', 'LAZY', 'TIRED']
          },
          {
            'word': 'HOT',
            'correct': 'COLD',
            'type': 'antonym',
            'options': ['WARM', 'BURNING', 'FIRE']
          },
          {
            'word': 'PRETTY',
            'correct': 'BEAUTIFUL',
            'type': 'synonym',
            'options': ['UGLY', 'PLAIN', 'SIMPLE']
          }
        ];
      case GameDifficulty.medium:
        return [
          {
            'word': 'MAGNIFICENT',
            'correct': 'SPLENDID',
            'type': 'synonym',
            'options': ['TERRIBLE', 'AWFUL', 'POOR']
          },
          {
            'word': 'ANCIENT',
            'correct': 'MODERN',
            'type': 'antonym',
            'options': ['OLD', 'HISTORIC', 'VINTAGE']
          },
          {
            'word': 'ABUNDANT',
            'correct': 'PLENTIFUL',
            'type': 'synonym',
            'options': ['SCARCE', 'RARE', 'LIMITED']
          },
          {
            'word': 'OPTIMISTIC',
            'correct': 'PESSIMISTIC',
            'type': 'antonym',
            'options': ['HOPEFUL', 'POSITIVE', 'CHEERFUL']
          },
          {
            'word': 'COURAGE',
            'correct': 'BRAVERY',
            'type': 'synonym',
            'options': ['FEAR', 'COWARDICE', 'WEAKNESS']
          }
        ];
      case GameDifficulty.hard:
        return [
          {
            'word': 'METICULOUS',
            'correct': 'CARELESS',
            'type': 'antonym',
            'options': ['CAREFUL', 'PRECISE', 'DETAILED']
          },
          {
            'word': 'ELOQUENT',
            'correct': 'ARTICULATE',
            'type': 'synonym',
            'options': ['SPEECHLESS', 'SILENT', 'MUTE']
          },
          {
            'word': 'GREGARIOUS',
            'correct': 'ANTISOCIAL',
            'type': 'antonym',
            'options': ['SOCIAL', 'FRIENDLY', 'OUTGOING']
          },
          {
            'word': 'BENEVOLENT',
            'correct': 'MALEVOLENT',
            'type': 'antonym',
            'options': ['KIND', 'GENEROUS', 'CHARITABLE']
          },
          {
            'word': 'PERSPICACIOUS',
            'correct': 'PERCEPTIVE',
            'type': 'synonym',
            'options': ['IGNORANT', 'FOOLISH', 'NAIVE']
          }
        ];
    }
  }

  List<Map<String, dynamic>> _getGrammarQuestionsForDifficulty() {
    switch (_selectedDifficulty.value) {
      case GameDifficulty.easy:
        return [
          {
            'incorrect': 'Me and John goes to school.',
            'correct': 'John and I go to school.',
            'options': [
              'John and I go to school.',
              'Me and John go to school.',
              'John and me goes to school.',
              'I and John goes to school.'
            ]
          },
          {
            'incorrect': 'She don\'t like apples.',
            'correct': 'She doesn\'t like apples.',
            'options': [
              'She doesn\'t like apples.',
              'She don\'t like apples.',
              'She not like apples.',
              'She no like apples.'
            ]
          },
          {
            'incorrect': 'There is three cats.',
            'correct': 'There are three cats.',
            'options': [
              'There are three cats.',
              'There is three cats.',
              'There be three cats.',
              'There was three cats.'
            ]
          },
          {
            'incorrect': 'I have ate breakfast.',
            'correct': 'I have eaten breakfast.',
            'options': [
              'I have eaten breakfast.',
              'I have ate breakfast.',
              'I had ate breakfast.',
              'I has eaten breakfast.'
            ]
          },
          {
            'incorrect': 'Him is my friend.',
            'correct': 'He is my friend.',
            'options': [
              'He is my friend.',
              'Him is my friend.',
              'His is my friend.',
              'He are my friend.'
            ]
          }
        ];
      case GameDifficulty.medium:
        return [
          {
            'incorrect': 'Between you and I, this is a secret.',
            'correct': 'Between you and me, this is a secret.',
            'options': [
              'Between you and me, this is a secret.',
              'Between you and I, this is a secret.',
              'Between I and you, this is a secret.',
              'Between me and you, this is a secret.'
            ]
          },
          {
            'incorrect': 'If I was rich, I would travel.',
            'correct': 'If I were rich, I would travel.',
            'options': [
              'If I were rich, I would travel.',
              'If I was rich, I would travel.',
              'If I am rich, I would travel.',
              'If I be rich, I would travel.'
            ]
          },
          {
            'incorrect': 'The data shows interesting results.',
            'correct': 'The data show interesting results.',
            'options': [
              'The data show interesting results.',
              'The data shows interesting results.',
              'The data showing interesting results.',
              'The data shown interesting results.'
            ]
          },
          {
            'incorrect': 'Neither the teacher nor the students was present.',
            'correct': 'Neither the teacher nor the students were present.',
            'options': [
              'Neither the teacher nor the students were present.',
              'Neither the teacher nor the students was present.',
              'Neither the teacher or the students were present.',
              'Neither the teacher nor the students are present.'
            ]
          },
          {
            'incorrect': 'Who did you give the book to?',
            'correct': 'To whom did you give the book?',
            'options': [
              'To whom did you give the book?',
              'Who did you give the book to?',
              'Whom did you give the book to?',
              'Who you gave the book to?'
            ]
          }
        ];
      case GameDifficulty.hard:
        return [
          {
            'incorrect': 'Having ate dinner, we watched a movie.',
            'correct': 'Having eaten dinner, we watched a movie.',
            'options': [
              'Having eaten dinner, we watched a movie.',
              'Having ate dinner, we watched a movie.',
              'Having eating dinner, we watched a movie.',
              'Have eaten dinner, we watched a movie.'
            ]
          },
          {
            'incorrect': 'The reason is because we were late.',
            'correct': 'The reason is that we were late.',
            'options': [
              'The reason is that we were late.',
              'The reason is because we were late.',
              'The reason being we were late.',
              'The reason why is we were late.'
            ]
          },
          {
            'incorrect': 'Each of the students have their own book.',
            'correct': 'Each of the students has his or her own book.',
            'options': [
              'Each of the students has his or her own book.',
              'Each of the students have their own book.',
              'Each of the students has their own book.',
              'Each of the students have his or her own book.'
            ]
          },
          {
            'incorrect': 'Irregardless of the weather, we will go.',
            'correct': 'Regardless of the weather, we will go.',
            'options': [
              'Regardless of the weather, we will go.',
              'Irregardless of the weather, we will go.',
              'Irrespective of the weather, we will go.',
              'Disregardless of the weather, we will go.'
            ]
          },
          {
            'incorrect': 'I could care less about that topic.',
            'correct': 'I couldn\'t care less about that topic.',
            'options': [
              'I couldn\'t care less about that topic.',
              'I could care less about that topic.',
              'I can care less about that topic.',
              'I would care less about that topic.'
            ]
          }
        ];
    }
  }
}
