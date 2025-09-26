import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:EngKid/utils/images.dart';
import 'package:EngKid/utils/app_color.dart';
import 'four_pics_one_word_controller.dart';

class FourPicsOneWordUI extends GetView<FourPicsOneWordController> {
  const FourPicsOneWordUI({super.key});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: false,
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
            child: Obx(() {
              if (controller.isLoading) {
                return _buildLoadingScreen();
              }
              return _buildGameContent(size);
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingScreen() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
          SizedBox(height: 20),
          Text(
            'Loading 4 Pics 1 Word...',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGameContent(Size size) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Header with back button, title and score
          _buildHeader(size),
          const SizedBox(height: 15),
          // Four pictures grid
          _buildSinglePicture(size),
          const SizedBox(height: 15),
          // Answer input area
          _buildAnswerInputArea(size),
          const SizedBox(height: 15),
          // Letter selection area
          _buildLetterSelectionArea(size),
          const SizedBox(height: 15),
          // Action buttons
          _buildActionButtons(size),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildHeader(Size size) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Back button
          GestureDetector(
            onTap: () => Get.back(),
            child: Image.asset(
              LocalImage.backButton,
              width: 60,
              height: 60,
            ),
          ),
          // Title
          Expanded(
            child: Text(
              '4 PICS 1 WORD',
              style: TextStyle(
                fontSize: 22,
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
              textAlign: TextAlign.center,
            ),
          ),
          // Score and hints
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Obx(() => Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.amber,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.star, color: Colors.white, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      '${controller.score}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              )),
              const SizedBox(height: 4),
              Obx(() => GestureDetector(
                onTap: controller.useHint,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: controller.hints > 0 ? Colors.blue : Colors.grey,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.lightbulb, color: Colors.white, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        '${controller.hints}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              )),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSinglePicture(Size size) {
    return Obx(() {
      final question = controller.currentQuestion;
      if (question == null) return const SizedBox();

      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.95),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min, // container co gọn theo nội dung
          children: [
            Text(
              'What is this?',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColor.primary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: MediaQuery.of(Get.context!).size.width * 0.2, //40% chiều rộng màn hình
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    question.imagePaths,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        color: Colors.grey.shade200,
                        child: Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                                : null,
                            valueColor: AlwaysStoppedAnimation<Color>(AppColor.primary),
                          ),
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey.shade200,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.image,
                              size: 40,
                              color: Colors.grey.shade400,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Image',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }



  Widget _buildAnswerInputArea(Size size) {
    return Obx(() {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.95),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Text(
              'Tap letters to spell the word:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColor.primary,
              ),
            ),
            const SizedBox(height: 16),
            // Answer boxes
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                controller.currentAnswer.length,
                (index) {
                  final hasLetter = index < controller.selectedLetters.length;
                  return GestureDetector(
                    onTap: hasLetter ? () => controller.removeLetter(index) : null,
                    child: Container(
                      width: 45,
                      height: 45,
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      decoration: BoxDecoration(
                        color: hasLetter ? AppColor.primary.withOpacity(0.1) : Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: hasLetter ? AppColor.primary : Colors.grey.shade300,
                          width: 2,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          hasLetter ? controller.selectedLetters[index] : '',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColor.primary,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            // Show hint if activated
            if (controller.showHint) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue.shade200),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.lightbulb,
                      color: Colors.blue.shade600,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        controller.currentQuestion?.hint ?? '',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.blue.shade700,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      );
    });
  }

  Widget _buildLetterSelectionArea(Size size) {
    return Obx(() {
      if (controller.gameFinished) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.95),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              Icon(
                controller.answeredCorrectly ? Icons.celebration : Icons.refresh,
                size: 50,
                color: controller.answeredCorrectly ? Colors.green : Colors.orange,
              ),
              const SizedBox(height: 12),
              Text(
                controller.answeredCorrectly 
                    ? 'Congratulations! 🎉'
                    : 'Want to try again? 🔄',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: controller.answeredCorrectly ? Colors.green : Colors.orange,
                ),
                textAlign: TextAlign.center,
              ),
              if (controller.answeredCorrectly) ...[
                const SizedBox(height: 8),
                Text(
                  'You solved the puzzle correctly!',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ],
          ),
        );
      }

      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.95),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Text(
              'Available Letters:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColor.primary,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: controller.availableLetters.asMap().entries.map((entry) {
                final index = entry.key;
                final letter = entry.value;
                return GestureDetector(
                  onTap: () => controller.selectLetter(letter, index),
                  child: Container(
                    width: 45,
                    height: 45,
                    decoration: BoxDecoration(
                      color: Colors.orange.shade100,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Colors.orange.shade300,
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.orange.withOpacity(0.2),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        letter,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange.shade700,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildActionButtons(Size size) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Obx(() {
        if (controller.gameFinished) {
          return Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () => Get.back(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade500,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 4,
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.home, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Home',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        }

        return Row(
          children: [
            // Listen button
            Expanded(
              child: ElevatedButton(
                onPressed: controller.currentQuestion != null
                    ? () => controller.speakWord(controller.currentAnswer)
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple.shade500,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 4,
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.volume_up, size: 20),
                    SizedBox(width: 8),
                    Text(
                      'Listen',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
