import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:EngKid/utils/app_color.dart';
import 'package:EngKid/utils/font_size.dart';
import 'package:EngKid/utils/images.dart';
import 'package:EngKid/widgets/image/cache_image.dart';
import 'package:EngKid/widgets/shape/shape_quiz.dart';
import 'package:EngKid/widgets/text/regular_text.dart';

import 'multiple_choice_controller.dart';

class MultipleChoiceScreen extends StatelessWidget {
  final controller = Get.find<MultipleChoiceController>();

  MultipleChoiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => ShapeQuiz(
        content: controller.isMultiChoiceImage
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: List.generate(
                  controller.options.length,
                  (index) {
                    return CheckboxButton(
                      handleCheckedCheckBox: controller.handleCheckedCheckBox,
                      isMultiChoiceImage: controller.isMultiChoiceImage,
                      index: index,
                      isChecked: controller.options[index].value.isChecked,
                      option: controller.options[index].value.option,
                      isLong: controller.isLong,
                      image: controller.options[index].value.image,
                      length: controller.options.length,
                    );
                  },
                ),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: List.generate(
                  controller.options.length,
                  (index) {
                    return CheckboxButton(
                      handleCheckedCheckBox: controller.handleCheckedCheckBox,
                      isMultiChoiceImage: controller.isMultiChoiceImage,
                      index: index,
                      isChecked: controller.options[index].value.isChecked,
                      isLong: controller.isLong,
                      option: controller.options[index].value.option,
                    );
                  },
                ),
              ),
        onSubmit: () {
          controller.onSubmit();
        },
        quiz: controller.question.question,
        level: controller.question.level,
        isCompleted: controller.isCompleted,
        sub: 'Em có thể chọn nhiều đáp án nhé!',
        question: controller.question,
      ),
    );
  }
}

class CheckboxButton extends StatelessWidget {
  const CheckboxButton(
      {super.key,
      required this.handleCheckedCheckBox,
      required this.isMultiChoiceImage,
      required this.isChecked,
      required this.option,
      required this.index,
      required this.isLong,
      this.image = "",
      this.length = 1});

  final Function handleCheckedCheckBox;
  final bool isChecked;
  final String option;
  final String image;
  final bool isMultiChoiceImage;
  final bool isLong;
  final int index;
  final int length;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        handleCheckedCheckBox(index: index);
      },
      child: Padding(
        padding: EdgeInsets.all(
          0.02 * size.height,
        ),
        child: isMultiChoiceImage
            ? SizedBox(
                width: 0.6 * size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // SizedBox(
                    //   height: 0.01 * size.height,
                    // ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          isChecked
                              ? LocalImage.checkboxChecked
                              : LocalImage.checkboxUnChecked,
                          width: 0.1 * size.width,
                          height: 0.1 * size.height,
                        ),
                        SizedBox(
                          width: 0.005 * size.width,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: AppColor.lightYellow,
                            borderRadius: BorderRadius.circular(0.03 * size.height),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black12,
                                spreadRadius: 1,
                                blurRadius: 5,
                                offset: Offset(3, 3), // changes position of shadow
                              ),
                            ],
                          ),
                          child: Center(
                            child: GestureDetector(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return Dialog(
                                      child: image != ""
                                          ? CacheImage(
                                        url: image,
                                        width: 0.6 * size.width,
                                        height: 0.6 * size.width,
                                        boxFit: BoxFit.contain,
                                      )
                                          : Image.asset(
                                        //it should be sad mascot here
                                        LocalImage.mascotWelcome,
                                        width: 0.6 * size.width,
                                        height: 0.6 * size.width,
                                      ),
                                    );
                                  },
                                );
                              },
                              child: image != ""
                                  ? CacheImage(
                                url: image,
                                width: 0.2 * size.width,
                                height: 0.2 * size.height,
                              )
                                  : Image.asset(
                                //it should be sad mascot here
                                LocalImage.mascotWelcome,
                                width: 0.23 * size.width,
                                height: 0.23 * size.height,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 0.005 * size.width,
                        ),
                        SizedBox(
                          width: 0.2 * size.width,
                          child: RegularText(
                            option,
                            maxLines: 4,
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize:
                                  isLong ? Fontsize.small : Fontsize.larger,
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    isChecked
                        ? LocalImage.checkboxChecked
                        : LocalImage.checkboxUnChecked,
                    width: 0.1 * size.width,
                    height: 0.1 * size.height,
                  ),
                  SizedBox(
                    width: 0.01 * size.width,
                  ),
                  SizedBox(
                    width: 0.4 * size.width,
                    child: RegularText(
                      option,
                      maxLines: 4,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: isLong ? Fontsize.small : Fontsize.larger,
                      ),
                    ),
                  )
                ],
              ),
      ),
    );
  }
}
