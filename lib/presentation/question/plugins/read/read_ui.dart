import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:EngKid/utils/app_color.dart';
import 'package:EngKid/utils/font_size.dart';
import 'package:EngKid/utils/images.dart';
import 'package:EngKid/widgets/button/image_button.dart';
import 'package:EngKid/widgets/text/image_text.dart';
import 'package:EngKid/widgets/text/regular_text.dart';

import 'read_controller.dart';

class ReadScreen extends StatelessWidget {
  final controller = Get.find<ReadController>();

  ReadScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Obx(
        () => !controller.isStarted
            ? Stack(
                children: [
                  Container(
                    width: size.width,
                    height: size.height,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(LocalImage.readingBg),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: EdgeInsets.only(top: 0.32 * size.height),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(height: 0.03 * size.height),
                            ImageText(
                              text: 'start',
                              pathImage: LocalImage.shapeButton,
                              isUpperCase: true,
                              onTap: () {
                                controller.onPressStart();
                              },
                              width: 0.16 * size.width,
                              height: 0.14 * size.height,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              )
            : Stack(
                children: [
                  Container(
                    width: size.width,
                    height: size.height,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(LocalImage.readBg),
                        fit: BoxFit.fill,
                      ),
                    ),
                    child: Center(
                      child: Container(
                        width: size.width * 0.75,
                        height: size.height * 0.75,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(LocalImage.readBoard),
                            fit: BoxFit.fill,
                          ),
                        ),
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.only(
                                left: 0.1 * size.width,
                                right: 0.05 * size.width),
                            child: SizedBox(
                              width: double.infinity,
                              height: size.height * 0.6,
                              child: RawScrollbar(
                                thumbColor: const Color(0XFFfdf1ce),
                                trackColor: AppColor.gray,
                                thumbVisibility: true,
                                padding: EdgeInsets.only(
                                  top: 0.03 * size.height,
                                  bottom: 0.01 * size.height,
                                  right: -0.04 * size.width,
                                ),
                                thickness: 0.008 * size.width,
                                interactive: true,
                                radius: Radius.circular(0.008 * 2 * size.width),
                                child: ScrollConfiguration(
                                  behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
                                  child: SingleChildScrollView(
                                    child: RegularText(
                                      controller.question.question,
                                      maxLines: 100,
                                      textAlign: TextAlign.left,

                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: Fontsize.normal,
                                        height: 1.3,
                                      ),
                                    ),
                                  ),
                                )
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Obx(
                    () => controller.mplaybackReady && !controller.isRecording
                        ? Positioned.fill(
                            top: 0.12 * size.height,
                            right: 0.01 * size.width,
                            child: Align(
                              alignment: Alignment.topRight,
                              child: Column(
                                children: [
                                  ImageButton(
                                    onTap: () {
                                      if (controller.mPlayer.isPlaying) {
                                        controller.stopPlayer();
                                      } else {
                                        controller.play();
                                      }
                                    },
                                    semantics: controller.isPlaying ? 'play' : 'pause_video',
                                    pathImage: controller.isPlaying
                                        ? LocalImage.readPlayRed
                                        : LocalImage.readPauseRed,
                                    width: 0.1 * size.width,
                                    height: 0.1 * size.width,
                                  ),
                                ],
                              ),
                            ),
                          )
                        : const SizedBox(),
                  ),
                  Positioned.fill(
                    bottom: 0.03 * size.height,
                    left: -0.02 * size.width,
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: Image.asset(
                        LocalImage.mascotWelcome,
                        width: 0.3 * size.width,
                        height: 0.3 * size.height,
                      ),
                    ),
                  ),
                  Obx(() => controller.hasPermissionMicrophone
                      ? Positioned.fill(
                          bottom: 0.4 * size.height,
                          left: 0.04 * size.width,
                          child: Align(
                            alignment: Alignment.bottomLeft,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    if (controller.mRecorder.isRecording) {
                                      controller.stopRecorder();
                                    } else {
                                      controller.record();
                                    }
                                  },
                                  child: Container(
                                    width: 0.23 * size.height,
                                    height: 0.2 * size.height,
                                    decoration: const BoxDecoration(
                                      image: DecorationImage(
                                        image: AssetImage(LocalImage.shapeReadMicRed),
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                    padding: EdgeInsets.only(
                                      top: 0.02 * size.height,
                                      left: 0.02 * size.width,
                                      right: 0.02 * size.width,
                                      bottom: 0.06 * size.height,
                                    ),
                                    child: Center(
                                      child: !controller.isRecording
                                          ? Image.asset(
                                              LocalImage.readRecord,
                                              width: 0.13 * size.height,
                                              height: 0.13 * size.height,
                                            )
                                          : Image.asset(
                                              LocalImage.readPauseNew,
                                              width: 0.13 * size.height,
                                              height: 0.13 * size.height,
                                            ),
                                    ),
                                  ),
                                ),
                                RegularText(!controller.isRecording ? 'reply'.tr : 'pause_video'.tr, style: TextStyle(fontSize: Fontsize.normal, color: Colors.red),)
                              ],
                            ),
                          ),
                        )
                      : const SizedBox()),
                  Obx(
                    () => controller.isCompleted && !controller.isRecording
                        ? Positioned.fill(
                            bottom: 0.05 * size.height,
                            // right: 0.05 * size.height,
                            child: Align(
                              alignment: Alignment.bottomCenter,
                              child: ImageText(
                                text: 'reply',
                                onTap: () async {
                                  controller.onSubmit();
                                },
                                pathImage: LocalImage.shapeQuizTitle,
                                width: 0.12 * size.width,
                                height: 0.1 * size.height,
                                style: TextStyle(
                                    fontSize: Fontsize.larger - 1,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w800),
                              ),
                            ),
                          )
                        : const SizedBox(),
                  )
                ],
              ),
      ),
    );
  }
}
