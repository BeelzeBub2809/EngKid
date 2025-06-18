import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:EngKid/domain/quiz/entities/entites.dart';
import 'package:EngKid/utils/font_size.dart';
import 'package:EngKid/utils/images.dart';
import 'package:EngKid/utils/lib_function.dart';
import 'package:EngKid/widgets/dialog/dialog_alert.dart';
import 'package:EngKid/widgets/image/cache_image.dart';
import 'package:EngKid/widgets/shape/shape_quiz.dart';
import 'package:EngKid/widgets/text/regular_text.dart';

import 'matched_controller.dart';

class MatchedScreen extends StatelessWidget {
  final controller = Get.find<MatchedController>();
  final scrollController = ScrollController();

  MatchedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    void autoScroll(DragUpdateDetails details) {
      final position = details.localPosition.dy;
      if (position < 200) {
        scrollController.animateTo(scrollController.offset - 50,
            duration: const Duration(milliseconds: 10), curve: Curves.linear);
      } else if (position > size.height - 200) {
        scrollController.animateTo(scrollController.offset + 50,
            duration: const Duration(milliseconds: 10), curve: Curves.linear);
      }
    }

    double scaleValue(int value) {
      return LibFunction.scaleForCurrentValue(
        size,
        value.toDouble(),
        desire: 0,
      );
    }

    return Obx(
          () => ShapeQuiz(
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            ...List.generate(
              controller.maxLength,
                  (index) {
                return Row(
                  mainAxisAlignment: controller.optionsB[index].value.isChecked?
                  MainAxisAlignment.center:
                  MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (!controller.optionsB[index].value.isChecked)
                      Container(
                        margin: EdgeInsets.only(
                          left: scaleValue(100),
                        ),
                        child: DraggableItem(
                          dataA: controller.optionsA[index].value,
                          // isLong: controller.isLongA,
                          isLong: controller.isLong,
                          isMatchingImage: controller.isMatchingImage,
                          scaleValue: scaleValue,
                          autoScroll: autoScroll,
                        ),
                      ),

                    Container(
                      margin: EdgeInsets.only(
                        right: scaleValue(100),
                      ),
                      child: DroppableArea(
                        dataA: controller.optionsA[index].value,
                        dataB: controller.optionsB[index].value,
                        onCorrect: (
                            Option dataA,
                            Option dataB,
                            ) {
                          controller.onCorrect(dataA: dataA, dataB: dataB);
                        },
                        cancelRelation: () => controller.cancelRelation(index),
                        // isLong: controller.isLongB,
                        isLong: controller.isLong,
                        scaleValue: scaleValue,
                      ),
                    )
                  ],
                );
              },
            )
          ],
        ),
        onSubmit: () {
          controller.onSubmit();
        },
        quiz: controller.question.question,
        bg: controller.question.background,
        sub:
        'Em hãy nối mỗi ý ở cột màu xanh với mỗi ý ở cột màu hồng sao cho phù hợp!',
        level: controller.question.level,
        isCompleted: controller.isCompleted,
        question: controller.question,
        scrollController: scrollController,
      ),
    );
  }
}

class DraggableItem extends StatelessWidget {
  final Option dataA;
  final bool isLong;
  final bool isMatchingImage;
  final double Function(int value) scaleValue;
  final Function autoScroll;

  const DraggableItem({
    super.key,
    required this.dataA,
    required this.isLong,
    required this.isMatchingImage,
    required this.scaleValue,
    required this.autoScroll,
  });

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    late double width = scaleValue(180);
    if (dataA.image == "") {
      width = scaleValue(isLong ? 640 : 500);
    }

    if (dataA.optionId == -1) {
      return SizedBox(
        width: width,
      );
    }

    return Draggable<Option>(
      data: dataA,
      childWhenDragging: Container(
        height: dataA.image != "" ? scaleValue(120) : scaleValue(75),
        width: width,
        margin: EdgeInsets.only(
          left: scaleValue(dataA.image != "" ? 100 : 0),
        ),
      ),
      feedback: item(context,size),
      child: item(context,size),
      onDraggableCanceled: (Velocity velocity, Offset offset) {
        LibFunction.effectWrongAnswer();
      },
      onDragUpdate: (details) {
        autoScroll(details);
      },
    );
  }

  Widget item(BuildContext context, Size size) {
    if (dataA.optionId == -1) {
      if (isMatchingImage) {
        return SizedBox(
          width: scaleValue(280),
        );
      }
      return SizedBox(
        width: scaleValue(isLong ? 380 : 280),
      );
    }

    return SizedBox(
        height: scaleValue(120),
        width: dataA.image != "" ? 0.8*0.4*size.width : null,
        child: Container(
          margin: EdgeInsets.only(
            right: dataA.option==""?0.8*0.4*size.width*0.1:0.0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              dataA.image != ""?
              GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return Dialog(
                        child: CacheImage(
                          url: dataA.image,
                          width: 0.6 * size.width,
                          height: 0.6 * size.width,
                        ),
                      );
                    },
                  );
                },
                child: CacheImage(
                  url: dataA.image,
                  width: scaleValue(85),
                  height: scaleValue(85),
                ),
              ):SizedBox(
                width: scaleValue(85),
                height: scaleValue(85),
              ),
              dataA.option!=""?
              GestureDetector(
                child: Container(
                  margin: EdgeInsets.only(
                    right: 0.8*0.5*size.width*0.25 - scaleValue(40),
                  ),
                  child: Center(
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(
                            isLong ? LocalImage.matched2A : LocalImage.matchedA,
                          ),
                          fit: BoxFit.contain,
                        ),
                      ),
                      constraints: BoxConstraints(
                        minHeight: scaleValue(75),
                      ),
                      height: scaleValue(dataA.option.length>20&&size.height<=480?250:120),
                      width: scaleValue(isLong ?450 : 345),
                      child: Padding(
                        padding: EdgeInsets.only(
                            right: scaleValue(20),
                            top: scaleValue(10),
                            bottom: scaleValue(10)

                        ),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: SizedBox(
                            width: scaleValue(350),
                            child: RegularText(
                              dataA.option,
                              maxLines: size.height<=480?(dataA.option.length/10).ceil():(isLong?3:2),
                              textAlign: TextAlign.end,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: Fontsize.small,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                onTap: ()=>showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    content: Text(
                      dataA.option,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: Fontsize.small,
                      ),
                    ),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () => Navigator.pop(context, 'Trở lại'),
                        child: const Text('Trở lại'),
                      ),
                    ],
                  ),
                ),
              ):Container(
                height: scaleValue(85),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(
                          LocalImage.circleBlue,
                        ),
                        fit: BoxFit.contain,
                      ),
                    ),
                    constraints: BoxConstraints(
                      minHeight: scaleValue(75),
                    ),
                    height: scaleValue(75),
                    width: scaleValue(75),
                  ),
                ),
              )
            ],
          ),
        )
    );}
}

