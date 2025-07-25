import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:EngKid/utils/images.dart';
import 'package:EngKid/utils/app_color.dart';
import 'wordle_game_controller.dart';

class WordleGameUI extends GetView<WordleGameController> {
  const WordleGameUI({super.key});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: false, // Prevent keyboard from resizing
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
            child: GestureDetector(
              onTap: () {
                // Hide keyboard when tapping outside boxes
                controller.hideKeyboard();
              },
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),
                      child: Column(
                        children: [
                          // Header
                          _buildHeader(size),
                          // Game board - show all rows when keyboard is hidden, only current row when visible
                          _buildGameBoard(size),
                          // Keyboard - only show when a box is focused and game not finished
                          Obx(() => controller.isKeyboardVisible &&
                                  !controller.gameFinished
                              ? _buildKeyboard(size)
                              : const SizedBox.shrink()),
                          // Spacing for better layout
                          const SizedBox(height: 20),
                          const SizedBox(height: 5),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(Size size) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
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
          // Title and difficulty
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'WORDLE',
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
              Obx(() => controller.isLoading
                  ? const SizedBox(
                      height: 16,
                      width: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Text(
                      'Word Length: ${controller.wordLength} letters',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.white70,
                      ),
                    )),
            ],
          ),
          // Menu button
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Colors.white, size: 30),
            onSelected: (value) {
              switch (value) {
                case 'hint':
                  controller.showHint();
                  break;
                case 'reset':
                  controller.resetGame();
                  break;
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'hint',
                child: Row(
                  children: [
                    Icon(Icons.lightbulb, color: Colors.orange),
                    SizedBox(width: 8),
                    Text('Hint'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'reset',
                child: Row(
                  children: [
                    Icon(Icons.refresh, color: Colors.blue),
                    SizedBox(width: 8),
                    Text('New Game'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGameBoard(Size size) {
    return GestureDetector(
      onTap: () {
        // Don't hide keyboard when tapping on game board - let users use close button
      },
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Center(
          child: Obx(() {
            // Show loading indicator when loading
            if (controller.isLoading) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Loading new word...',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: size.width * 0.04,
                    ),
                  ),
                ],
              );
            }

            // Add null safety checks
            if (controller.guesses.isEmpty ||
                controller.currentRow < 0 ||
                controller.maxAttempts <= 0) {
              return const SizedBox.shrink();
            }

            // When keyboard is visible, show only current row
            // When keyboard is hidden, show all rows
            if (controller.isKeyboardVisible) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Show previous completed rows (compressed)
                  if (controller.currentRow > 0) _buildCompressedHistory(size),
                  // Current active row - ensure valid index
                  if (controller.currentRow < controller.maxAttempts)
                    _buildGuessRow(controller.currentRow, size),
                ],
              );
            } else {
              // Show all rows when keyboard is hidden
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: List.generate(
                  controller.maxAttempts,
                  (rowIndex) => _buildGuessRow(rowIndex, size),
                ),
              );
            }
          }),
        ),
      ),
    );
  }

  Widget _buildGuessRow(int rowIndex, Size size) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 1), // Reduced from 2 to 1
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          controller.wordLength,
          (colIndex) => _buildLetterBox(rowIndex, colIndex, size),
        ),
      ),
    );
  }

  Widget _buildCompressedHistory(Size size) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Previous attempts: ${controller.currentRow}',
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 4),
          // Show a compressed view of the last attempt with null safety
          if (controller.currentRow > 0 &&
              controller.currentRow - 1 < controller.guesses.length)
            _buildCompressedRow(controller.currentRow - 1, size),
        ],
      ),
    );
  }

  Widget _buildCompressedRow(int rowIndex, Size size) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 1),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          controller.wordLength,
          (colIndex) => _buildCompressedLetterBox(rowIndex, colIndex, size),
        ),
      ),
    );
  }

  Widget _buildCompressedLetterBox(int rowIndex, int colIndex, Size size) {
    return Obx(() {
      // Add bounds checking
      if (rowIndex >= controller.guesses.length ||
          colIndex >= controller.wordLength ||
          rowIndex < 0 ||
          colIndex < 0) {
        return const SizedBox.shrink();
      }

      final letter = controller.guesses[rowIndex][colIndex];
      double boxSize = 20.0; // Fixed small size for compressed view

      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 1, vertical: 0.5),
        width: boxSize,
        height: boxSize,
        decoration: BoxDecoration(
          color: controller.getLetterColor(letter.status),
          border: Border.all(
            color: controller.getLetterBorderColor(letter.status),
            width: 1,
          ),
          borderRadius: BorderRadius.circular(3),
        ),
        child: Center(
          child: Text(
            letter.letter,
            style: TextStyle(
              fontSize: boxSize * 0.4,
              fontWeight: FontWeight.bold,
              color: letter.status == LetterStatus.empty
                  ? Colors.black
                  : Colors.white,
            ),
          ),
        ),
      );
    });
  }

  Widget _buildLetterBox(int rowIndex, int colIndex, Size size) {
    return Obx(() {
      final letter = controller.guesses[rowIndex][colIndex];
      final isCurrentBox = rowIndex == controller.currentRow &&
          colIndex == controller.currentCol;

      // Calculate responsive box size - made smaller
      double boxSize = (size.width * 0.45 / controller.wordLength) -
          4; // Reduced from 0.5 to 0.45
      boxSize =
          boxSize.clamp(20.0, 40.0); // Further reduced from 25-45 to 20-40

      return GestureDetector(
        onTap: () {
          // Only allow tapping on current row and if game is not finished
          if (rowIndex == controller.currentRow && !controller.gameFinished) {
            controller.showKeyboard();
          }
        },
        behavior: HitTestBehavior.opaque, // Prevent tap from propagating
        child: Container(
          margin: const EdgeInsets.symmetric(
              horizontal: 1, vertical: 0.5), // Reduced margins
          width: boxSize,
          height: boxSize,
          decoration: BoxDecoration(
            color: controller.getLetterColor(letter.status),
            border: Border.all(
              color: isCurrentBox
                  ? AppColor.blue
                  : controller.getLetterBorderColor(letter.status),
              width: isCurrentBox ? 3 : 2,
            ),
            borderRadius: BorderRadius.circular(6),
            boxShadow: [
              BoxShadow(
                offset: const Offset(1, 1),
                blurRadius: 2,
                color: Colors.black.withOpacity(0.2),
              ),
            ],
          ),
          child: Center(
            child: Text(
              letter.letter,
              style: TextStyle(
                fontSize: boxSize * 0.45,
                fontWeight: FontWeight.bold,
                color: letter.status == LetterStatus.empty
                    ? Colors.black
                    : Colors.white,
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget _buildKeyboard(Size size) {
    const List<List<String>> keyboardLayout = [
      ['Q', 'W', 'E', 'R', 'T', 'Y', 'U', 'I', 'O', 'P'],
      ['A', 'S', 'D', 'F', 'G', 'H', 'J', 'K', 'L'],
      ['ENTER', 'Z', 'X', 'C', 'V', 'B', 'N', 'M', 'CLOSE', 'BACKSPACE'],
    ];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Keyboard rows
          ...keyboardLayout.map((row) => _buildKeyboardRow(row, size)).toList(),
        ],
      ),
    );
  }

  Widget _buildKeyboardRow(List<String> keys, Size size) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: keys.map((key) => _buildKey(key, size)).toList(),
      ),
    );
  }

  Widget _buildKey(String key, Size size) {
    final keySize = size.width * 0.06; // Adjusted for better fit
    bool isSpecialKey = key == 'ENTER' || key == 'BACKSPACE' || key == 'CLOSE';
    double keyWidth = isSpecialKey ? keySize + 10 : keySize;
    double keyHeight = keySize; // Fixed

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 1),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            if (key == 'CLOSE') {
              controller.hideKeyboard();
            } else {
              controller.onKeyPressed(key);
            }
          },
          borderRadius: BorderRadius.circular(4),
          child: Container(
            width: keyWidth,
            height: keyHeight,
            decoration: BoxDecoration(
              color: _getKeyColor(key),
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: Colors.grey.shade400),
              boxShadow: [
                BoxShadow(
                  offset: const Offset(1, 1),
                  blurRadius: 2,
                  color: Colors.black.withOpacity(0.2),
                ),
              ],
            ),
            child: Center(
              child: _getKeyContent(key, size),
            ),
          ),
        ),
      ),
    );
  }

  Widget _getKeyContent(String key, Size size) {
    if (key == 'BACKSPACE') {
      return const Icon(
        Icons.backspace_outlined,
        color: Colors.white,
        size: 18,
      );
    } else if (key == 'ENTER') {
      return Text(
        'GO',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: size.width * 0.025,
        ),
      );
    } else if (key == 'CLOSE') {
      return const Icon(
        Icons.keyboard_hide,
        color: Colors.white,
        size: 16,
      );
    } else {
      return Text(
        key,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: size.width * 0.03,
        ),
      );
    }
  }

  Color _getKeyColor(String key) {
    if (key == 'ENTER') {
      return AppColor.green;
    } else if (key == 'BACKSPACE') {
      return AppColor.red;
    } else if (key == 'CLOSE') {
      return Colors.orange; // Distinct color for close button
    } else {
      return AppColor.blue;
    }
  }
}
