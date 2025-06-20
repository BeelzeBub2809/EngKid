import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:EngKid/utils/app_color.dart';
import 'package:EngKid/utils/images.dart';
import 'package:EngKid/utils/lib_function.dart';
import 'package:EngKid/widgets/button/image_button.dart';
import 'package:EngKid/widgets/text/regular_text.dart';
import 'package:video_player/video_player.dart';

import '../../../../utils/font_size.dart';
import 'video_controller.dart';

String? selectedValue;
void _showDropdownMenu(BuildContext context, VideoController controler) {
  final List<String> dropdownItems = [
    "0.25",
    "0.5",
    "0.75",
    "1.0",
    "1.25",
    "1.5",
    "1.75",
    "2.0"
  ];

  // Get the render box of the button
  final RenderBox button = context.findRenderObject() as RenderBox;

  // Calculate the position of the menu
  final Offset offset = button.localToGlobal(Offset.zero);
// Change this value to adjust the item height

  // Show the menu at the calculated position
  showMenu<String>(
    context: context,
    position: RelativeRect.fromLTRB(
      offset.dx, // Left
      offset.dy + button.size.height, // Top
      offset.dx + button.size.width, // Right
      offset.dy + button.size.height + 10, // Bottom (add some padding)
    ),
    items: dropdownItems.map((String item) {
      return PopupMenuItem<String>(
        value: item,
        height: 30.0,
        child: Text(
          "x$item",
          style: TextStyle(
            fontWeight:
                selectedValue == item ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      );
    }).toList(),
  ).then((value) {
    if (value != null) {
      // Handle the selected dropdown item
      selectedValue = value;

      controler.changeSpeed(double.parse(value));
    }
  });
}

class VideoScreen extends StatelessWidget {
  VideoScreen({super.key});
  final controller = Get.find<VideoController>();
  @override
  Widget build(BuildContext context) {
    selectedValue = "1.0";
    bool isMute = false;
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Obx(
        () => controller.isLoading == true
            ? Container(
                color: Colors.black,
                width: size.width,
                height: size.height,
                child: Center(
                    child: LoadingAnimationWidget.fourRotatingDots(
                  color: Colors.white,
                  size: 100,
                )),
              )
            : Stack(
                children: [
                  GestureDetector(
                    onTap: () => controller.toggleControl(),
                    child: Stack(
                      children: [
                        Container(
                          color: Colors.black,
                          width: size.width,
                          height: size.height,
                          child: Center(
                            child: AspectRatio(
                                aspectRatio:
                                    double.parse((18 / 9).toStringAsFixed(1)),
                                child: VideoPlayer(controller.videoController)),
                          ),
                        ),
                        Opacity(
                          opacity: controller.isControlVisible == true ? 1 : 0,
                          child: AbsorbPointer(
                            absorbing: !controller.isControlVisible,
                            child: ColoredBox(
                              color: Colors.black54,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 0.12 * size.height),
                                  Expanded(
                                    child: Center(
                                      child: controller.isVideoCompleted ==
                                              false
                                          ? Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                ImageButton(
                                                  onTap: () {
                                                    controller.onPlayPress();
                                                  },
                                                  semantics: controller
                                                          .isVideoPlaying
                                                      ? 'pause_video'
                                                      : 'next_video',
                                                  pathImage: controller
                                                          .isVideoPlaying
                                                      ? LocalImage.pauseButton
                                                      : LocalImage.playButton,
                                                  width: 0.5 * size.height,
                                                  height: 0.5 * size.height,
                                                ),
                                                SizedBox(
                                                  height: size.width * 0.02,
                                                ),
                                                RegularText(
                                                  controller.isVideoPlaying
                                                      ? 'pause_video'.tr
                                                      : 'next_video'.tr,
                                                  style: TextStyle(
                                                      fontSize: Fontsize.bigger,
                                                      color: Colors.white),
                                                )
                                              ],
                                            )
                                          : Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              ImageButton(
                                                  onTap: () {
                                                    controller.refreshVideo();
                                                  },
                                                  semantics: 'review_video',
                                                  pathImage:
                                                      LocalImage.refreshButton,
                                                  width: 0.5 * size.height,
                                                  height: 0.5 * size.height,
                                                ),
                                              SizedBox(height: size.width * 0.02,),
                                              RegularText('review_video'.tr, style: TextStyle(fontSize: Fontsize.bigger, color: Colors.white),)
                                            ],
                                          ),
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(
                                      bottom: 10,
                                      left: 10,
                                    ),
                                    width: size.width,
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          width: size.width * 0.075,
                                        ),
                                        RegularText(
                                          '${LibFunction.durationFormat(controller.videoPosition)}/${LibFunction.durationFormat(controller.videoController.value.duration)}',
                                          style: const TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                        Expanded(
                                          child: Slider(
                                            activeColor: AppColor.blue,
                                            value: controller
                                                .videoPosition.inSeconds
                                                .toDouble(),
                                            max: controller.videoController
                                                .value.duration.inSeconds
                                                .toDouble(),
                                            onChanged: (double value) =>
                                                controller.onSeekVideo(value),
                                            // onChanged: _onSeekVideo,
                                          ),
                                        ),
                                        Builder(
                                          builder: (BuildContext context) {
                                            return IconButton(
                                              iconSize: 30,
                                              icon: Image.asset(
                                                  LocalImage.setting),
                                              onPressed: () {
                                                _showDropdownMenu(
                                                    context, controller);
                                              },
                                            );
                                          },
                                        ),
                                        IconButton(
                                          iconSize: 30,
                                          icon: Image.asset(isMute == false
                                              ? LocalImage.volumnVideoUnmute
                                              : LocalImage.volumnVideoMute),
                                          onPressed: () {
                                            isMute = !isMute;
                                            if (isMute == true) {
                                              controller.changeVolume(0.0);
                                            } else {
                                              controller.changeVolume(1.0);
                                            }
                                          },
                                        ),
                                        SizedBox(
                                          width: size.width * 0.095,
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (controller.isControlVisible == true)
                    Positioned.fill(
                      top: 0.02 * size.height,
                      left: 0.01 * size.width,
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Column(
                          children: [
                            ImageButton(
                              onTap: () {
                                controller.closeVideo();
                              },
                              semantics: 'home',
                              pathImage: LocalImage.buttonHome,
                              height: 0.075 * size.width,
                              width: 0.075 * size.width,
                            ),
                            RegularText('home'.tr, style: TextStyle(fontSize: Fontsize.normal, color: Colors.white),)
                          ],
                        ),
                      ),
                    ),
                  if (controller.isVideoCompleted == true)
                    Positioned.fill(
                      top: 0.02 * size.height,
                      right: 0.01 * size.width,
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            RegularText('next'.tr, style: TextStyle(fontSize: Fontsize.normal, color: Colors.white),),

                            ImageButton(
                              onTap: () {
                                controller.completeLesson();
                              },
                              semantics: 'next',
                              pathImage: LocalImage.nextButton,
                              height: 0.075 * size.width,
                              width: 0.075 * size.width,
                            ),

                          ],
                        ),
                      ),
                    ),
                  DownloadLesson(
                    controller: controller,
                    size: size,
                  ),
                ],
              ),
      ),
    );
  }
}

class DownloadLesson extends StatelessWidget {
  const DownloadLesson({
    super.key,
    required this.controller,
    required this.size,
  });

  final Size size;
  final VideoController controller;

  @override
  Widget build(BuildContext context) {
    double getWidthProgress(double width, int step) {
      final double widthP = width / 100;
      return widthP * step;
    }

    return Obx(
      () => controller.isDownload
          ? Positioned.fill(
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () async {
                  if (!controller.getLanguageVideoFromStorage() &&
                      controller.languague == "mo") {
                    controller.closeVideo();
                  } else {
                    await LibFunction.effectConfirmPop();
                    controller.isDownload = false;
                  }
                  // print('ngu');
                },
                child: Stack(
                  children: [
                    Obx(
                      () => !controller.loadingVideo
                          ? Container(
                              color: Colors.black,
                              child: Image.memory(
                                controller.thumbVideo!,
                                width: size.width,
                                height: size.height,
                              ),
                            )
                          : const SizedBox(),
                    ),
                    Container(
                      width: size.width,
                      height: size.height,
                      color: Colors.black38,
                      child: controller.isDownloading
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                LoadingAnimationWidget.inkDrop(
                                  color: Colors.white,
                                  size: 100,
                                ),
                                SizedBox(
                                  height: 0.08 * size.height,
                                ),
                                Stack(
                                  children: [
                                    Container(
                                      width: 0.5 * size.width,
                                      height: 0.07 * size.height,
                                      margin: EdgeInsets.only(
                                          bottom: 0.035 * size.height),
                                      decoration: BoxDecoration(
                                        color: AppColor.yellow,
                                        borderRadius: BorderRadius.circular(
                                            0.035 * size.height),
                                      ),
                                      child: Stack(
                                        children: [
                                          AnimatedContainer(
                                            width: getWidthProgress(
                                              size.width * 0.5,
                                              controller.loadingProgress,
                                            ),
                                            height: 0.07 * size.height,
                                            duration: const Duration(
                                                milliseconds: 500),
                                            decoration: BoxDecoration(
                                              color: AppColor.blue,
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      0.035 * size.height),
                                            ),
                                          ),
                                          Align(
                                              child: RegularText(
                                            "${controller.loadingProgress}%",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: Fontsize.small),
                                          )),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            )
                          : Center(
                              child: ImageButton(
                                onTap: () {
                                  controller.onPressDownload();
                                },
                                semantics: 'download',
                                pathImage: LocalImage.downloadButton,
                                width: 0.5 * size.height,
                                height: 0.5 * size.height,
                              ),
                            ),
                    ),
                  ],
                ),
              ),
            )
          : const Text(''),
    );
  }
}
