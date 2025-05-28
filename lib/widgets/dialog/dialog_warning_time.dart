import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:EngKid/utils/app_color.dart';
import 'package:EngKid/utils/font_size.dart';
import 'package:EngKid/utils/images.dart';
import 'package:EngKid/widgets/text/image_text.dart';

class DialogWarningTime extends StatelessWidget {
  const DialogWarningTime({
    super.key,
    required this.timer,
    required this.onTapContinue,
  });
  final String timer;
  final Function onTapContinue;
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
              height: size.height * 0.55,
              width: size.width * 0.65,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(LocalImage.surveyIncorrect),
                  fit: BoxFit.fill,
                ),
              ),
              child: Column(
                // crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    LocalImage.warningTime,
                    width: 0.25 * size.height,
                    height: 0.25 * size.height,
                  ),
                  RichText(
                    maxLines: 3,
                    text: TextSpan(
                      text: "expired_time_1".tr,
                      style: TextStyle(
                        color: AppColor.textDefault,
                        fontSize: Fontsize.smaller + 1,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Lato',
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text: " $timer ${"minute".tr} ",
                          style: const TextStyle(color: AppColor.red),
                        ),
                        TextSpan(
                          text: "expired_time_2".tr,
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
                    text: "rest",
                    isUpperCase: true,
                    onTap: () async {
                      exit(0);
                    },
                    pathImage: LocalImage.shapeButton,
                    width: size.width * 0.16,
                    height: size.height * 0.12,
                  ),
                  SizedBox(
                    width: 0.03 * size.width,
                  ),
                  ImageText(
                    text: "continue",
                    isUpperCase: true,
                    onTap: () async {
                      Get.back();
                      onTapContinue();
                    },
                    pathImage: LocalImage.shapeButton,
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
