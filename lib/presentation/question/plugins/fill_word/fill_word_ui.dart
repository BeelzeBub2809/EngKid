import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:EngKid/domain/quiz/entities/entites.dart';
import 'package:EngKid/utils/app_color.dart';
import 'package:EngKid/utils/font_size.dart';
import 'package:EngKid/utils/images.dart';
import 'package:EngKid/utils/lib_function.dart';
import 'package:EngKid/widgets/shape/shape_quiz.dart';
import 'package:EngKid/widgets/text/image_text.dart';
import 'package:EngKid/widgets/text/regular_text.dart';

import '../../../../widgets/image/cache_image.dart';
import 'fill_word_controller.dart';

class FillWordScreen extends StatelessWidget {
  final controller = Get.find<FillWordController>();
  final scrollController = ScrollController();

  FillWordScreen({super.key});
  @override
  Widget build(BuildContext context) {

    final Size size = MediaQuery.of(context).size;
    void autoScroll(DragUpdateDetails details) {
      final position = details.localPosition.dy;
      if (position < 100) {
        scrollController.animateTo(scrollController.offset - 50,
            duration: const Duration(milliseconds: 100), curve: Curves.linear);
      } else if (position > size.height - 100) {
        scrollController.animateTo(scrollController.offset + 50,
            duration: const Duration(milliseconds: 100), curve: Curves.linear);
      }
    }

    String? findOptionWithPosition(List<Option> answers, int y) {
      for (var answer in answers) {
        if (answer.position == y) {
          return answer.option; // Return the option where position matches y
        }
      }
      return null; // Return null if no match is found
    }
    print("ok thoi");
    for(var answer in controller.questions) {
      print(answer.position);
      print(answer.option);
    }
    // select one
    return !controller.isMulti
        ? Obx(
          () => ShapeQuiz(
        content: Padding(
          padding: EdgeInsets.all(0.07 * size.height),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Wrap(
                spacing: 8.0, // gap between adjacent chips
                runSpacing: 4.0, // gap between lines
                alignment: WrapAlignment.start,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: List.generate(
                  controller.questions.length,
                      (index) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      controller.questions[index].optionId != -1 &&
                          controller.questions[index].optionType != "answer"
                          ? RegularText(
                        controller.questions[index].option,
                        maxLines: 100,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      )
                          : findOptionWithPosition(controller.answers, index ~/ 2) == ""
                          ? SizedBox(width: size.width)
                          : Stack(
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min, // Ensure the Row only takes the necessary space
                            children: [
                              DragTarget<Option>(
                                builder: (context, accept, reject) {
                                  return GestureDetector(
                                    onTap: () => controller.cancelRelation(
                                        controller.questions[index].optionId, index),
                                    child: Container(
                                      width: LibFunction.scaleForCurrentValue(
                                          size, controller.isLong ? 460 : 200),
                                      height: LibFunction.scaleForCurrentValue(size, 92),
                                      decoration: const BoxDecoration(
                                        image: DecorationImage(
                                          image: AssetImage(
                                            LocalImage.shapeDtSmall,
                                          ),
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                      child: Obx(
                                            () => controller.questions[index].isChecked
                                            ? Padding(
                                          padding: const EdgeInsets.all(15),
                                          child: Center(
                                            widthFactor: 0.8,
                                            child: RegularText(
                                              controller.questions[index].option,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: Fontsize.small,
                                                fontWeight: FontWeight.w600,
                                                color: AppColor.blue,
                                              ),
                                            ),
                                          ),
                                        )
                                            : const SizedBox(),
                                      ),
                                    ),
                                  );
                                },
                                onWillAccept: (data) {
                                  return true;
                                },
                                onAccept: (data) {
                                  controller.onCorrect(data.optionId, index);
                                },
                              ),
                              // Add SizedBox to the right of DragTarget
                              SizedBox(width: size.width * 0.08),
                            ],
                          ),
                        ],
                      ),

                      if(findOptionWithPosition(controller.answers, index ~/ 2) == "")
                        const SizedBox(width: double.infinity), // Adds a breakline after each DragTarget
                    ],
                  ),
                ),
              ),
              Obx(
                    () => Wrap(
                  spacing: 8.0, // gap between adjacent chips
                  runSpacing: 4.0, // gap between lines
                  alignment: WrapAlignment.center,
                  children: List.generate(
                    controller.answers.length,
                        (index) => controller.answers[index].isChecked
                        ? const SizedBox()
                        : DraggableItem(
                        option: controller.answers[index],
                        isLong: controller.isLong,
                        autoScroll: autoScroll
                    ),
                  ),
                ),
              ),
              SizedBox(height: 0.12 * size.height),
            ],
          ),
        ),
        onSubmit: () {
          controller.onSubmit();
        },
        quiz: controller.question.question,
        sub: "Em hãy kéo đáp án đúng vào chỗ trống!",
        level: controller.question.level,
        isCompleted: controller.isCompleted,
        question: controller.question,
        scrollController: scrollController,
      ),
    )
        : Obx(
          () => ShapeQuiz(
        content: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.all(0.03 * size.height),
              child:
              Wrap(
                spacing: 8.0, // gap between adjacent chips
                runSpacing: 4.0, // gap between lines
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: List.generate(
                  controller.questions.length,
                      (index) => controller.questions[index].optionId != -1 &&
                      controller.questions[index].optionType ==
                          "question"
                      ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      RegularText(
                        controller.question.options.isNotEmpty
                            ? controller.questions[index].option
                            : '',
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      SizedBox(width: 0.02 * size.width),
                      //check if this option has image
                      controller.questions[index].image != '' ?
                      GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return Dialog(
                                  child:CacheImage(
                                    url: controller.questions[index].image,
                                    width: 0.6 * size.width,
                                    height: 0.6 * size.width,
                                    boxFit: BoxFit.contain,
                                  )
                              );
                            },
                          );
                        },
                        child: CacheImage(
                          url: controller.questions[index].image,
                          width: 0.15*size.width,
                          height: 0.15*size.height,
                          boxFit: BoxFit.contain,
                        ),
                      ): const SizedBox(),
                      SizedBox(width: 0.02 * size.width),
                      DragTarget<Option>(
                        builder: (context, accept, reject) {
                          return Container(
                            width: size.width * 0.4,
                            height: size.height * 0.3,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                              BorderRadius.circular(0.035 * size.height),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 3,
                                  blurRadius: 7,
                                  offset: const Offset(
                                      0, 3), // changes position of shadow
                                ),
                              ],
                            ),
                            clipBehavior: Clip.hardEdge,
                            child: Obx(
                                    () => SingleChildScrollView(
                                  scrollDirection: Axis.vertical,
                                  child: Wrap(
                                    spacing: 8.0, // gap between adjacent chips
                                    runSpacing: 4.0, // gap between lines
                                    alignment: WrapAlignment.center,
                                    children: List.generate(
                                      controller.answers
                                          .where(
                                            (p0) => controller.questions[index].checkedAnswer.contains(p0.optionId),
                                      )
                                          .length,
                                          (idx) => SizedBox(
                                        width: 0.18 * size.width,
                                        height: 0.08 * size.height,
                                        child: ImageText(
                                          onTap: () => controller
                                              .cancelRelation(controller.answers
                                              .where(
                                                (p0) => controller.questions[index].checkedAnswer.contains(p0.optionId),
                                          )
                                              .toList()[idx]
                                              .optionId,index),
                                          text: controller.answers
                                              .where(
                                                (p0) => controller.questions[index].checkedAnswer.contains(p0.optionId),
                                          )
                                              .toList()[idx]
                                              .option,
                                          pathImage: LocalImage.shapeDtLarge,
                                          maxLines: 2,
                                          style: TextStyle(
                                            fontSize: Fontsize.small,
                                            fontWeight: FontWeight.w600,
                                            color: AppColor.blue,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                )

                            ),
                          );
                        },
                        onWillAccept: (data) {
                          // controller.checkCorrectAnswer(data!);
                          return true;
                        },
                        onAccept: (data) {
                          controller.onCorrect(data.optionId, index);
                        },
                      ),
                    ],
                  )
                      : SizedBox(width: 0.02 * size.width),
                ),
              ),
            ),
            Obx(
                  () => Wrap(
                spacing: 8.0, // gap between adjacent chips
                runSpacing: 4.0, // gap between lines
                alignment: WrapAlignment.center,
                children: List.generate(
                  controller.answers
                      .where(
                        (p0) => !p0.isChecked,
                  )
                      .length,
                      (index) =>
                  // controller.answers
                  //         .where(
                  //           (p0) => !p0.isChecked,
                  //         )
                  //         .toList()[index]
                  //         .isChecked
                  //     ? const SizedBox()
                  //     :
                  DraggableItem(
                    option: controller.answers
                        .where(
                          (p0) => !p0.isChecked,
                    )
                        .toList()[index],
                    isLong: controller.isLong,
                    autoScroll: autoScroll,
                  ),
                ),
              ),
            ),
            SizedBox(height: 0.12 * size.height),
          ],
        ),
        onSubmit: () {
          controller.onSubmit();
        },
        quiz: controller.question.question,
        sub: "Em hãy kéo đáp án đúng vào chỗ trống!",
        level: controller.question.level,
        bg: controller.question.background,
        isCompleted: controller.isCompleted,
        scrollController: scrollController,
        question: controller.question,
      ),
    );
  }
}