class DroppableArea extends StatelessWidget {
  const DroppableArea(
      {super.key,
        required this.dataA,
        required this.dataB,
        required this.onCorrect,
        required this.cancelRelation,
        required this.isLong,
        required this.scaleValue});
  final Option dataA;
  final Option dataB;
  final Function onCorrect;
  final Function cancelRelation;
  final bool isLong;
  final double Function(int value) scaleValue;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    if (dataB.optionId == -1) {
      return SizedBox(
        width: scaleValue(isLong ? 500 : 360),
      );
    }

    return DragTarget<Option>(
      builder: (context, candidateData, rejectedData) {
        return dataB.isChecked
            ? dataA.option!=""?
        Container(
          child: Align(
            alignment: Alignment.center,
            child: GestureDetector(
              onTap: () => cancelRelation(),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  dataA.image != ""?
                  CacheImage(
                    url: dataA.image,
                    width: scaleValue(85),
                    height: scaleValue(85),
                  ):SizedBox(
                    width: scaleValue(85),
                    height: scaleValue(85),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: GestureDetector(
                      onTap: () => cancelRelation(),
                      child: Container(
                        width: scaleValue(isLong ? 700 : 500),
                        height: scaleValue(75),
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(
                              isLong
                                  ? LocalImage.matchLong
                                  : LocalImage.matchShort,
                            ),
                            fit: BoxFit.fill,
                          ),
                        ),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 0.02 * size.height,
                            ),
                            child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: scaleValue(isLong ? 260 : 130),
                                  child: RegularText(
                                    dataA.option,
                                    maxLines: 2,
                                    textAlign: TextAlign.end,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: Fontsize.small,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: scaleValue(90),
                                ),
                                SizedBox(
                                  width: scaleValue(isLong ? 280 : 160),
                                  child: RegularText(
                                    dataB.option,
                                    maxLines: 2,
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: Fontsize.small,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
            : Container(
          margin: EdgeInsets.only(
            left: 0.8*0.4*size.width*0.6,
          ),
          child: Align(
            alignment: Alignment.center,
            child: GestureDetector(
              onTap: () => cancelRelation(),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  dataA.image != ""?
                  CacheImage(
                    url: dataA.image,
                    width: scaleValue(85),
                    height: scaleValue(85),
                  ):SizedBox(
                    width: scaleValue(85),
                    height: scaleValue(85),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: GestureDetector(
                      onTap: () => cancelRelation(),
                      child: Container(
                        width: scaleValue(isLong ? 450 : 250),
                        height: scaleValue(75),
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(
                              isLong
                                  ? LocalImage.matchImageLong
                                  : LocalImage.matchImageShort,
                            ),
                            fit: BoxFit.fill,
                          ),
                        ),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 0.02 * size.height,
                            ),
                            child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: scaleValue(isLong ? 280 : 160),
                                  child: RegularText(
                                    dataB.option,
                                    maxLines: 2,
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: Fontsize.small,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
        //end check column A option
            : GestureDetector(
          child: Container(
            constraints: BoxConstraints(
              minHeight: scaleValue(120),
            ),
            // width: scaleValue(isLong ? 640 : 500),
            // height: scaleValue(dataB.option.length>20&&size.height<=480?300:150),
            padding: EdgeInsets.only(
              top: scaleValue(20),
              left: scaleValue(20),
              right: scaleValue(20),
              bottom: scaleValue(20),
            ),
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                    isLong ? LocalImage.matchedBBackground : LocalImage.matchedB,
                  ),
                  fit: BoxFit.fill,
                ),
              ),
              constraints: BoxConstraints(
                minHeight: scaleValue(75),
              ),
              // height: scaleValue(dataB.option.length>20&&size.height<=480?250:120),
              width: scaleValue(isLong ?450 : 345),
              child: Padding(
                padding: EdgeInsets.only(
                    left: scaleValue(60),
                    top: scaleValue(10),
                    bottom: scaleValue(10)

                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: SizedBox(
                    width: scaleValue(350),
                    child: RegularText(
                      dataB.option,
                      maxLines: size.height<=480?(dataB.option.length/10).ceil():(isLong?3:2),
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: Fontsize.small,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          onTap: ()=>showDialog<String>(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              content: Text(
                dataB.option,
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: Fontsize.small,
                ),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context, 'Trở lại'),
                  child: const Text('Trở lại'),
                ),
              ],
            ),
          ),
        );
      },
      onAccept: (data) {
        onCorrect(data, dataB);
      },
      onWillAccept: (data) => true,
    );
  }
}
