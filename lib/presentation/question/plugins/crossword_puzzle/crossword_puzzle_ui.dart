import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:EngKid/utils/app_color.dart';
import 'package:EngKid/utils/font_size.dart';
import 'package:EngKid/utils/images.dart';
import 'package:EngKid/utils/lib_function.dart';
import 'package:EngKid/widgets/button/image_button.dart';
import 'package:EngKid/widgets/dialog/dialog_puzzle_question.dart';
import 'package:EngKid/widgets/input/landscape_textfield.dart';
import 'package:EngKid/widgets/shape/shape_quiz.dart';

import 'crossword_puzzle_controller.dart';

class CrosswordPuzzleScreen extends StatelessWidget {
  final controller = Get.find<CrosswordPuzzleController>();

  CrosswordPuzzleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final int rows = controller.optionAnswers.length; // Number of rows in the grid
    final int columns = controller.numberOfColumn; // Number of columns in the grid
    return Stack(
      children: [
        Obx(
              () => ShapeQuiz(
            content: Stack(
              children: [
                Center(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: AspectRatio(
                      aspectRatio: columns / rows, // Maintain the grid's aspect ratio
                      child: Obx(
                            () => GridView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: columns,
                          ),
                          itemCount: controller.puzzle.length * columns,
                          itemBuilder: (context, index) {
                            final row = index ~/ columns;
                            final col = index % columns;

                            final letter = (row < controller.puzzle.length &&
                                col < (controller.puzzle[row].length ?? 0))
                                ? controller.puzzle[row][col]
                                : null;

                            return GestureDetector(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return PuzzleQuestionDialog(
                                      question: controller.optionQuestions[row],
                                      onSubmit: (answer) {
                                        controller.onChangeInput(
                                          questionIndex: row,
                                          input: answer,
                                        );
                                      },
                                      limitInput: controller.optionAnswers[row].length,
                                    );
                                  },
                                );
                              },
                              child: Container(
                                margin: const EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  color: letter == null
                                      ? Colors.transparent
                                      : (col == columns / 2 - 1 ? Colors.amberAccent : Colors.blue),
                                  border: Border.all(
                                    color: letter == null ? Colors.transparent : Colors.black,
                                  ),
                                ),
                                child: letter != null
                                    ? Center(
                                  child: Text(
                                    letter,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                )
                                    : const SizedBox.shrink(),
                              ),
                            );
                          },
                        ),
                      )

                    ),
                  ),
                ),
              ],
            ),
            onSubmit: () {
              controller.onSubmitPress();
            },
            quiz: controller.question.question,
            bg: controller.question.background,
            sub:
            'Em hãy điền câu vào ô trống hoặc nhấn vào biểu tượng micro để thu âm câu trả lời!',
            level: controller.question.level,
            isCompleted: controller.isCompleted,
            question: controller.question,
          ),
        ),
      ],
    );
  }
}