class DraggableItem extends StatelessWidget {
  final Option option;
  final bool isLong;
  final Function autoScroll;

  const DraggableItem({super.key, required this.option, this.isLong = false,required this.autoScroll});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    if (option.option != "") {
      return Draggable<Option>(
        data: option,
        childWhenDragging: SizedBox(
          width: LibFunction.scaleForCurrentValue(size, !isLong ? 100 : 300),
          height: LibFunction.scaleForCurrentValue(size, 80),
        ),
        feedback: SizedBox(
          width: LibFunction.scaleForCurrentValue(size, !isLong ? 100 : 300),
          height: LibFunction.scaleForCurrentValue(size, 80),
          child: item(size),
        ),
        onDragUpdate: (details)=>autoScroll(details),
        onDraggableCanceled: (Velocity velocity, Offset offset) {
          LibFunction.effectWrongAnswer();
        },
        child: item(size),
      );
    } else {
      return Container();
    }
  }

  Container item(Size size) {
    return Container(
      width: LibFunction.scaleForCurrentValue(size, !isLong ? 120 : 340),
      // height: LibFunction.scaleForCurrentValue(size, size.height<=480?250:150),
      constraints: BoxConstraints(
        minHeight: LibFunction.scaleForCurrentValue(size, size.height<=480?150:80),
      ),
      child: ImageText(
        text: option.option,
        onTap: () {},
        pathImage: LocalImage.shapeScene,
        width: LibFunction.scaleForCurrentValue(size, !isLong ? 100 : 300),
        // height: LibFunction.scaleForCurrentValue(size, 100),
        maxLines: 2,
        style:
        const TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
        padding: EdgeInsets.only(
          top: LibFunction.scaleForCurrentValue(size, 20),
          bottom: LibFunction.scaleForCurrentValue(size,20),
          left: LibFunction.scaleForCurrentValue(size,15),
          right: LibFunction.scaleForCurrentValue(size,15),
        ),
      ),
    );
  }
}
