import 'package:EngKid/utils/app_route.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:EngKid/presentation/core/topic_service.dart';
import 'package:EngKid/presentation/core/user_service.dart';
import 'package:EngKid/utils/app_color.dart';
import 'package:EngKid/utils/font_size.dart';
import 'package:EngKid/utils/images.dart';
import 'package:EngKid/utils/lib_function.dart';
import 'package:EngKid/widgets/button/image_button.dart';
import 'package:EngKid/widgets/image/cache_image.dart';
import 'package:EngKid/widgets/loading/loading_dialog.dart';
import 'package:EngKid/widgets/text/regular_text.dart';

import 'reading_space_controller.dart';

class ReadingScreen extends GetView<ReadingSpaceController> {
  const ReadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final TopicService topicService = Get.find<TopicService>();
    return Obx(() {
      return Stack(
        children: [
          Stack(
            children: [
              Scaffold(
                body: Stack(
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(LocalImage.backgroundBlue),
                          fit: BoxFit.fill,
                        ),
                      ),
                      width: size.width,
                      height: size.height,
                      child: Stack(
                        children: [
                          SingleChildScrollView(
                            child: Column(
                              children: [
                                const Header(),
                                Progress(controller: controller),
                                Padding(
                                  padding: EdgeInsets.only(
                                      left: 0.02 * size.width,
                                      right: 0.02 * size.width,
                                      top: 0.01 * size.height),
                                  child: Row(
                                    children: [
                                      ShapeTopic(
                                        controller: controller,
                                      ),
                                      const Expanded(
                                        flex: 1,
                                        child: SizedBox(),
                                      ),
                                      ShapeLesson(
                                        onPressLesson: controller.onPressLesson,
                                        controller: controller,
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          // Positioned.fill(
                          //   top: 0.08 * size.width,
                          //   left: 0.015 * size.width,
                          //   child: Align(
                          //     alignment: Alignment.topLeft,
                          //     child: RegularText(
                          //       'home'.tr,
                          //       style: TextStyle(
                          //           fontSize: Fontsize.normal, color: AppColor.red),
                          //     ),
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // DownloadLesson(
              //   controller: controller,
              //   size: size,
              // ),
              Obx(
                () => topicService.isGetTopicReadings
                    ? Container(
                        color: Colors.black38, child: const LoadingDialog())
                    : const Text(''),
              ),
            ],
          ),
          if (controller.isLoading)
            Container(
              color: Colors.black.withOpacity(0.3), // mờ nền
              child: const Center(
                child: LoadingDialog(),
              ),
            ),
        ],
      );
    });
  }
}

class ShapeLesson extends StatelessWidget {
  const ShapeLesson({
    super.key,
    required this.onPressLesson,
    required this.controller,
  });

  final Function onPressLesson;
  final ReadingSpaceController controller;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final TopicService topicService = Get.find<TopicService>();
    print('check');
    print(topicService.topicReadings.topicReadings);
    final selectedPath = controller.selectedLearningPath.value;
    final learningPathItems = controller.learningPathItems;
    final readings = controller.readings;
    return Container(
      width: size.width * 0.62,
      height: size.height * 0.62,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.88),
        borderRadius: BorderRadius.circular(0.03 * size.width),
      ),
      padding: EdgeInsets.only(
        right: 0.02 * size.height,
        left: 0.02 * size.height,
        top: 0.015 * size.height,
        bottom: 0.015 * size.height,
      ),
      child: Obx(
        () => RawScrollbar(
          controller: controller.scrollControllerLesson,
          thumbColor: AppColor.red,
          trackColor: AppColor.gray,
          thumbVisibility: true,
          padding: EdgeInsets.only(
            top: 0.03 * size.height,
            bottom: 0.01 * size.height,
            // right: 0.01 * size.width,
          ),
          thickness: 0.008 * size.width,
          interactive: true,
          radius: Radius.circular(0.008 * 2 * size.width),
          child: GridView.builder(
            controller: controller.scrollControllerLesson,
            itemCount: selectedPath != null
                ? learningPathItems.length
                : readings.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 0.9,
            ),
            itemBuilder: (context, index) {
              // Learning Path Items Display - Following Reading Design Pattern
              final item = learningPathItems[index];
              final isReading = item['reading'] != null;

              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Stack(
                    children: [
                      Stack(
                        children: [
                          GestureDetector(
                            onTap: () =>
                                controller.onPressLearningPathItem(item, index),
                            child: ClipRRect(
                              borderRadius:
                                  BorderRadius.circular(0.025 * size.height),
                              child:
                                  isReading && item['reading']['image'] != null
                                      ? CacheImage(
                                          url: item['reading']['image'],
                                          width: size.width * 0.16,
                                          height: size.width * 0.16,
                                          boxFit: BoxFit.cover,
                                        )
                                      : Container(
                                          width: size.width * 0.16,
                                          height: size.width * 0.16,
                                          color: isReading
                                              ? AppColor.blue.withOpacity(0.3)
                                              : AppColor.green.withOpacity(0.3),
                                          child: Center(
                                            child: isReading
                                                ? Icon(
                                                    Icons.book,
                                                    size: size.width * 0.06,
                                                    color: AppColor.blue,
                                                  )
                                                : Icon(
                                                    Icons.videogame_asset,
                                                    size: size.width * 0.06,
                                                    color: AppColor.green,
                                                  ),
                                          ),
                                        ),
                            ),
                          ),
                          Positioned(
                            bottom: size.height * 0.08,
                            left: 0,
                            right: 0,
                            child: Center(
                              child: Semantics(
                                label:
                                    'Tiêu đề bài học : ${(isReading ? item['reading']['title'] : item['game']['name']).toUpperCase()}',
                                child: Text(
                                  (isReading
                                          ? item['reading']['title']
                                          : item['game']['name'])
                                      .toUpperCase(),
                                  style: TextStyle(
                                    color: Colors.transparent,
                                    fontWeight: FontWeight.bold,
                                    fontSize: size.width * 0.015,
                                    letterSpacing: -0.5,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      // Status indicator (following reading pattern)
                      Positioned.fill(
                        right: 0.01 * size.width,
                        child: Align(
                          alignment: Alignment.topRight,
                          child: Image.asset(
                            item['student_progress']['is_completed'] == 1
                                ? LocalImage.lessonCompleted
                                : LocalImage.lessonProgress,
                            width: 0.05 * size.width,
                            height: 0.08 * size.height,
                          ),
                        ),
                      ),
                      // Star rating display (following reading pattern)
                      if (item['student_progress']['star'] != null)
                        Positioned.fill(
                          bottom: 0.005 * size.height,
                          left: 0.01 * size.width,
                          child: Align(
                            alignment: Alignment.bottomLeft,
                            child: Stack(
                              children: [
                                Image.asset(
                                  LocalImage.shapeStar,
                                  width: 0.13 * size.width,
                                  height: 0.06 * size.height,
                                ),
                                Positioned.fill(
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: List.generate(
                                        5, // Assuming 5 stars max
                                        (idx) => Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 0.003 * size.width),
                                          child: Image.asset(
                                            idx <
                                                    item['student_progress']
                                                            ['star']
                                                        .ceil()
                                                ? LocalImage.star
                                                : LocalImage.starGrey,
                                            width: 0.02 * size.width,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: 0.02 * size.height),
                  // Progress section (following reading pattern)
                  Padding(
                    padding: EdgeInsets.only(
                        right: 0.025 * size.width, left: 0.018 * size.width),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Stack(
                          children: [
                            Container(
                              width: 0.11 * size.width,
                              height: 0.03 * size.height,
                              decoration: const BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage(LocalImage.progress),
                                  fit: BoxFit.fill,
                                ),
                              ),
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      right: 0.005 * size.width),
                                  child: Text(
                                    "${(item['student_progress']['is_completed'] == 1 ? 100 : (item['student_progress']['progress'] ?? 0)).ceil()}%",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w800,
                                      color: const Color.fromARGB(
                                          255, 255, 147, 7),
                                      fontSize: Fontsize.smallest - 4,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Positioned.fill(
                              left: 0.002 * size.width,
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Container(
                                  width: 0.075 * size.width,
                                  height: 0.02 * size.height,
                                  decoration: const BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage(
                                        LocalImage.insideProgress,
                                      ),
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Positioned.fill(
                              left: 0.003 * size.width,
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: SizedBox(
                                  width: 0.075 *
                                      size.width *
                                      (item['student_progress']
                                                  ['is_completed'] ==
                                              1
                                          ? 1.0
                                          : (item['student_progress']
                                                      ['progress'] ??
                                                  0) /
                                              100),
                                  height: 0.017 * size.height,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(
                                        size.width * 0.02),
                                    child: Image.asset(
                                      LocalImage.progressDoing,
                                      repeat: ImageRepeat.repeatX,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          width: 0.04 * size.width,
                          height: 0.03 * size.height,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(LocalImage.progressQuiz),
                              fit: BoxFit.fill,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              isReading ? 'Read' : 'Game',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                  fontSize: Fontsize.smallest - 4),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class ShapeTopic extends StatelessWidget {
  const ShapeTopic({
    super.key,
    required this.controller,
  });

  final ReadingSpaceController controller;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final ReadingSpaceController readingSpaceController =
        Get.find<ReadingSpaceController>();

    return Container(
      width: size.width * 0.32,
      height: size.height * 0.62,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.88),
        borderRadius: BorderRadius.circular(0.05 * size.width),
      ),
      padding: EdgeInsets.all(0.015 * size.height),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(
              vertical: 0.015 * size.height,
              horizontal: 0.02 * size.width,
            ),
            margin: EdgeInsets.only(bottom: 0.02 * size.height),
            child: Obx(() {
              final selectedPath = controller.selectedLearningPath.value;
              return RegularText(
                selectedPath != null ? "Categories" : "Topics",
                style: TextStyle(
                  color: selectedPath != null ? AppColor.blue : AppColor.red,
                  fontSize: Fontsize.larger,
                  fontWeight: FontWeight.w800,
                ),
              );
            }),
          ),
          Obx(() {
            final selectedPath = controller.selectedLearningPath.value;
            final bool isLearningPathMode = selectedPath != null;

            if (isLearningPathMode) {
              // Learning Path Categories Display - Following Old Design Pattern
              final categories = controller.learningPathCategories;
              final selectedCategoryIndex =
                  controller.selectedCategoryIndex.value;

              return Center(
                child: SizedBox(
                  width: size.width * 0.29,
                  height: size.height * 0.5,
                  child: RawScrollbar(
                    controller: controller.scrollControllerTopic,
                    thumbColor: AppColor.blue,
                    trackColor: AppColor.gray,
                    thumbVisibility: true,
                    padding: EdgeInsets.only(
                      top: 0.03 * size.height,
                      bottom: 0.01 * size.height,
                      right: -0.01 * size.width,
                    ),
                    thickness: 0.008 * size.width,
                    interactive: true,
                    radius: Radius.circular(0.008 * 2 * size.width),
                    child: SingleChildScrollView(
                      controller: controller.scrollControllerTopic,
                      child: Column(
                        children: List.generate(
                          categories.length,
                          (index) {
                            final category = categories[index];
                            final isSelected = index == selectedCategoryIndex;

                            return GestureDetector(
                              onTap: () {
                                controller.onChangeLearningPathCategory(index);
                              },
                              child: Padding(
                                padding:
                                    EdgeInsets.only(bottom: 0.01 * size.height),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        image: isSelected
                                            ? const DecorationImage(
                                                image: AssetImage(LocalImage
                                                    .topicImageChoosed),
                                                fit: BoxFit.fill,
                                              )
                                            : const DecorationImage(
                                                image: AssetImage(
                                                    LocalImage.topicImage),
                                                fit: BoxFit.fill,
                                              ),
                                        border: isSelected
                                            ? Border.all(
                                                color: AppColor.blue,
                                                width: 1.5)
                                            : null,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(0.06 * size.width)),
                                      ),
                                      width: 0.06 * size.width,
                                      height: 0.06 * size.width,
                                      child: Center(
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                              0.05 * size.width),
                                          child: category['icon'] != null
                                              ? CacheImage(
                                                  url: category['icon'],
                                                  width: 0.05 * size.width,
                                                  height: 0.05 * size.width,
                                                )
                                              : Icon(
                                                  Icons.category,
                                                  size: 0.05 * size.width,
                                                  color: AppColor.blue,
                                                ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 0.01 * size.width),
                                    Container(
                                      decoration: BoxDecoration(
                                          image: isSelected
                                              ? const DecorationImage(
                                                  image: AssetImage(LocalImage
                                                      .topicNameChoosed),
                                                  fit: BoxFit.fill,
                                                )
                                              : const DecorationImage(
                                                  image: AssetImage(
                                                      LocalImage.topicName),
                                                  fit: BoxFit.fill,
                                                )),
                                      width: 0.22 * size.width,
                                      height: 0.1 * size.height,
                                      padding: EdgeInsets.only(
                                          left: 0.01 * size.width),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child: RegularText(
                                              category['title'],
                                              maxLines: 1,
                                              textAlign: TextAlign.left,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w700),
                                            ),
                                          ),
                                          if (isSelected)
                                            Image.asset(
                                              LocalImage.menuSelected,
                                              width: size.height * 0.1,
                                              height: size.width * 0.025,
                                            )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              );
            } else {
              // Regular Topics Display (original code)
              return Center(
                child: SizedBox(
                  width: size.width * 0.29,
                  height: size.height * 0.5,
                  child: RawScrollbar(
                    controller: controller.scrollControllerTopic,
                    thumbColor: AppColor.red.withOpacity(0.8),
                    trackColor: Colors.grey.shade100,
                    trackBorderColor: Colors.grey.shade200,
                    thumbVisibility: true,
                    trackVisibility: true,
                    padding: EdgeInsets.only(
                      top: 0.03 * size.height,
                      bottom: 0.01 * size.height,
                      right: 0.005 * size.width,
                    ),
                    thickness: 0.012 * size.width,
                    interactive: true,
                    radius: Radius.circular(0.006 * size.width),
                    child: SingleChildScrollView(
                      controller: controller.scrollControllerTopic,
                      child: Column(
                        children: List.generate(
                            readingSpaceController.topics.length, (index) {
                          return GestureDetector(
                            onTap: () {
                              readingSpaceController
                                  .onChangeTopicReadings(index);
                            },
                            child: Padding(
                              padding:
                                  EdgeInsets.only(bottom: 0.01 * size.height),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      image: index ==
                                              readingSpaceController.topicIndex
                                          ? const DecorationImage(
                                              image: AssetImage(
                                                  LocalImage.topicImageChoosed),
                                              fit: BoxFit.fill,
                                            )
                                          : const DecorationImage(
                                              image: AssetImage(
                                                  LocalImage.topicImage),
                                              fit: BoxFit.fill,
                                            ),
                                      border: index ==
                                              readingSpaceController.topicIndex
                                          ? Border.all(
                                              color: const Color.fromARGB(
                                                  255, 63, 195, 131),
                                              width: 1.5)
                                          : null,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(0.06 *
                                              size.width) //                 <--- border radius here
                                          ),
                                    ),
                                    width: 0.06 * size.width,
                                    height: 0.06 * size.width,
                                    child: Center(
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(
                                            0.05 * size.width),
                                        child: CacheImage(
                                          url: readingSpaceController
                                              .topics[index].icon,
                                          width: 0.05 * size.width,
                                          height: 0.05 * size.width,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 0.01 * size.width,
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                        image: index ==
                                                readingSpaceController
                                                    .topicIndex
                                            ? const DecorationImage(
                                                image: AssetImage(LocalImage
                                                    .topicNameChoosed),
                                                fit: BoxFit.fill,
                                              )
                                            : const DecorationImage(
                                                image: AssetImage(
                                                    LocalImage.topicName),
                                                fit: BoxFit.fill,
                                              )),
                                    width: 0.22 * size.width,
                                    height: 0.1 * size.height,
                                    padding: EdgeInsets.only(
                                        left: 0.01 * size.width),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: RegularText(
                                            readingSpaceController
                                                .topics[index].name,
                                            maxLines: 1,
                                            textAlign: TextAlign.left,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w700),
                                          ),
                                        ),
                                        if (index ==
                                            readingSpaceController.topicIndex)
                                          Image.asset(
                                            LocalImage.menuSelected,
                                            width: size.height * 0.1,
                                            height: size.width * 0.025,
                                          )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                  ),
                ),
              );
            }
          }),
        ],
      ),
    );
  }
}

class Progress extends StatelessWidget {
  const Progress({
    super.key,
    required this.controller,
  });

  final ReadingSpaceController controller;

  @override
  Widget build(BuildContext context) {
    final TopicService topicService = Get.find<TopicService>();
    final Size size = MediaQuery.of(context).size;

    return Obx(
      () => Padding(
        padding: EdgeInsets.symmetric(horizontal: size.width * 0.06),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(
                right: LibFunction.scaleForCurrentValue(size, 100, desire: 0),
                left: LibFunction.scaleForCurrentValue(size, 50, desire: 0),
              ),
              width: LibFunction.scaleForCurrentValue(size, 400, desire: 0),
              height: LibFunction.scaleForCurrentValue(size, 140, desire: 0),
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(LocalImage.progressLessons),
                  fit: BoxFit.fill,
                ),
              ),
              child: Padding(
                padding: EdgeInsets.only(
                  left: LibFunction.scaleForCurrentValue(
                    size,
                    160,
                    desire: 0,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RegularText(
                      "${topicService.completedReading}/${topicService.totalReading}",
                      style: TextStyle(
                        color: AppColor.yellow,
                        fontSize: Fontsize.smaller - 1,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    RegularText(
                      "lesson",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: Fontsize.smallest,
                        fontWeight: FontWeight.w600,
                      ),
                    )
                  ],
                ),
              ),
            ),
            Container(
              width: LibFunction.scaleForCurrentValue(size, 400, desire: 0),
              height: LibFunction.scaleForCurrentValue(size, 140, desire: 0),
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(LocalImage.progressStars),
                  fit: BoxFit.fill,
                ),
              ),
              child: Padding(
                padding: EdgeInsets.only(
                  left: LibFunction.scaleForCurrentValue(
                    size,
                    130,
                    desire: 0,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RegularText(
                      "${topicService.completedStar.ceil()}/${topicService.totalStar}",
                      style: TextStyle(
                        color: AppColor.yellow,
                        fontSize: Fontsize.smaller - 1,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    RegularText(
                      "star",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: Fontsize.smallest,
                        fontWeight: FontWeight.w600,
                      ),
                    )
                  ],
                ),
              ),
            ),
            // DownloadAll(controller: controller),
          ],
        ),
      ),
    );
  }
}

class Header extends StatelessWidget {
  const Header({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final UserService userService = Get.find<UserService>();
    return Stack(
      children: [
        Obx(
          () => Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Column(
                //   children: [
                //     ImageButton(
                //       onTap: () {
                //         // userService.onPressStarBoard(isValidate: false);
                //       },
                //       pathImage: LocalImage.numOfStar,
                //       width: 0.06 * size.width,
                //       height: 0.06 * size.width,
                //     ),
                //     RegularText(
                //       'star_board_title'.tr,
                //       style: TextStyle(
                //           fontSize: Fontsize.smaller, color: AppColor.yellow),
                //     )
                //   ],
                // ),
                // SizedBox(
                //   width: 0.02 * size.height,
                // ),
                GestureDetector(
                  onTap: () {
                    // userService.onPressProfile();
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white30,
                      borderRadius: BorderRadius.circular(0.035 * size.height),
                    ),
                    padding: EdgeInsets.all(0.002 * size.height),
                    width: 0.2 * size.width,
                    height: 0.06 * size.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(LocalImage.shapeAvatar),
                              fit: BoxFit.fill,
                            ),
                          ),
                          width: 0.055 * size.width,
                          height: 0.055 * size.width,
                          child: Center(
                            child: ClipRRect(
                              borderRadius:
                                  BorderRadius.circular(0.04 * size.width),
                              child: CacheImage(
                                url: userService.currentUser.avatar,
                                width: 0.04 * size.width,
                                height: 0.04 * size.width,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 0.12 * size.width,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Stack(
                                children: [
                                  RegularText(
                                    userService.currentUser.name,
                                    maxLines: 1,
                                    style: TextStyle(
                                      color: Colors.redAccent,
                                      fontWeight: FontWeight.w900,
                                      fontSize: Fontsize.small + 1,
                                    ),
                                  ),
                                ],
                              ),
                              RegularText(
                                'Lớp: ${userService.currentUser.gradeId}',
                                style: TextStyle(
                                  color: AppColor.gray,
                                  fontWeight: FontWeight.w800,
                                  fontSize: Fontsize.small + 1,
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        Positioned.fill(
          child: Align(
            alignment: Alignment.center,
            child: RegularText(
              "my_progess",
              isUpperCase: true,
              maxLines: 1,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: Fontsize.large,
              ),
            ),
          ),
        ),
        Positioned.fill(
          left: 0.01 * size.width,
          child: Align(
            alignment: Alignment.centerLeft,
            child: ImageButton(
              onTap: () async {
                await LibFunction.effectExit();
                Get.back();
              },
              pathImage: LocalImage.backButton,
              height: 0.075 * size.width,
              width: 0.075 * size.width,
            ),
          ),
        ),
      ],
    );
  }
}
