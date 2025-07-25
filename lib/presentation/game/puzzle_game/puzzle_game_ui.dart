import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:EngKid/utils/images.dart';
import 'package:EngKid/utils/app_color.dart';
import 'puzzle_game_controller.dart';

class PuzzleGameUI extends GetView<PuzzleGameController> {
  const PuzzleGameUI({super.key});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Image.asset(
            LocalImage.backgroundBlue,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          SafeArea(
            child: Obx(() => controller.gameStarted
                ? _buildGameScreen(size)
                : _buildSetupScreen(size)),
          ),
        ],
      ),
    );
  }

  Widget _buildSetupScreen(Size size) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Header
          _buildHeader(),
          const SizedBox(height: 30),

          // Game Setup Options
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Puzzle Type Selection
                  _buildSectionTitle('Choose Puzzle Type'),
                  const SizedBox(height: 16),
                  _buildPuzzleTypeSelector(),
                  const SizedBox(height: 30),

                  // Difficulty Selection
                  _buildSectionTitle('Choose Difficulty'),
                  const SizedBox(height: 16),
                  _buildDifficultySelector(),
                  const SizedBox(height: 30),

                  // Game Settings
                  _buildSectionTitle('Game Settings'),
                  const SizedBox(height: 16),
                  _buildGameSettings(),
                  const SizedBox(height: 30),

                  // Start Button
                  _buildStartButton(size),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGameScreen(Size size) {
    return Column(
      children: [
        // Fixed header section
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Game Header
              _buildGameHeader(),
              const SizedBox(height: 20),

              // Progress and Timer
              _buildProgressSection(),
              const SizedBox(height: 20),
            ],
          ),
        ),

        // Scrollable question section
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Obx(() => controller.currentQuestion != null
                ? _buildQuestionSection(size)
                : _buildLoadingSection()),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Back button
        GestureDetector(
          onTap: () => Get.back(),
          child: Image.asset(
            LocalImage.backButton,
            width: 35,
            height: 35,
          ),
        ),
        // Title
        Text(
          'PUZZLE GAME',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            shadows: [
              Shadow(
                offset: const Offset(2, 2),
                blurRadius: 4,
                color: Colors.black.withOpacity(0.5),
              ),
            ],
          ),
        ),
        const SizedBox(width: 35), // Balance the layout
      ],
    );
  }

  Widget _buildGameHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Back/Pause button
        GestureDetector(
          onTap: () {
            controller.pauseGame();
            _showPauseDialog();
          },
          child: Image.asset(
            LocalImage.backButton,
            width: 35,
            height: 35,
          ),
        ),
        // Title and Score
        Column(
          children: [
            Text(
              'PUZZLE GAME',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                shadows: [
                  Shadow(
                    offset: const Offset(2, 2),
                    blurRadius: 4,
                    color: Colors.black.withOpacity(0.5),
                  ),
                ],
              ),
            ),
            Obx(() => Text(
                  'Score: ${controller.score}/${controller.totalQuestions}',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                )),
          ],
        ),
        // Timer
        Obx(() => controller.gameTimeLimit > 0
            ? Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: controller.timeRemaining <= 10
                      ? Colors.red.withOpacity(0.8)
                      : Colors.blue.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${controller.timeRemaining}s',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              )
            : const SizedBox(width: 60)),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.white,
        shadows: [
          Shadow(
            offset: const Offset(1, 1),
            blurRadius: 2,
            color: Colors.black.withOpacity(0.5),
          ),
        ],
      ),
    );
  }

  Widget _buildPuzzleTypeSelector() {
    return Obx(() => Column(
          children: PuzzleType.values.map((type) {
            final isSelected = controller.selectedPuzzleType == type;
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              child: GestureDetector(
                onTap: () => controller.setPuzzleType(type),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColor.primary.withOpacity(0.8)
                        : Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected ? AppColor.primary : Colors.grey,
                      width: 2,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        _getPuzzleTypeIcon(type),
                        color: isSelected ? Colors.white : AppColor.primary,
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _getPuzzleTypeName(type),
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color:
                                    isSelected ? Colors.white : Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _getPuzzleTypeDescription(type),
                              style: TextStyle(
                                fontSize: 14,
                                color: isSelected
                                    ? Colors.white70
                                    : Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ));
  }

  Widget _buildDifficultySelector() {
    return Obx(() => Row(
          children: GameDifficulty.values.map((difficulty) {
            final isSelected = controller.selectedDifficulty == difficulty;
            return Expanded(
              child: Container(
                margin: const EdgeInsets.only(right: 8),
                child: GestureDetector(
                  onTap: () => controller.setDifficulty(difficulty),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? _getDifficultyColor(difficulty)
                          : Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected
                            ? _getDifficultyColor(difficulty)
                            : Colors.grey,
                        width: 2,
                      ),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          _getDifficultyIcon(difficulty),
                          color: isSelected
                              ? Colors.white
                              : _getDifficultyColor(difficulty),
                          size: 28,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          difficulty.name.toUpperCase(),
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: isSelected
                                ? Colors.white
                                : _getDifficultyColor(difficulty),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ));
  }

  Widget _buildGameSettings() {
    return Column(
      children: [
        // Questions per game
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Questions per game:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              Obx(() => DropdownButton<int>(
                    value: controller.questionsPerGame,
                    items: [5, 10, 15, 20].map((count) {
                      return DropdownMenuItem(
                        value: count,
                        child: Text('$count'),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        controller.setQuestionsPerGame(value);
                      }
                    },
                  )),
            ],
          ),
        ),
        const SizedBox(height: 12),
        // Time limit
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Time limit (seconds):',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              Obx(() => DropdownButton<int>(
                    value: controller.gameTimeLimit,
                    items: [0, 30, 60, 90, 120].map((time) {
                      return DropdownMenuItem(
                        value: time,
                        child: Text(time == 0 ? 'No limit' : '${time}s'),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        controller.setTimeLimit(value);
                      }
                    },
                  )),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStartButton(Size size) {
    return Obx(() => GestureDetector(
          onTap: controller.isLoading ? null : () => controller.startGame(),
          child: Container(
            width: size.width * 0.8,
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              gradient: controller.isLoading
                  ? null
                  : LinearGradient(
                      colors: [AppColor.primary, AppColor.secondary],
                    ),
              color: controller.isLoading ? Colors.grey : null,
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  offset: const Offset(0, 4),
                  blurRadius: 8,
                ),
              ],
            ),
            child: controller.isLoading
                ? const Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  )
                : const Text(
                    'START GAME',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
          ),
        ));
  }

  Widget _buildProgressSection() {
    return Obx(() => Column(
          children: [
            // Progress bar
            LinearProgressIndicator(
              value: controller.progress,
              backgroundColor: Colors.white.withOpacity(0.3),
              valueColor: AlwaysStoppedAnimation<Color>(AppColor.primary),
              minHeight: 8,
            ),
            const SizedBox(height: 8),
            // Question counter
            Text(
              'Question ${controller.currentQuestionIndex + 1} of ${controller.totalQuestions}',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ));
  }

  Widget _buildQuestionSection(Size size) {
    return Obx(() {
      final question = controller.currentQuestion!;

      return SingleChildScrollView(
        child: Column(
          children: [
            // Question card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.95),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    offset: const Offset(0, 4),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Puzzle type indicator
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColor.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      _getPuzzleTypeName(question.type),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AppColor.primary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Question text
                  Text(
                    question.question,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Options
            ...question.options.asMap().entries.map((entry) {
              final index = entry.key;
              final option = entry.value;
              final isSelected = controller.selectedAnswer == option;
              final showResult = controller.showResult;
              final isCorrect = option == question.correctAnswer;

              Color? backgroundColor;
              Color? textColor;
              Color? borderColor;

              if (showResult) {
                if (isCorrect) {
                  backgroundColor = Colors.green.withOpacity(0.8);
                  textColor = Colors.white;
                  borderColor = Colors.green;
                } else if (isSelected && !isCorrect) {
                  backgroundColor = Colors.red.withOpacity(0.8);
                  textColor = Colors.white;
                  borderColor = Colors.red;
                } else {
                  backgroundColor = Colors.white.withOpacity(0.9);
                  textColor = Colors.black54;
                  borderColor = Colors.grey;
                }
              } else {
                if (isSelected) {
                  backgroundColor = AppColor.primary.withOpacity(0.8);
                  textColor = Colors.white;
                  borderColor = AppColor.primary;
                } else {
                  backgroundColor = Colors.white.withOpacity(0.9);
                  textColor = Colors.black87;
                  borderColor = Colors.grey;
                }
              }

              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                child: GestureDetector(
                  onTap:
                      showResult ? null : () => controller.selectAnswer(option),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: backgroundColor,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: borderColor,
                        width: 2,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isSelected || (showResult && isCorrect)
                                ? Colors.white
                                : Colors.transparent,
                            border: Border.all(
                              color: isSelected || (showResult && isCorrect)
                                  ? Colors.transparent
                                  : borderColor,
                              width: 2,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              String.fromCharCode(65 + index), // A, B, C, D
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: isSelected || (showResult && isCorrect)
                                    ? borderColor
                                    : borderColor,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            option,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: textColor,
                            ),
                          ),
                        ),
                        if (showResult && isCorrect)
                          const Icon(
                            Icons.check_circle,
                            color: Colors.white,
                            size: 24,
                          ),
                        if (showResult && isSelected && !isCorrect)
                          const Icon(
                            Icons.cancel,
                            color: Colors.white,
                            size: 24,
                          ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),

            // Submit button
            if (!controller.showResult)
              Container(
                margin: const EdgeInsets.only(top: 16),
                child: GestureDetector(
                  onTap: controller.selectedAnswer.isEmpty
                      ? null
                      : () => controller.submitAnswer(),
                  child: Container(
                    width: size.width * 0.8,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      gradient: controller.selectedAnswer.isEmpty
                          ? null
                          : LinearGradient(
                              colors: [AppColor.primary, AppColor.secondary],
                            ),
                      color: controller.selectedAnswer.isEmpty
                          ? Colors.grey
                          : null,
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          offset: const Offset(0, 4),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    child: const Text(
                      'SUBMIT',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),

            // Explanation (shown after answer)
            if (controller.showResult)
              Container(
                margin: const EdgeInsets.only(top: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.blue.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.info_outline,
                      color: Colors.blue,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        question.explanation,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.blue,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            // Add extra spacing at the bottom for better scrolling
            const SizedBox(height: 20),
          ],
        ),
      );
    });
  }

  Widget _buildLoadingSection() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: Colors.white),
          SizedBox(height: 16),
          Text(
            'Loading questions...',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  void _showPauseDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text('Game Paused'),
        content: const Text('What would you like to do?'),
        actions: [
          TextButton(
            onPressed: () {
              Get.back(); // Close dialog
              controller.resumeGame();
            },
            child: const Text('Resume'),
          ),
          TextButton(
            onPressed: () {
              Get.back(); // Close dialog
              controller.resetGame();
            },
            child: const Text('Restart'),
          ),
          TextButton(
            onPressed: () {
              Get.back(); // Close dialog
              Get.back(); // Return to previous screen
            },
            child: const Text('Exit'),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  // Helper methods for UI
  IconData _getPuzzleTypeIcon(PuzzleType type) {
    switch (type) {
      case PuzzleType.wordScramble:
        return Icons.shuffle;
      case PuzzleType.fillInBlank:
        return Icons.edit;
      case PuzzleType.rhymeMatch:
        return Icons.music_note;
      case PuzzleType.synonymAntonym:
        return Icons.compare_arrows;
      case PuzzleType.grammarFix:
        return Icons.spellcheck;
    }
  }

  String _getPuzzleTypeName(PuzzleType type) {
    switch (type) {
      case PuzzleType.wordScramble:
        return 'Word Scramble';
      case PuzzleType.fillInBlank:
        return 'Fill in the Blank';
      case PuzzleType.rhymeMatch:
        return 'Rhyme Match';
      case PuzzleType.synonymAntonym:
        return 'Synonym & Antonym';
      case PuzzleType.grammarFix:
        return 'Grammar Fix';
    }
  }

  String _getPuzzleTypeDescription(PuzzleType type) {
    switch (type) {
      case PuzzleType.wordScramble:
        return 'Unscramble mixed-up letters to form words';
      case PuzzleType.fillInBlank:
        return 'Complete sentences with the correct words';
      case PuzzleType.rhymeMatch:
        return 'Find words that rhyme with given words';
      case PuzzleType.synonymAntonym:
        return 'Identify synonyms and antonyms';
      case PuzzleType.grammarFix:
        return 'Correct grammatical errors in sentences';
    }
  }

  IconData _getDifficultyIcon(GameDifficulty difficulty) {
    switch (difficulty) {
      case GameDifficulty.easy:
        return Icons.sentiment_satisfied;
      case GameDifficulty.medium:
        return Icons.sentiment_neutral;
      case GameDifficulty.hard:
        return Icons.sentiment_very_dissatisfied;
    }
  }

  Color _getDifficultyColor(GameDifficulty difficulty) {
    switch (difficulty) {
      case GameDifficulty.easy:
        return Colors.green;
      case GameDifficulty.medium:
        return Colors.orange;
      case GameDifficulty.hard:
        return Colors.red;
    }
  }
}
