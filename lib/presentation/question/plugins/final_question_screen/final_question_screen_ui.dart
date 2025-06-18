import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:EngKid/presentation/question/plugins/achieve_star/achieve_controller.dart';
import 'package:EngKid/utils/images.dart';
import 'package:EngKid/widgets/button/image_button.dart';

import 'final_question_screen_controller.dart';

class FinalQuestionScreen extends StatelessWidget {
  final controller = Get.find<FinalQuestionScreenController>();
  FinalQuestionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Stack(
      children: [
        Container(
          width: size.width,
          height: size.height,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(LocalImage.safetyGuideBg),
              fit: BoxFit.fill,
            ),
          ),
        ),
        Positioned.fill(
          child: Align(
            alignment: Alignment.topCenter,
            child: Image.asset(
              LocalImage.effectAfterMascot,
              width: size.height,
              height: 0.8 * size.height,
              fit: BoxFit.fill,
            ),
          ),
        ),
        Positioned.fill(
          top: 0.1 * size.height,
          child: Align(
            alignment: Alignment.topCenter,
            child: Image.asset(
              LocalImage.effectAfterMascotDot,
              width: 0.7 * size.height,
              height: 0.35 * size.height,
              fit: BoxFit.fill,
            ),
          ),
        ),
        Positioned.fill(
          top: -0.3 * size.height,
          child: Align(
            alignment: Alignment.center,
            child: Image.asset(
              LocalImage.mascotWelcome,
              width: 0.3 * size.height,
              height: 0.35 * size.height,
              fit: BoxFit.fill,
            ),
          ),
        ),
        Positioned.fill(
            bottom: 0.075 * size.height,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                height: 0.15 * size.width + 0.075 * size.width,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // if(!controller.isFinalQuestion)
                      //   Row(
                      //     mainAxisAlignment: MainAxisAlignment.center,
                      //     children: List.generate(
                      //       5,
                      //           (index) => Image.asset(
                      //         !controller.isInteger(controller.totalStar)
                      //             ? "assets/images/halfstar${index + 1}.png"
                      //             : index < controller.totalStar
                      //             ? "assets/images/star${index + 1}.png"
                      //             : "assets/images/blackstar${index + 1}.png",
                      //         height: 0.15 * size.width,
                      //         fit: BoxFit.cover,
                      //       ),
                      //     ),
                      //   ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ImageButton(
                            onTap: () {
                              controller.backQuestion();
                            },
                            semantics: 'back',
                            pathImage: LocalImage.questionBackButton,
                            height: 0.075 * size.width,
                            width: 0.075 * size.width,
                          ),
                          SizedBox(width: 0.03 * size.width),
                          ImageButton(
                            onTap: () {
                              controller.relearn();
                            },
                            semantics: 'reset_question',
                            pathImage: LocalImage.questionResetButton,
                            height: 0.075 * size.width,
                            width: 0.075 * size.width,
                          ),
                          SizedBox(width: 0.03 * size.width),
                          ImageButton(
                            onTap: () {
                              controller.nextQuestion();
                            },
                            semantics: 'next',
                            pathImage: LocalImage.questionNextButton,
                            height: 0.075 * size.width,
                            width: 0.075 * size.width,
                          ),
                        ],
                      ),
                    ]),
              ),
            ))
      ],
    );
  }
}
