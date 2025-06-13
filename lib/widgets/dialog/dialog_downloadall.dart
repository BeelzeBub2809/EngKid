import 'package:EngKid/presentation/reading_space/reading_space_binding.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:EngKid/presentation/reading_space/reading_space_controller.dart';
import 'package:EngKid/utils/font_size.dart';

import '../../presentation/core/elibrary_service.dart';
import '../../presentation/core/topic_service.dart';
import '../../presentation/e_library/e_library_controller.dart';
import '../../utils/images.dart';
import '../../utils/lib_function.dart';
import '../button/image_button.dart';
import '../image/cache_image.dart';
import '../text/image_text.dart';
import '../text/regular_text.dart';

class DialogDownloadAll extends StatefulWidget {
  const DialogDownloadAll({
    super.key,
    required this.controller,
  });
  final ReadingSpaceController controller;
  @override
  State<DialogDownloadAll> createState() => _DialogDownloadAll();
}

class _DialogDownloadAll extends State<DialogDownloadAll> {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    double screenWidth = MediaQuery.of(context).size.width;
    final TopicService topicService = Get.find<TopicService>();
    if (screenWidth < 900) {
    } else if (screenWidth < 1200 && screenWidth > 900) {}
    return AlertDialog(
        contentPadding: EdgeInsets.zero,
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.zero,
        elevation: 0,
        content: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            //print("Đăng test");
            // Get.back();
          },
              child: Row(
                children: [
                  const SizedBox(
                    width: 10,
                  ),

                  SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Center(
                              child: Container(
                                constraints: BoxConstraints.expand(
                                  width: size.width * 0.85,
                                  height: size.height * 0.9,
                                ),
                                decoration: const BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage(LocalImage.shapeGuide),
                                  ),
                                ),
                                child: Center(
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Transform.translate(
                                            offset:  Offset(- size.width * 0.23,  - size.width * 0.02, ),
                                            child: ImageButton(
                                                  onTap: () async {
                                                    await LibFunction.effectExit();
                                                    Get.back();
                                                  },
                                                  pathImage: LocalImage.backButton,
                                                  height: 0.07 * size.width,
                                                  width: 0.07 * size.width,
                                                ),
                                          ),

                                          Transform.translate(
                                            offset:  Offset(-20, - size.width * 0.025, ),
                                            child: ImageText(
                                              text: "library",
                                              style: TextStyle(
                                                fontSize: Fontsize.smaller,
                                              ),
                                              pathImage: LocalImage.shapeQuizTitle,
                                              isUpperCase: true,
                                              width: 0.18 * size.width,
                                              height: 0.12 * size.height,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        width: size.width * 0.5,
                                        child: GestureDetector(
                                          child: Padding(
                                              padding: EdgeInsets.only(
                                                  bottom: 0.01 * size.height),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Align(
                                                      alignment: Alignment.centerLeft,
                                                      child: Row(
                                                        children: [
                                                          Obx(() => GestureDetector(
                                                                onTap: () {
                                                                  widget.controller
                                                                      .handleChangeDownloadedScreen(
                                                                          true);
                                                                },
                                                                child: RoundedButton(
                                                                  text:
                                                                      'downloaded'.tr,
                                                                  textColor: widget
                                                                          .controller
                                                                          .isDownloadedScreen
                                                                      ? Colors.white
                                                                      : Colors.black,
                                                                  color: widget
                                                                          .controller
                                                                          .isDownloadedScreen
                                                                      ? Colors
                                                                          .redAccent
                                                                      : Colors.white,
                                                                  width: 0.1 *
                                                                      size.width,
                                                                  height: 0.09 *
                                                                      size.height,
                                                                ),
                                                              )),
                                                          Obx(() => GestureDetector(
                                                                onTap: () {
                                                                  widget.controller
                                                                      .handleChangeDownloadedScreen(
                                                                          false);
                                                                },
                                                                child: RoundedButton(
                                                                  text: 'download'.tr,
                                                                  textColor: !widget
                                                                          .controller
                                                                          .isDownloadedScreen
                                                                      ? Colors.white
                                                                      : Colors.black,
                                                                  color: !widget
                                                                          .controller
                                                                          .isDownloadedScreen
                                                                      ? Colors
                                                                          .redAccent
                                                                      : Colors.white,
                                                                  width: 0.1 *
                                                                      size.width,
                                                                  height: 0.09 *
                                                                      size.height,
                                                                ),
                                                              )),
                                                        ],
                                                      )),

                                                  // const Spacer(),
                                                  Obx(() => SizedBox(
                                                        child: Row(
                                                          children: [
                                                            GestureDetector(
                                                                onTap: () {
                                                                  widget.controller
                                                                      .handleSelectLanguageAll(
                                                                          widget
                                                                              .controller,
                                                                          0);
                                                                },
                                                                child: Image.asset(
                                                                  LocalImage
                                                                      .googleTranslate,
                                                                  width: 0.04 *
                                                                      size.width,
                                                                  height: 0.09 *
                                                                      size.height,
                                                                )),
                                                            GestureDetector(
                                                                onTap: () {
                                                                  if (widget
                                                                      .controller
                                                                      .isDownloadedScreen) {
                                                                    widget.controller
                                                                        .handleDelete();
                                                                  } else {
                                                                    widget.controller
                                                                        .handleCheckAll();
                                                                  }
                                                                  //int readingId = topicService.topicReadings.topicReadings.readings[index].id;
                                                                  //bool currentStatus = controller.isDownloaded[readingId] ?? false;
                                                                  //controller.handleDownloadStatusChange(readingId, currentStatus);
                                                                },
                                                                child: !widget
                                                                        .controller
                                                                        .isDownloadedScreen
                                                                    ? RoundedButton(
                                                                        text: widget.controller
                                                                                    .isCheckAll ==
                                                                                false
                                                                            ? 'select_all'
                                                                                .tr
                                                                            : 'deselect_all'
                                                                                .tr,
                                                                        textColor: !widget
                                                                                    .controller.isCheckAll ==
                                                                                false
                                                                            ? Colors
                                                                                .white
                                                                            : Colors
                                                                                .black,
                                                                        color: !widget
                                                                                    .controller
                                                                                    .isCheckAll ==
                                                                                false
                                                                            ? const Color(
                                                                                0xFF00ADBB)
                                                                            : Colors
                                                                                .white,
                                                                        width: 0.1 *
                                                                            size.width,
                                                                        height: 0.09 *
                                                                            size.height,
                                                                      )
                                                                    : RoundedButton(
                                                                        text:
                                                                            'delete_all'
                                                                                .tr,
                                                                        textColor:
                                                                            Colors
                                                                                .red,
                                                                        color: Colors
                                                                            .white,
                                                                        width: 0.1 *
                                                                            size.width,
                                                                        height: 0.09 *
                                                                            size.height,
                                                                      )
                                                                // Image.asset(
                                                                //       controller.isCheckAll == false
                                                                //           ? LocalImage.checkboxUnChecked
                                                                //           : LocalImage.checkboxChecked,
                                                                //       width: 0.1 * size.height,
                                                                //       height: 0.1 * size.height,
                                                                //     ),

                                                                ),
                                                          ],
                                                        ),
                                                      )),
                                                ],
                                              )),
                                        ),
                                      ),
                                      SizedBox(
                                        width: size.width * 0.5,
                                        height: size.height * 0.55,
                                        child: SingleChildScrollView(
                                          controller: widget.controller
                                              .scrollControllerDownloadLesson,
                                          child: Column(children: [
                                            Obx(
                                              () => ListView.builder(
                                                shrinkWrap: true,
                                                physics:
                                                    const NeverScrollableScrollPhysics(),
                                                itemCount: topicService
                                                    .downloadAllReadingList.length,
                                                itemBuilder: (BuildContext context,
                                                    int index) {
                                                  return GestureDetector(
                                                    child: Padding(
                                                      padding: EdgeInsets.only(
                                                          bottom: 0.01 * size.height),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment.start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment.center,
                                                        children: [
                                                          SizedBox(
                                                            width: 0.01 * size.width,
                                                          ),
                                                          Expanded(
                                                            child: Container(
                                                                height: 0.24 *
                                                                    size.height,
                                                                padding:
                                                                    EdgeInsets.only(
                                                                        left: 0.01 *
                                                                            size.width),
                                                                child: Row(
                                                                  children: [
                                                                    SizedBox(
                                                                      width:
                                                                          size.width *
                                                                              0.05,
                                                                      child:
                                                                          RegularText(
                                                                        (index + 1)
                                                                            .toString(),
                                                                        style:
                                                                            const TextStyle(
                                                                          color: Colors
                                                                              .redAccent,
                                                                          fontWeight:
                                                                              FontWeight
                                                                                  .bold,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    ClipRRect(
                                                                      borderRadius:
                                                                          BorderRadius
                                                                              .circular(
                                                                                  10),
                                                                      child:
                                                                          CacheImage(
                                                                        url: topicService
                                                                            .downloadAllReadingList[
                                                                                index]
                                                                            .thumImg,
                                                                        width:
                                                                            size.width *
                                                                                0.1,
                                                                        height:
                                                                            size.height *
                                                                                0.2,
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                      width: 0.015 *
                                                                          size.width,
                                                                    ),
                                                                    Expanded(
                                                                      // child:SizedBox(
                                                                      // width: 185,
                                                                      child: Column(
                                                                        children: [
                                                                          SizedBox(
                                                                            height: 0.05 *
                                                                                size.height,
                                                                          ),
                                                                          Container(
                                                                            height: 0.05 *
                                                                                size.height,
                                                                            margin: EdgeInsets.only(
                                                                                left: 0.01 *
                                                                                    size.width),
                                                                            child:
                                                                                Align(
                                                                              alignment:
                                                                                  Alignment.centerLeft,
                                                                              child:
                                                                                  RegularText(
                                                                                topicService
                                                                                    .downloadAllReadingList[index]
                                                                                    .name,
                                                                                maxLines:
                                                                                    2,
                                                                                textAlign:
                                                                                    TextAlign.left,
                                                                                style:
                                                                                    const TextStyle(fontWeight: FontWeight.w700),
                                                                              ),
                                                                            ),
                                                                          ),

                                                                          GestureDetector(
                                                                            onTap:
                                                                                () {
                                                                              widget.controller.handleSelectLanguageAll(
                                                                                  widget.controller,
                                                                                  topicService.downloadAllReadingList[index].id);
                                                                            },
                                                                            child:
                                                                                Container(
                                                                              decoration:
                                                                                  BoxDecoration(
                                                                                borderRadius:
                                                                                    BorderRadius.circular(20),
                                                                                // color: Colors.redAccent,
                                                                                border:
                                                                                    Border.all(
                                                                                  color:
                                                                                      Colors.red,
                                                                                  width:
                                                                                      2,
                                                                                ),
                                                                              ),
                                                                              height: 0.07 *
                                                                                  size.height,
                                                                              width: double
                                                                                  .infinity,
                                                                              child: Align(
                                                                                  alignment: Alignment.center,
                                                                                  child: Obx(
                                                                                    () => RegularText(
                                                                                      'vietnamese'.tr + ((widget.controller.isDownloadedScreen && widget.controller.isDownloadedVideoMong[topicService.downloadAllReadingList[index].id]) || (!widget.controller.isDownloadedScreen && widget.controller.isCheckedMong[topicService.downloadAllReadingList[index].id]) ? (', ${'Hmong'.tr}') : ''),
                                                                                      maxLines: 1,
                                                                                      style: TextStyle(color: Colors.black87, fontSize: Fontsize.smaller),
                                                                                      textAlign: TextAlign.center,
                                                                                    ),
                                                                                  )),
                                                                            ),
                                                                          ),

                                                                          // if(controller.isVideoDownloaded[topicService.downloadAllReadingList[index].id])
                                                                          //   const SizedBox(width: 50),
                                                                          // if(controller.isVideoDownloaded[topicService.downloadAllReadingList[index].id])
                                                                          //   const RegularText(
                                                                          //       "Đã tải xuống",
                                                                          //       maxLines: 1,
                                                                          //       textAlign: TextAlign.right,
                                                                          //       style: TextStyle(
                                                                          //         fontWeight: FontWeight.w700,
                                                                          //         color: AppColor.secondary,
                                                                          //       )
                                                                          //
                                                                          //   )
                                                                        ],
                                                                        // ),
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                      width: 0.11 *
                                                                          size.width,
                                                                      child: Obx(() =>
                                                                          GestureDetector(
                                                                            onTap:
                                                                                () {
                                                                              if (widget
                                                                                  .controller
                                                                                  .isDownloadedScreen) {
                                                                                // bool currentStatus = controller.isDownloaded[readingId] ?? false;
                                                                                // if(controller.isMultipleDownloading[readingId] == false) {
                                                                                //   controller
                                                                                //       .handleDownloadStatusChange(
                                                                                //       readingId,
                                                                                //       currentStatus);
                                                                                // }
                                                                                widget
                                                                                    .controller
                                                                                    .handleDeleteSingle(topicService.downloadAllReadingList[index]);
                                                                              } else {
                                                                                int readingId = topicService
                                                                                    .downloadAllReadingList[index]
                                                                                    .id;
                                                                                bool
                                                                                    currentStatus =
                                                                                    widget.controller.isDownloaded[readingId] ?? false;
                                                                                if (widget.controller.isMultipleDownloading[readingId] ==
                                                                                    false) {
                                                                                  widget.controller.handleDownloadStatusChange(readingId,
                                                                                      currentStatus);
                                                                                }
                                                                              }
                                                                            },
                                                                            child: widget.controller.isMultipleDownloading[topicService.downloadAllReadingList[index].id] ==
                                                                                    true
                                                                                ? LoadingAnimationWidget
                                                                                    .inkDrop(
                                                                                    color: Colors.blue,
                                                                                    size: 30,
                                                                                  )
                                                                                : widget.controller.isDownloadedScreen
                                                                                    ? Image.asset(
                                                                                        LocalImage.trashCan,
                                                                                        width: 0.05 * size.height,
                                                                                        height: 0.05 * size.height,
                                                                                      )
                                                                                    : Image.asset(
                                                                                        widget.controller.isDownloaded[topicService.downloadAllReadingList[index].id] == false ? LocalImage.checkboxUnChecked : LocalImage.checkboxCheckedBlue,
                                                                                        width: 0.1 * size.height,
                                                                                        height: 0.1 * size.height,
                                                                                      ),
                                                                          )),
                                                                    )
                                                                  ],
                                                                )),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                          ]),
                                        ),
                                      ),


                                        ],
                                      )

                                ),
                              ),
                            ),
                            Positioned(
                              bottom: - size.height * 0.03,
                              left: size.width* 0.35,
                              child: Obx(
                                    () => !widget.controller.isDownloadedScreen
                                    ? ImageText(
                                  text: !widget.controller.isDownloadedScreen
                                      ? 'download'.tr
                                      : 'delete'.tr,
                                  pathImage:
                                  !widget.controller.isDownloadedScreen
                                      ? LocalImage.shapeButton
                                      : LocalImage.gradeName,
                                  isUpperCase: true,
                                  onTap: () {
                                    !widget.controller.isDownloadedScreen
                                        ? widget.controller.handleDownload()
                                        : widget.controller.handleDelete();
                                  },
                                  width: 0.16 * size.width,
                                  height: 0.14 * size.height,
                                )
                                    : SizedBox(
                                  width: 0.16 * size.width,
                                  height: 0.14 * size.height,
                                ),
                              ),
                            )
                          ],
                        ),

                      ],
                    ),
                  ),
                ],
              )),
        );
  }
}

