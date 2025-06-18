import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:sizer/sizer.dart';
import 'package:EngKid/utils/app_color.dart';
import 'package:EngKid/utils/font_size.dart';
import 'package:EngKid/utils/images.dart';
import 'package:EngKid/utils/lib_function.dart';
import 'package:EngKid/widgets/button/image_button.dart';
import 'package:EngKid/widgets/input/landscape_textfield.dart';
import 'package:EngKid/widgets/shape/shape_quiz.dart';

import 'fill_blank_controller.dart';

class FillBlankScreen extends StatelessWidget {
  final controller = Get.find<FillBlankController>();

  FillBlankScreen({super.key});

  double spToPx(BuildContext context, double sp) {
    // MediaQuery to get the device's pixel ratio and text scaling factor
    // double pixelRatio = MediaQuery.of(context).devicePixelRatio;
    double scaleFactor = MediaQuery.of(context).textScaleFactor;
    print('test');
    print(scaleFactor);

    // sp to px conversion
    return sp * scaleFactor;
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Stack(
      children: [
        Obx(
          () => ShapeQuiz(
            content: Stack(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 0.04 * size.height),
                  child: Stack(
                    children: [
                      for (int i = 0; i < 5; i++)
                        Container(
                          width: double.infinity,
                          margin: EdgeInsets.only(
                            top: (i + 1) * 0.085 * size.height,
                            left: 0.05 * size.width,
                            right: 0.05 * size.width,
                          ),
                          height: 1,
                          color: AppColor.gray,
                        ),
                      Positioned.fill(
                        // top: 0.085 * size.height / spToPx(context,Fontsize.small) / 2,
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: Container(
                            margin: EdgeInsets.only(
                              left: 0.05 * size.width,
                              right: 0.05 * size.width,
                              top: size.height <=480?
                              0.085 * size.height * 1/2 - Fontsize.small + 2.1:
                                  size.height <= 768?0.085 * size.height * 1/2 - Fontsize.small/2:
                              0.085 * size.height * 1/2 - Fontsize.small/2, //margin top half of line height
                            ),
                            // height: 0.1 * size.height * 5,
                            child: Obx(
                              () => LandScapeTextField(
                                input: controller.text,
                                keyboardType: TextInputType.multiline,
                                backgroundColor: Colors.transparent,
                                textAlign: Alignment.topLeft,
                                textStyle: TextStyle(
                                  fontSize: Fontsize.small,
                                  fontWeight: FontWeight.w600,
                                  color: AppColor.gray,
                                  height: size.height <360?0.085 * size.height / (Fontsize.small + 1279/size.height):
                                  0.085 * size.height / Fontsize.small,
                                ),
                                onChange: (text) {
                                  controller.onChangeInput(input: text);
                                },
                                isDisable: controller.mplaybackReady,
                                setIsFullScreen: (bool value) {
                                  controller.setIsFullScreen(value);
                                  controller.isFullScreen = value;
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
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
                'Em hãy điền câu vào ô trống hoặc nhấn giữ biểu tượng micro để thu âm câu trả lời!',
            level: controller.question.level,
            isCompleted: controller.isCompleted,
            question: controller.question,
          ),
        ),
        Positioned.fill(
          bottom: 0.08 * size.height,
          right: 0.07 * size.width,
          child: Align(
            alignment: Alignment.bottomRight,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Obx(
                  () => !controller.isFullScreen
                      ? Padding(
                          padding: EdgeInsets.only(right: 0.025 * size.width),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Obx(
                                () => controller.hasPermissionMicrophone &&
                                        (!controller.isFilledText ||
                                            controller.text == "") &&
                                        controller.mplaybackReady &&
                                        !controller.isRecording
                                    ? ImageButton(
                                        pathImage: LocalImage.readingTrash,
                                        onTap: () {
                                          controller.deleteRecord();
                                        },
                                  semantics: 'delete',



                                  width: 0.05 * size.width,
                                        height: 0.05 * size.width,
                                      )
                                    : const SizedBox(),
                              ),
                              SizedBox(
                                width: 0.005 * size.width,
                              ),
                              Obx(
                                () => controller.hasPermissionMicrophone &&
                                        (!controller.isFilledText ||
                                            controller.text == "") &&
                                        controller.mplaybackReady &&
                                        !controller.isRecording
                                    ? Container(
                                        width: 0.05 * size.width,
                                        height: 0.05 * size.width,
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            begin: Alignment.topLeft,
                                            end: const Alignment(0.8, 1),
                                            colors: !controller.isPlaying
                                                ? [
                                                    Colors.transparent,
                                                    Colors.transparent
                                                  ]
                                                : <Color>[
                                                    const Color(0XFFe36e75),
                                                    const Color(0XFFb42f20),
                                                  ], // Gradient from https://learnui.design/tools/gradient-generator.html
                                            tileMode: TileMode.mirror,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                              0.05 * size.height),
                                          boxShadow: !controller.isPlaying
                                              ? null
                                              : [
                                                  BoxShadow(
                                                    color: Colors.black
                                                        .withOpacity(0.3),
                                                    spreadRadius: 1,
                                                    blurRadius: 5,
                                                    offset: const Offset(2,
                                                        2), // changes position of shadow
                                                  ),
                                                ],
                                        ),
                                        child: Center(
                                          child: !controller.isPlaying
                                              ? ImageButton(
                                                  pathImage: LocalImage
                                                      .readingHeadphone,
                                                  onTap: () {
                                                    controller.play();
                                                  },
                                                  semantics: 'play',
                                                  width: 0.05 * size.width,
                                                  height: 0.05 * size.width,
                                                )
                                              : SizedBox(
                                                width: 0.025 * size.width,
                                                height: 0.025 * size.width,
                                                child: ImageButton(
                                                  onTap: (){
                                                    controller.stopPlayer();
                                                  },
                                                  semantics: 'pause_video',
                                                  pathImage : LocalImage.readPauseNew,
                                                  width: 0.13 * size.height,
                                                  height: 0.13 * size.height,
                                                ),
                                              ),
                                        ),
                                      )
                                    : const SizedBox(),
                              ),
                              Column(
                                children: [
                                  SizedBox(
                                    width: 0.005 * size.width,
                                  ),
                                  Obx(
                                        () => controller.hasPermissionMicrophone &&
                                        (!controller.isFilledText ||
                                            controller.text == "")
                                        ? Container(
                                      width: 0.05 * size.width,
                                      height: 0.05 * size.width,
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: const Alignment(0.8, 1),
                                          colors: !controller.isRecording
                                              ? [
                                            Colors.transparent,
                                            Colors.transparent
                                          ]
                                              : <Color>[
                                            const Color(0XFFe36e75),
                                            const Color(0XFFb42f20),
                                          ], // Gradient from https://learnui.design/tools/gradient-generator.html
                                          tileMode: TileMode.mirror,
                                        ),
                                        borderRadius: BorderRadius.circular(
                                            0.05 * size.height),
                                        boxShadow: !controller.isRecording
                                            ? null
                                            : [
                                          BoxShadow(
                                            color: Colors.black
                                                .withOpacity(0.3),
                                            spreadRadius: 1,
                                            blurRadius: 5,
                                            offset: const Offset(2,
                                                2), // changes position of shadow
                                          ),
                                        ],
                                      ),
                                      child: Center(
                                        child: !controller.isRecording
                                            ? ImageButton(
                                          pathImage:
                                          LocalImage.readingMic,
                                          onTap: () {
                                            controller.record();
                                          },
                                          semantics: 'record',
                                          width: 0.05 * size.width,
                                          height: 0.05 * size.width,
                                        )
                                            : Container(
                                              color: Colors.transparent,
                                              width: double.infinity,
                                              height: double.infinity,
                                              child: Center(
                                                child: SizedBox(
                                                  width:
                                                  0.025 * size.width,
                                                  height:
                                                  0.025 * size.width,
                                                  child:
                                                  ImageButton(
                                                    onTap: (){
                                                      controller.stopRecorder();

                                                    },
                                                    pathImage: LocalImage.readPauseNew,
                                                    semantics: 'pause_video',
                                                    width: 0.13 * size.height,
                                                    height: 0.13 * size.height,
                                                  ),
                                                ),
                                              ),
                                            ),
                                      ),
                                    )
                                        : const SizedBox(),
                                  ),
                                  SizedBox(
                                    height: 0.01 * size.height,
                                  ),
                                  Obx(
                                        () => controller.hasPermissionMicrophone &&
                                        (!controller.isFilledText || controller.text == "")
                                        ? Padding(
                                      padding: EdgeInsets.only(
                                        right: 0.01 * size.width,
                                      ),
                                      child: Text(
                                        "Nhấn để thu âm",
                                        maxLines: 2,
                                        style: TextStyle(
                                          color: AppColor.gray,
                                          fontWeight: FontWeight.w600,
                                          fontStyle: FontStyle.italic,
                                          fontSize: Fontsize.small,
                                        ),
                                      ),)
                                        : const Text(""),
                                  )
                                ],
                              ),
                            ],
                          ),
                        )
                      : const SizedBox(),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
