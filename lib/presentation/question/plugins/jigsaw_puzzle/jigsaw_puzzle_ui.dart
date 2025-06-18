import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:EngKid/domain/quiz/entities/entites.dart';
import 'package:EngKid/utils/images.dart';
import 'package:EngKid/utils/lib_function.dart';
import 'package:EngKid/widgets/image/cache_image.dart';
import 'package:EngKid/widgets/shape/shape_quiz.dart';

import 'jigsaw_puzzle_controller.dart';

class JigsawPuzzleScreen extends StatelessWidget {
  final controller = Get.find<JigsawPuzzleController>();

  JigsawPuzzleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Obx(
      () => ShapeQuiz(
        content: Padding(
          padding: controller.isCompleted
              ? EdgeInsets.only(top: 0.08 * size.height)
              : EdgeInsets.only(top: 0.03 * size.height),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(LocalImage.shapeJigsawPuzzle),
                      fit: BoxFit.fill,
                    ),
                  ),
                  width: !controller.isCompleted || controller.options.length>3
                      ? 0.26 * size.height * controller.options.length
                      : 0.36 * size.height * controller.options.length,
                  height: !controller.isCompleted || controller.options.length>3
                      ? 0.275 * size.height
                      : 0.375 * size.height,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: List.generate(
                      controller.options.length,
                      (index) => DragTarget<Rx<Option>>(
                        builder: (context, candidateData, rejectedData) {
                          return GestureDetector(
                            onTap: () => controller.cancelRelation(index),
                            child: Container(
                              width: !controller.isCompleted|| controller.options.length>3
                                  ? 0.25 * size.height
                                  : 0.35 * size.height,
                              height: !controller.isCompleted|| controller.options.length>3
                                  ? 0.25 * size.height
                                  : 0.35 * size.height,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: !controller.isCompleted
                                    ? Border(
                                        left: BorderSide(
                                          //                   <--- left side
                                          color: Colors.brown,
                                          width: 0.002 * size.width,
                                        ),
                                        right: BorderSide(
                                          //                    <--- top side
                                          color: Colors.brown,
                                          width: 0.002 * size.width,
                                        ),
                                      )
                                    : null,
                              ),
                              child: controller.getImageInPosition(index) != ""
                                  ? CacheImage(
                                      url: controller.getImageInPosition(index),
                                      width: !controller.isCompleted
                                          ? 0.25 * size.height
                                          : 0.35 * size.height,
                                      height: !controller.isCompleted
                                          ? 0.25 * size.height
                                          : 0.35 * size.height,
                                    )
                                  : const SizedBox(),
                            ),
                          );
                        },
                        onAccept: (data) {
                          if (controller.enableDragTo(index)) {
                            controller.onCorrect(data, index);
                          }
                        },
                        onWillAccept: (data) => controller.enableDragTo(index),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 0.02 * size.height),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: List.generate(
                    controller.options.length,
                    (index) => controller.options[index].value.position != -1
                        ? const SizedBox()
                        : DragItem(
                            controller: controller, size: size, index: index),
                  ),
                )
              ]),
        ),
        onSubmit: () {
          controller.onSubmit();
        },
        quiz: controller.question.question,
        level: controller.question.level,
        isCompleted: controller.isCompleted,
        bg: controller.question.background,
        sub: 'Em hãy kéo đáp án đúng vào chỗ trống!',
        question: controller.question,
      ),
    );
  }
}

class DragItem extends StatelessWidget {
  const DragItem({
    super.key,
    required this.controller,
    required this.size,
    required this.index,
  });

  final JigsawPuzzleController controller;
  final Size size;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Draggable<Rx<Option>>(
      data: controller.options[index],
      childWhenDragging: Padding(
        padding: const EdgeInsets.all(5),
        child: SizedBox(
          width: 0.25 * size.height,
          height: 0.25 * size.height,
        ),
      ),
      feedback: Padding(
        padding: const EdgeInsets.all(5),
        child: CacheImage(
          url: controller.options[index].value.image,
          width: 0.25 * size.height,
          height: 0.25 * size.height,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.5),
                spreadRadius: 1,
                blurRadius: 2,
                offset: const Offset(
                  2,
                  2,
                ), // changes position of shadow
              ),
            ],
          ),
          width: 0.25 * size.height,
          height: 0.25 * size.height,
          child: CacheImage(
            url: controller.options[index].value.image,
            width: 0.25 * size.height,
            height: 0.25 * size.height,
          ),
        ),
      ),
      onDraggableCanceled: (Velocity velocity, Offset offset) {
        LibFunction.effectWrongAnswer();
      },
    );
  }
}