class DialogELibraryDownloadAll extends StatefulWidget {
  const DialogELibraryDownloadAll({
    super.key,
    required this.controller,
  });
  final ElibraryController controller;
  @override
  State<DialogELibraryDownloadAll> createState() =>
      _DialogELibraryDownloadAll();
}

class _DialogELibraryDownloadAll extends State<DialogELibraryDownloadAll> {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    double screenWidth = MediaQuery.of(context).size.width;
    final ElibraryService elibraryService = Get.find<ElibraryService>();
    if (screenWidth < 900) {
    } else if (screenWidth < 1200 && screenWidth > 900) {}
    return AlertDialog(
        contentPadding: EdgeInsets.zero,
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.zero,
        elevation: 0,
        content: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            //print("Đăng test");
            // Get.back();
          },

              child: Row(
                children: [
                  const SizedBox(
                    width: 10,
                  ),
                  SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Center(
                              child: Container(
                                constraints: BoxConstraints.expand(
                                  width: size.width * 0.85,
                                  height: size.height * 0.9,
                                ),
                                decoration: const BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage(LocalImage.shapeGuide),
                                  ),
                                ),
                                child: Center(
                                  child: Column(
                                    children: [

                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Transform.translate(
                                            offset:  Offset(- size.width * 0.23,  - size.width * 0.02, ),
                                            child: ImageButton(
                                              onTap: () async {
                                                await LibFunction.effectExit();
                                                Get.back();
                                              },
                                              semantics: 'back',
                                              pathImage: LocalImage.backButton,
                                              height: 0.07 * size.width,
                                              width: 0.07 * size.width,
                                            ),
                                          ),
                                          Transform.translate(
                                            offset:  Offset(-20, - size.width * 0.025, ),
                                            child: ImageText(
                                              text: "library_title",
                                              style: TextStyle(
                                                fontSize: Fontsize.smaller,
                                              ),
                                              pathImage: LocalImage.shapeQuizTitle,
                                              isUpperCase: true,
                                              width: 0.18 * size.width,
                                              height: 0.12 * size.height,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        width: size.width * 0.5,
                                        child: GestureDetector(
                                          child: Padding(
                                              padding: EdgeInsets.only(
                                                  bottom: 0.01 * size.height),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Align(
                                                      alignment: Alignment.centerLeft,
                                                      child: Row(
                                                        children: [
                                                          Obx(() => GestureDetector(
                                                                onTap: () {
                                                                  widget.controller
                                                                      .handleChangeDownloadedScreen(
                                                                          true);
                                                                },
                                                                child: RoundedButton(
                                                                  text:
                                                                      "downloaded".tr,
                                                                  textColor: widget
                                                                          .controller
                                                                          .isDownloadedScreen
                                                                      ? Colors.white
                                                                      : Colors.black,
                                                                  color: widget
                                                                          .controller
                                                                          .isDownloadedScreen
                                                                      ? Colors
                                                                          .redAccent
                                                                      : Colors.white,
                                                                  width: 0.1 *
                                                                      size.width,
                                                                  height: 0.09 *
                                                                      size.height,
                                                                ),
                                                              )),
                                                          Obx(
                                                                  () => GestureDetector(
                                                                onTap: () {
                                                                  widget.controller
                                                                      .handleChangeDownloadedScreen(
                                                                          false);
                                                                },
                                                                child: RoundedButton(
                                                                  text: "download".tr,
                                                                  textColor: !widget
                                                                          .controller
                                                                          .isDownloadedScreen
                                                                      ? Colors.white
                                                                      : Colors.black,
                                                                  color: !widget
                                                                          .controller
                                                                          .isDownloadedScreen
                                                                      ? Colors
                                                                          .redAccent
                                                                      : Colors.white,
                                                                  width: 0.1 *
                                                                      size.width,
                                                                  height: 0.09 *
                                                                      size.height,
                                                                ),
                                                              )),
                                                        ],
                                                      )),

                                                  // const Spacer(),
                                                  SizedBox(
                                                    child: Row(
                                                      children: [
                                                        Obx(
                                                          () => GestureDetector(
                                                              onTap: () {
                                                                if (widget.controller
                                                                    .isDownloadedScreen) {
                                                                  widget.controller
                                                                      .handleDelete();
                                                                } else {
                                                                  widget.controller
                                                                      .handleCheckAll();
                                                                }
                                                                //int readingId = topicService.topicReadings.topicReadings.readings[index].id;
                                                                //bool currentStatus = widget.controller.isDownloaded[readingId] ?? false;
                                                                //widget.controller.handleDownloadStatusChange(readingId, currentStatus);
                                                              },
                                                              child: !widget
                                                                      .controller
                                                                      .isDownloadedScreen
                                                                  ? RoundedButton(
                                                                      text: widget.controller
                                                                                  .isCheckAll ==
                                                                              false
                                                                          ? "select_all"
                                                                              .tr
                                                                          : "deselect_all"
                                                                              .tr,
                                                                      textColor: !widget
                                                                                  .controller
                                                                                  .isCheckAll ==
                                                                              false
                                                                          ? Colors
                                                                              .white
                                                                          : Colors
                                                                              .black,
                                                                      color: !widget
                                                                                  .controller
                                                                                  .isCheckAll ==
                                                                              false
                                                                          ? const Color(
                                                                              0xFF00ADBB)
                                                                          : Colors
                                                                              .white,
                                                                      width: 0.1 *
                                                                          size.width,
                                                                      height: 0.09 *
                                                                          size.height,
                                                                    )
                                                                  : RoundedButton(
                                                                      text:
                                                                          "delete_all"
                                                                              .tr,
                                                                      textColor:
                                                                          Colors.red,
                                                                      color: Colors
                                                                          .white,
                                                                      width: 0.1 *
                                                                          size.width,
                                                                      height: 0.09 *
                                                                          size.height,
                                                                    )
                                                              // Image.asset(
                                                              //       widget.controller.isCheckAll == false
                                                              //           ? LocalImage.checkboxUnChecked
                                                              //           : LocalImage.checkboxChecked,
                                                              //       width: 0.1 * size.height,
                                                              //       height: 0.1 * size.height,
                                                              //     ),

                                                              ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              )),
                                        ),
                                      ),
                                      SizedBox(
                                        width: size.width * 0.5,
                                        height: size.height * 0.55,
                                        child: SingleChildScrollView(
                                          controller:
                                              widget.controller.scrollControllerBook,
                                          child: Column(children: [
                                            Obx(
                                              () => ListView.builder(
                                                shrinkWrap: true,
                                                physics:
                                                    const NeverScrollableScrollPhysics(),
                                                itemCount: elibraryService
                                                    .downloadAllReadingList.length,
                                                itemBuilder: (BuildContext context,
                                                    int index) {
                                                  return GestureDetector(
                                                    child: Padding(
                                                      padding: EdgeInsets.only(
                                                          bottom: 0.01 * size.height),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment.start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment.center,
                                                        children: [
                                                          SizedBox(
                                                            width: 0.01 * size.width,
                                                          ),
                                                          Expanded(
                                                            child: Container(
                                                                height: 0.24 *
                                                                    size.height,
                                                                padding:
                                                                    EdgeInsets.only(
                                                                        left: 0.01 *
                                                                            size.width),
                                                                child: Row(
                                                                  children: [
                                                                    SizedBox(
                                                                      width:
                                                                          size.width *
                                                                              0.05,
                                                                      child:
                                                                          RegularText(
                                                                        (index + 1)
                                                                            .toString(),
                                                                        style:
                                                                            const TextStyle(
                                                                          color: Colors
                                                                              .redAccent,
                                                                          fontWeight:
                                                                              FontWeight
                                                                                  .bold,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    ClipRRect(
                                                                      borderRadius:
                                                                          BorderRadius
                                                                              .circular(
                                                                                  10),
                                                                      child:
                                                                          CacheImage(
                                                                        url: elibraryService
                                                                            .downloadAllReadingList[
                                                                                index]
                                                                            .thum_img,
                                                                        width:
                                                                            size.width *
                                                                                0.1,
                                                                        height:
                                                                            size.height *
                                                                                0.2,
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                      width: 0.015 *
                                                                          size.width,
                                                                    ),
                                                                    Expanded(
                                                                      // child:SizedBox(
                                                                      // width: 185,
                                                                      child: Column(
                                                                        children: [
                                                                          SizedBox(
                                                                            height: 0.05 *
                                                                                size.height,
                                                                          ),
                                                                          Container(
                                                                            // height: 0.05 * size.height,
                                                                            margin: EdgeInsets.only(
                                                                                left: 0.01 *
                                                                                    size.width),
                                                                            child:
                                                                                Align(
                                                                              alignment:
                                                                                  Alignment.centerLeft,
                                                                              child:
                                                                                  RegularText(
                                                                                elibraryService
                                                                                    .downloadAllReadingList[index]
                                                                                    .name,
                                                                                maxLines:
                                                                                    2,
                                                                                textAlign:
                                                                                    TextAlign.left,
                                                                                style:
                                                                                    const TextStyle(fontWeight: FontWeight.w700),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                        // ),
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                      width: 0.11 *
                                                                          size.width,
                                                                      child: Obx(() =>
                                                                          GestureDetector(
                                                                            onTap:
                                                                                () {
                                                                              if (widget
                                                                                  .controller
                                                                                  .isDownloadedScreen) {
                                                                                // bool currentStatus = widget.controller.isDownloaded[readingId] ?? false;
                                                                                // if(widget.controller.isMultipleDownloading[readingId] == false) {
                                                                                //   widget.controller
                                                                                //       .handleDownloadStatusChange(
                                                                                //       readingId,
                                                                                //       currentStatus);
                                                                                // }
                                                                                widget
                                                                                    .controller
                                                                                    .handleDeleteSingle(elibraryService.downloadAllReadingList[index]);
                                                                              } else {
                                                                                int readingId = elibraryService
                                                                                    .downloadAllReadingList[index]
                                                                                    .id;
                                                                                bool
                                                                                    currentStatus =
                                                                                    widget.controller.isBookDownloaded[readingId] ?? false;
                                                                                if (widget.controller.isMultipleDownloading[readingId] ==
                                                                                    false) {
                                                                                  widget.controller.handleDownloadStatusChange(readingId,
                                                                                      currentStatus);
                                                                                }
                                                                              }
                                                                            },
                                                                            child: widget.controller.isMultipleDownloading[elibraryService.downloadAllReadingList[index].id] ==
                                                                                    true
                                                                                ? LoadingAnimationWidget
                                                                                    .inkDrop(
                                                                                    color: Colors.blue,
                                                                                    size: 30,
                                                                                  )
                                                                                : widget.controller.isDownloadedScreen
                                                                                    ? Image.asset(
                                                                                        LocalImage.trashCan,
                                                                                        width: 0.05 * size.height,
                                                                                        height: 0.05 * size.height,
                                                                                      )
                                                                                    : Image.asset(
                                                                                        widget.controller.isBookDownloaded[elibraryService.downloadAllReadingList[index].id] == false ? LocalImage.checkboxUnChecked : LocalImage.checkboxCheckedBlue,
                                                                                        width: 0.1 * size.height,
                                                                                        height: 0.1 * size.height,
                                                                                      ),
                                                                          )),
                                                                    )
                                                                  ],
                                                                )),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                          ]),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: - size.height * 0.03,
                              left: size.width* 0.35,
                              child: Obx(
                                    () => !widget.controller.isDownloadedScreen
                                    ? ImageText(
                                  text: !widget.controller.isDownloadedScreen
                                      ? 'download'.tr
                                      : 'delete'.tr,
                                  pathImage:
                                  !widget.controller.isDownloadedScreen
                                      ? LocalImage.shapeButton
                                      : LocalImage.gradeName,
                                  isUpperCase: true,
                                  onTap: () {
                                    !widget.controller.isDownloadedScreen
                                        ? widget.controller.handleDownload()
                                        : widget.controller.handleDelete();
                                  },
                                  width: 0.16 * size.width,
                                  height: 0.14 * size.height,
                                )
                                    : SizedBox(
                                  width: 0.16 * size.width,
                                  height: 0.14 * size.height,
                                ),
                              ),
                            )
                          ],
                        ),

                      ],
                    ),
                  ),
                ],
              )),
        );
  }
}

class RoundedButton extends StatelessWidget {
  final double width;
  final double height;
  final String text;
  final Color color;
  final Color textColor;

  const RoundedButton(
      {super.key,
      this.width = 150,
      this.height = 50,
      required this.text,
      required this.color,
      required this.textColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: const EdgeInsets.only(left: 10.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: color,
        border: Border.all(
          color: Colors.black,
          width: 0.2,
        ),
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            color: textColor,
            fontSize: Fontsize.smaller,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
