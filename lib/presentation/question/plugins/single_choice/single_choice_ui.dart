import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:EngKid/presentation/question/plugins/single_choice/single_choice_controller.dart';
import 'package:EngKid/utils/app_color.dart';
import 'package:EngKid/utils/font_size.dart';
import 'package:EngKid/utils/images.dart';
import 'package:EngKid/widgets/image/cache_image.dart';
import 'package:EngKid/widgets/shape/shape_quiz.dart';
import 'package:EngKid/widgets/text/regular_text.dart';

class SingleChoiceScreen extends StatelessWidget {
  final controller = Get.find<SingleChoiceController>();

  SingleChoiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => ShapeQuiz(
          content: controller.isSingleChoiceImage
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: List.generate(
                    controller.options.length,
                    (index) {
                      return RadioButon(
                        handleCheckedRadioButton:
                            controller.handleCheckedRadioButton,
                        isSingleChoiceImage: controller.isSingleChoiceImage,
                        index: index,
                        isChecked: controller.options[index].value.isChecked,
                        option: controller.options[index].value.option,
                        pathChecked: controller.pathChecked,
                        pathUnChecked: controller.pathUnChecked,
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
                      return RadioButon(
                        handleCheckedRadioButton:
                            controller.handleCheckedRadioButton,
                        isSingleChoiceImage: controller.isSingleChoiceImage,
                        isChecked: controller.options[index].value.isChecked,
                        option: controller.options[index].value.option,
                        pathChecked: controller.pathChecked,
                        pathUnChecked: controller.pathUnChecked,
                        index: index,
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
          bg: controller.question.background,
          question: controller.question,
          sub: "Em hãy chọn một đáp án đúng nhất nhé!"),

    );
  }
}

class RadioButon extends StatelessWidget {
  const RadioButon({
    super.key,
    required this.handleCheckedRadioButton,
    required this.isChecked,
    required this.option,
    required this.isSingleChoiceImage,
    required this.index,
    required this.pathChecked,
    required this.pathUnChecked,
    this.length = 1,
    this.image = "",
  });

  final Function handleCheckedRadioButton;
  final bool isChecked;
  final String option;
  final String image;
  final bool isSingleChoiceImage;
  final int index;
  final int length;
  final List<String> pathChecked;
  final List<String> pathUnChecked;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () {
        handleCheckedRadioButton(index);
      },
      child: Padding(
        padding: EdgeInsets.all(
          0.02 * size.height,
        ),
        child: isSingleChoiceImage
            ? SizedBox(
                width: 0.65 * size.width / length,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 0.63 * size.width / length,
                      height: 0.63 * size.width / length,
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
                        child: image != ""
                            ? CacheImage(
                                url: image,
                                width: 0.6 * size.width / length,
                                height: 0.6 * size.width / length,
                              )
                            : Image.asset(
                                //it should be sad mascot here
                                LocalImage.mascotWelcome,
                                width: 0.6 * size.width / length,
                                height: 0.6 * size.width / length,
                              ),
                      ),
                    ),
                    SizedBox(
                      height: 0.01 * size.height,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          isChecked
                              ? pathChecked[
                                  index > pathChecked.length - 1 ? 0 : index]
                              : pathUnChecked[
                                  index > pathUnChecked.length - 1 ? 0 : index],
                          width: 0.1 * size.height,
                          height: 0.1 * size.height,
                        ),
                        SizedBox(
                          width: 0.005 * size.width,
                        ),
                        SizedBox(
                          width: 0.4 * size.width / length,
                          child: RegularText(
                            option,
                            maxLines: 4,
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: Fontsize.larger,
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
                        ? pathChecked[
                            index > pathChecked.length - 1 ? 0 : index]
                        : pathUnChecked[
                            index > pathUnChecked.length - 1 ? 0 : index],
                    width: 0.1 * size.height,
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
                        fontSize: Fontsize.larger,
                      ),
                    ),
                  )
                ],
              ),
      ),
    );
  }
}
