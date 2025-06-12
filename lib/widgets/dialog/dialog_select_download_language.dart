import 'package:EngKid/presentation/reading_space/reading_space_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:EngKid/utils/app_color.dart';
import 'package:EngKid/utils/font_size.dart';
import 'package:EngKid/utils/images.dart';
import 'package:EngKid/widgets/text/image_text.dart';

class DialogSelectDownloadLanguage extends StatelessWidget {
  const DialogSelectDownloadLanguage(
      {super.key,
      required this.onTapContinue,
      required this.controller,
      required this.readingId,
      required this.continueText});
  final int readingId;
  final Function onTapContinue;
  final ReadingSpaceController controller;
  final String continueText;
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      backgroundColor: Colors.transparent,
      elevation: 0,
      content: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 0.16 * size.height),
            child: Container(
              height: size.height * 0.5,
              width: size.width * 0.5,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(LocalImage.surveyIncorrect),
                  fit: BoxFit.fill,
                ),
              ),
              child: Column(
                // crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                // crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  FractionallySizedBox(
                      widthFactor: 0.8,
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          "select_language".tr,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColor.textDefault,
                              fontFamily: "lato",
                              fontSize: Fontsize.large),
                        ),
                      )),
                  FractionallySizedBox(
                    // alignment: Alignment.center,
                    widthFactor: 0.6,
                    child: Column(
                      // crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 0),
                          child: Row(
                            // crossAxisAlignment: CrossAxisAlignment.center,
                            // mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                flex: 1,
                                child: Text(
                                  "vietnamese".tr,
                                  style: TextStyle(fontSize: Fontsize.normal),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Text(
                                  "( ${'default'.tr} )",
                                  style: TextStyle(fontSize: Fontsize.normal),
                                  textAlign: TextAlign.center,
                                ),
                              )
                            ],
                          ),
                        ),
                        if (controller.isHasVideoMong[readingId])
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 12, horizontal: 0),
                            child: Row(
                              // crossAxisAlignment: CrossAxisAlignment.center,
                              // mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                    flex: 1,
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        "Hmong".tr,
                                        style: TextStyle(
                                            fontSize: Fontsize.normal),
                                      ),
                                    )),
                                Expanded(
                                    flex: 1,
                                    child: Obx(
                                      () => GestureDetector(
                                        onTap: () {
                                          controller
                                              .handleChangeLanguageDownload(
                                                  "mo");
                                        },
                                        child: controller.isSelectedMong
                                            ? Image.asset(
                                                LocalImage.checkboxChecked,
                                                width: 0.05 * size.height,
                                                height: 0.05 * size.height,
                                              )
                                            : Image.asset(
                                                LocalImage.checkboxUnChecked,
                                                width: 0.05 * size.height,
                                                height: 0.05 * size.height,
                                              ),
                                      ),
                                    ))
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 0.1 * size.height,
                  )
                ],
              ),
            ),
          ),
          Positioned.fill(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ImageText(
                    text: continueText,
                    isUpperCase: true,
                    onTap: () async {
                      Get.back();
                      onTapContinue();
                    },
                    pathImage: LocalImage.shapeButton,
                    width: size.width * 0.16,
                    height: size.height * 0.12,
                  ),
                  SizedBox(
                    width: 0.03 * size.width,
                  ),
                  ImageText(
                    text: "back".tr,
                    isUpperCase: true,
                    onTap: () async {
                      Get.back();
                    },
                    pathImage: LocalImage.gradeName,
                    width: size.width * 0.16,
                    height: size.height * 0.12,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
