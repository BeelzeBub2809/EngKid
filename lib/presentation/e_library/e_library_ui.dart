import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:EngKid/presentation/core/elibrary_service.dart';
import 'package:EngKid/presentation/core/user_service.dart';
import 'package:EngKid/presentation/e_library/e_library_controller.dart';
import 'package:EngKid/utils/app_color.dart';
import 'package:EngKid/utils/font_size.dart';
import 'package:EngKid/utils/images.dart';
import 'package:EngKid/widgets/button/image_button.dart';
import 'package:EngKid/widgets/image/cache_image.dart';
import 'package:EngKid/widgets/text/regular_text.dart';

import '../../utils/lib_function.dart';
import '../../widgets/loading/loading_dialog.dart';

class ElibraryScreen extends GetView<ElibraryController> {
  const ElibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final ElibraryService elibraryService = Get.find<ElibraryService>();
    return Scaffold(
      body: SizedBox(
        width: size.width,
        height: size.height,
        child: Stack(
          children: [
            Obx(
              () => AnimatedSwitcher(
                  duration: const Duration(milliseconds: 500),
                  child: ClipRRect(
                      key: UniqueKey(),
                      borderRadius: BorderRadius.circular(30),
                      child: elibraryService.isGetCategoryReadings == false
                          ? CacheImage(
                              width: size.width,
                              height: size.height,
                              url: elibraryService
                                  .categoryList[elibraryService.categoryIndex]
                                  .imageUrl,
                              boxFit: BoxFit.fitWidth,
                            )
                          : Image.asset(LocalImage.elibraryBackground,
                              width: size.width,
                              height: size.height,
                              fit: BoxFit.fitWidth))),
            ),
            Column(children: [
              Header(controller: controller),
            ]),
            SizedBox(
              width: size.width,
              height: 0.06 * size.width,
              child: Center(
                child: RegularText(
                  "my_e_library",
                  maxLines: 1,
                  isUpperCase: true,
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
                  alignment: Alignment.topLeft,
                  child: ImageButton(
                    pathImage: LocalImage.backButton,
                    semantics: 'back',
                    height: 0.075 * size.width,
                    width: 0.075 * size.width,
                    onTap: () {
                      controller.onBackPress();
                    },
                  )),
            ),

            Positioned(
              left: size.width * 0.02,
              bottom: size.height * 0.03,
              child: Stack(
                children: [
                  Container(
                    width: size.width * 0.30,
                    height: size.height * 0.85,
                    padding: EdgeInsets.fromLTRB(
                        size.width * 0.025,
                        size.height * 0.2,
                        size.width * 0.05,
                        size.height * 0.1),
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(LocalImage.categoryElibrary),
                        fit: BoxFit.fill,
                      ),
                    ),
                    child: Obx(
                      () => SingleChildScrollView(
                        controller: controller.scrollControllerCategory,
                        child: Column(
                          children: [
                            ...List.generate(elibraryService.categoryList.length, (index) {
                              return Column(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      elibraryService.onChangeCategory(
                                        index,
                                        elibraryService.categoryList[index].id
                                      );
                                    },
                                    child: Row(
                                      children: [
                                        Obx(
                                          () => Container(
                                            decoration: BoxDecoration(
                                              image: index == elibraryService.categoryIndex
                                                ? const DecorationImage(
                                                    image: AssetImage(LocalImage.topicImageChoosed),
                                                    fit: BoxFit.fill,
                                                  )
                                                : const DecorationImage(
                                                    image: AssetImage(LocalImage.topicImage),
                                                    fit: BoxFit.fill,
                                                  ),
                                              border: index == elibraryService.categoryIndex
                                                ? Border.all(
                                                    color: const Color.fromARGB(255, 63, 195, 131),
                                                    width: 1.5
                                                )
                                                : null,
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(0.06 * size.width)
                                              ),
                                            ),
                                            width: 0.045 * size.width,
                                            height: 0.045 * size.width,
                                            child: Center(
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(0.05 * size.width),
                                                child: CacheImage(
                                                  url: elibraryService.categoryList[index].iconUrl,
                                                  width: 0.05 * size.width,
                                                  height: 0.05 * size.width,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 0.01 * size.width,
                                        ),
                                        Obx(() => Container(
                                          decoration: BoxDecoration(
                                            image: index == elibraryService.categoryIndex
                                              ? const DecorationImage(
                                                image: AssetImage(LocalImage.topicNameChoosed),
                                                fit: BoxFit.fill,
                                              )
                                              : const DecorationImage(
                                                  image: AssetImage(LocalImage.topicName),
                                                  fit: BoxFit.fill,
                                                )
                                          ),
                                          width: 0.165 * size.width,
                                          height: 0.09 * size.height,
                                          padding: EdgeInsets.only(left: 0.01 * size.width),
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: RegularText(
                                              elibraryService.categoryList[index].title,
                                              maxLines: 1,
                                              textAlign: TextAlign.left,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w700
                                              ),
                                            ),
                                          ),
                                        ))
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: size.height * 0.02,
                                  )
                                ],
                              );
                            })
                          ],
                        ),
                      ),
                    )),
                  Positioned(
                    top: size.height * 0.07,
                    left: size.width * 0.1,
                    child: RegularText(
                      "topic",
                      style: TextStyle(
                        color: AppColor.red,
                        fontSize: Fontsize.bigger - 5,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 0, size.height * 0.02),
                child: Stack(
                  children: <Widget>[
                    Container(
                      width: size.width * 0.4,
                      height: size.height * 0.9,
                      alignment: Alignment.center,
                      child: Container(
                        width: size.width * 0.35,
                        height: size.height * 0.85,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(LocalImage.bookElibrary),
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(size.width * 0.035, size.height * 0.05, 0, 0),
                      child: Obx(
                        () => AnimatedSwitcher(
                          duration: const Duration(milliseconds: 500),
                          child: GestureDetector(
                            onTap: () {
                              controller.handlePressingBook();
                            },
                            child: ClipRRect(
                              key: UniqueKey(),
                              borderRadius: BorderRadius.circular(30),
                              child: elibraryService.selectedCateBooks.isNotEmpty
                                ? CacheImage(
                                    url: elibraryService.selectedCateBooks[elibraryService.bookIndex].image,
                                    width: size.width * 0.35 * 0.9,
                                    height: size.height * 0.85 * 0.95,
                                  )
                                : Image.asset(
                                    LocalImage.sampleThumbnail,
                                    width: size.width * 0.35 * 0.9,
                                    height: size.height * 0.85 * 0.95,
                                    fit: BoxFit.cover,
                                  ),
                            ),
                          )),
                      ),
                    ),
                    // Positioned(
                    //   left: 0,
                    //   bottom: 0,
                    //   child: Container(
                    //     width: size.width * 0.35 * 0.3,
                    //     height: size.height * 0.85 * 0.35,
                    //     decoration: const BoxDecoration(
                    //       image: DecorationImage(
                    //         image:
                    //             AssetImage(LocalImage.mascotHappyReverse),
                    //         fit: BoxFit.fill,
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    Positioned(
                      top: size.height * 0.85 * 0.025,
                      right: size.width * 0.35 * 0.2,
                      child: Stack(
                        children: [
                          Obx(
                            () => Container(
                              width: size.width * 0.35 * 0.1,
                              height: size.height * 0.85 * 0.125,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image:
                                    !elibraryService.selectedCateBooks.isNotEmpty ||elibraryService.selectedCateBooks[elibraryService.bookIndex].isActive
                                      ? const AssetImage(LocalImage.lessonCompleted)
                                      : const AssetImage(LocalImage.lessonProgress),
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                          ),
                          // Positioned.fill(
                          //   child: GestureDetector(
                          //     onTap: () {
                          //     },
                          //     child: Container(
                          //       color: Colors.black.withOpacity(0.5),
                          //       child: const Center(
                          //
                          //       ),
                          //     ),
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                    Obx(() => controller.isPressingBook
                      ? Container(
                          width: size.width * 0.4,
                          height: size.height * 0.9,
                          alignment: Alignment.center,
                          child: Stack(
                            children: [
                              GestureDetector(
                                  onTap: () async {
                                    controller.handlePressingBook();
                                  },
                                  child: AnimatedOpacity(
                                      duration:
                                          const Duration(seconds: 3),
                                      opacity: 1.0,
                                      child: Opacity(
                                        opacity:
                                            0.5, // Set the desired opacity here
                                        child: Container(
                                          width: size.width * 0.35,
                                          height: size.height * 0.85,
                                          decoration: const BoxDecoration(
                                            image: DecorationImage(
                                              image: AssetImage(LocalImage
                                                  .bookElibraryDark),
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                        ),
                                      ))),
                              Positioned(
                                bottom: size.height * 0.32,
                                right: size.width * 0.13,
                                child: Column(
                                  children: [
                                    ImageButton(
                                      onTap: () async {
                                        await controller.onPressBook(elibraryService.bookIndex);
                                      },
                                      semantics: 'play',
                                      pathImage: LocalImage.playButton,
                                      width: size.width * 0.35 * 0.25,
                                      height: size.height * 0.85 * 0.25,
                                    ),
                                    RegularText('play'.tr, style: TextStyle(fontSize: Fontsize.large, color: AppColor.red),)
                                  ],
                                ),
                              )
                            ],
                          ))
                      : const SizedBox())
                  ],
                ))),
            Align(
              alignment: Alignment.bottomRight,
              child: Stack(
                children: <Widget>[
                  SizedBox(
                    width: size.width * 0.35,
                    height: size.height * 0.85,
                  ),
                  Positioned(
                    bottom: size.height * 0.075,
                    right: size.width * 0.01,
                    child: Container(
                      padding: EdgeInsets.fromLTRB(size.width * 0.02, size.height * 0.11, 10, 10),
                      width: size.width * 0.30,
                      height: size.height * 0.7,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(LocalImage.boxElibrary),
                          fit: BoxFit.fill,
                        ),
                      ),
                      child: Obx(
                        () => SingleChildScrollView(
                          controller: controller.scrollControllerBook,
                          child: Column(
                            children: [
                              ...List.generate(elibraryService.selectedCateBooks.length, (index) {
                                return Column(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        elibraryService.onChangeBook(index);
                                      },
                                      child: Row(
                                        children: [
                                          Obx(
                                            () => SizedBox(
                                              width: 0.06 * size.width,
                                              height: 0.0605 * size.width,
                                              child: Center(
                                                child: Stack(
                                                  children: <Widget>[
                                                  Container(
                                                    width: size.width * 0.06,
                                                    height: size.width * 0.06,
                                                    alignment: Alignment.center,
                                                    child: Container(
                                                      width: size.width * 0.06,
                                                      height: size.width * 0.06,
                                                      decoration: const BoxDecoration(
                                                        image: DecorationImage(
                                                          image: AssetImage(LocalImage.bookSmallElibrary),
                                                          fit: BoxFit.fill,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.fromLTRB(size.width * 0.0015, size.height * 0.0015, 0, 0),
                                                    child: ClipRRect(
                                                      borderRadius: BorderRadius.circular(4), // Adjust the radius as needed
                                                      child: elibraryService.selectedCateBooks.isNotEmpty
                                                        ? CacheImage(
                                                            url: elibraryService.selectedCateBooks[index].image,
                                                            width: size.width *0.054,
                                                            height: size.width * 0.058,
                                                          )
                                                        : Image.asset(
                                                            LocalImage.sampleThumbnail,
                                                            width: size.width * 0.045,
                                                            height: size.width * 0.057,
                                                            fit: BoxFit.cover,
                                                          ),
                                                    )
                                                  ),
                                                  Positioned(
                                                    top: 0,
                                                    right: 5,
                                                    child: Container(
                                                      width: size.width * 0.015,
                                                      height: size.height * 0.04,
                                                      decoration: BoxDecoration(
                                                        image: DecorationImage(
                                                          image: elibraryService.selectedCateBooks[index].isActive
                                                            ? const AssetImage(LocalImage.lessonCompleted)
                                                            : const AssetImage(LocalImage.lessonProgress),
                                                          fit: BoxFit.fill,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                                )
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 0.01 * size.width,
                                          ),
                                          Obx(
                                            () => Container(
                                              width: 0.165 * size.width,
                                              height: 0.09 * size.height,
                                              padding: EdgeInsets.only(
                                                left: 0.01 * size.width,
                                              ),
                                              child: Align(
                                                alignment: Alignment.centerLeft,
                                                child: RegularText(
                                                  elibraryService.selectedCateBooks[index].title,
                                                  maxLines: 2,
                                                  textAlign: TextAlign.left,
                                                  style: index == elibraryService.bookIndex
                                                    ? const TextStyle(
                                                        fontWeight: FontWeight.w700,
                                                        color: Colors.deepOrange,
                                                      )
                                                    : const TextStyle(
                                                        fontWeight: FontWeight.w700,
                                                        color: Colors.black,
                                                      ),
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: size.height * 0.02,
                                    )
                                  ],
                                );
                              })
                            ],
                          ),
                        ),
                      )
                    ),
                  ),
                  Positioned(
                    top: size.height * 0.015,
                    right: size.width * 0.025,
                    child: Container(
                        width: size.width * 0.25,
                        height: size.height * 0.15,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(LocalImage.bookBarElibrary),
                            fit: BoxFit.fill,
                          ),
                        ),
                        child: Stack(
                          children: [
                            Positioned(
                                top: size.height * 0.025,
                                left: size.width * 0.1,
                                child: Obx(
                                  () => RegularText(
                                    "${elibraryService.completedBook}/${elibraryService.totalBook}",
                                    style: TextStyle(
                                        color: Colors.orange,
                                        fontSize: Fontsize.large,
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.center,
                                  ),
                                )),
                            Positioned(
                              top: size.height * 0.08,
                              left: size.width * 0.1,
                              child: RegularText(
                                "book_number".tr,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: Fontsize.smaller,
                                    fontWeight: FontWeight.bold),
                              ),
                            )
                          ],
                        )),
                  )
                ],
              )),
            Obx(
              () => elibraryService.isGetCategoryReadings || elibraryService.isChangeBook
                  ? Container(
                      color: Colors.black38, child: const LoadingDialog())
                  : const Text(''),
            ),
            // DownloadLesson(
            //     controller: controller,
            //     size: size,
            //     index: elibraryService.bookIndex),
            //
            // Obx(
            //    () => Positioned(
            //       left: 0.71 * size.width,
            //       top: 0.062 * size.width,
            //       child: RegularText( !controller.isDownload ? 'download'.tr : '',
            //         style: TextStyle(color: AppColor.red, fontSize: Fontsize.small),)),
            // ),
          ],
        ),
      ),
    );
  }
}

class DownloadLesson extends StatelessWidget {
  const DownloadLesson(
      {super.key,
      required this.controller,
      required this.size,
      required this.index});

  final Size size;
  final ElibraryController controller;
  final int index;
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
                  await LibFunction.effectConfirmPop();
                  controller.isDownload = false;
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
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ImageButton(
                                    onTap: (){
                                      controller.onPressDownload(index);
                                    },
                                    semantics: 'download',

                                    pathImage: LocalImage.downloadButton,
                                    width: 0.5 * size.height,
                                    height: 0.5 * size.height,
                                  ),
                                  SizedBox(height: 0.03 * size.height,),
                                  RegularText('download'.tr, style: TextStyle(color: Colors.white, fontSize: Fontsize.bigger, fontWeight: FontWeight.bold),)
                                ],
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

class DownloadAll extends StatelessWidget {
  const DownloadAll({
    super.key,
    required this.controller,
  });
  final ElibraryController controller;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Column(
      children: [
        ImageButton(
          pathImage: LocalImage.downloadButton,
          semantics: 'download',
          onTap: () {
            controller.handleShowDownloadAll(controller);
          },
          width: 0.09 * size.width,
          height: 0.12 * size.height,
        ),

      ],
    );
  }
}

class Header extends StatelessWidget {
  const Header({
    super.key,
    required this.controller,
  });

  final ElibraryController controller;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final UserService userService = Get.find<UserService>();
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SizedBox(
            width: 0.02 * size.width,
          ),
          // DownloadAll(controller: controller),
          GestureDetector(
            onTap: () {
              userService.onPressProfile();
            },
            child: Container(
              decoration: BoxDecoration(
                color: AppColor.blackBgUser,
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
                        borderRadius: BorderRadius.circular(0.04 * size.width),
                        child: CacheImage(
                          url: userService.currentUser.avatar,
                          width: 0.04 * size.width,
                          height: 0.04 * size.width,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 0.01 * size.width),
                  SizedBox(
                    width: 0.12 * size.width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        RegularText(
                          userService.currentUser.name,
                          maxLines: 1,
                          style: TextStyle(
                            color: AppColor.red,
                            fontWeight: FontWeight.w800,
                            fontSize: Fontsize.small + 1,
                          ),
                        ),
                        RegularText(
                          // "grade",
                          // data: const {"grade": '3'},
                          userService.currentUser.gradeId.toString() ?? '',
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
    );
  }
}
