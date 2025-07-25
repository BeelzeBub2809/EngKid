import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:EngKid/presentation/notification_system/notification_setting/notification_setting_controller.dart';
import 'package:EngKid/utils/font_size.dart';

import 'package:EngKid/utils/images.dart';
import 'package:EngKid/widgets/button/image_button.dart';

class NotificationSettingScreen extends GetView<NotificationSettingController> {
  const NotificationSettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(LocalImage.messageBg),
            fit: BoxFit.fill,
          ),
        ),
        width: size.width,
        height: size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 0.02 * size.height),
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.all(0.03 * size.width),
                    child: ImageButton(
                      onTap: () {
                        // if (onBack != null) {
                        //   onBack!();
                        // }
                        Get.back();
                      },
                      semantics: 'back',
                      pathImage: LocalImage.arrowLeftRed,
                      height: 0.06 * size.width,
                      width: 0.06 * size.width,
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(0.03 * size.width),
                      child: Semantics(
                        label: 'notification_setting'.tr,
                        child: Text(
                          "notification_setting".tr,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: Fontsize.large,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(
                horizontal: 0.05 * size.width,
              ),
              padding: EdgeInsets.symmetric(
                horizontal: 0.03 * size.width,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  width: 1,
                  color: const Color(
                    0xffF3F3F3,
                  ),
                ),
                borderRadius: BorderRadius.all(
                  Radius.circular(
                    0.02 * size.width,
                  ),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      ImageButton(
                        onTap: () {},
                        pathImage: LocalImage.bellBlack,
                        height: 0.06 * size.width,
                        width: 0.06 * size.width,
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 0.02 * size.width,
                          ),
                          child: Text(
                            "notification_enable".tr,
                            style: TextStyle(
                              fontSize: Fontsize.normal,
                            ),
                          ),
                        ),
                      ),
                      Obx(
                        () => Switch(
                          value: controller.isEnableNotification,
                          onChanged: (bool value) {
                            controller.isEnableNotification = value;
                          },
                        ),
                      ),
                    ],
                  ),
                  // const Divider(
                  //   height: 1,
                  // ),
                  // Row(
                  //   children: [
                  //     ImageButton(
                  //       onTap: () {
                  //         // if (onBack != null) {
                  //         //   onBack!();
                  //         // }
                  //         Get.back();
                  //       },
                  //       pathImage: LocalImage.audioBlack,
                  //       height: 0.06 * size.width,
                  //       width: 0.06 * size.width,
                  //     ),
                  //     Expanded(
                  //       child: Padding(
                  //         padding: EdgeInsets.symmetric(
                  //           horizontal: 0.02 * size.width,
                  //         ),
                  //         child: Text(
                  //           "notification_audio_enable".tr,
                  //           style: TextStyle(
                  //             fontSize: Fontsize.normal,
                  //           ),
                  //         ),
                  //       ),
                  //     ),
                  //     Obx(
                  //       () => Switch(
                  //         value: controller.isEnableNotification,
                  //         onChanged: (bool value) {
                  //           controller.isEnableNotification = value;
                  //         },
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  // const Divider(
                  //   height: 1,
                  // ),
                  // Padding(
                  //   padding: EdgeInsets.symmetric(
                  //     vertical: LibFunction.scaleForCurrentValue(
                  //       size,
                  //       48,
                  //     ),
                  //   ),
                  //   child: Column(
                  //     children: [
                  //       Row(
                  //         children: [
                  //           ImageButton(
                  //             onTap: () {
                  //               // if (onBack != null) {
                  //               //   onBack!();
                  //               // }
                  //               Get.back();
                  //             },
                  //             pathImage: LocalImage.soundBlack,
                  //             height: 0.06 * size.width,
                  //             width: 0.06 * size.width,
                  //           ),
                  //           Expanded(
                  //             child: Padding(
                  //               padding: EdgeInsets.symmetric(
                  //                 horizontal: 0.02 * size.width,
                  //               ),
                  //               child: Text(
                  //                 "notification_sound_setting".tr,
                  //                 style: TextStyle(
                  //                   fontSize: Fontsize.normal,
                  //                 ),
                  //               ),
                  //             ),
                  //           ),
                  //         ],
                  //       ),
                  //       SizedBox(
                  //         height: 0.01 * size.height,
                  //       ),
                  //       SfSliderTheme(
                  //         data: SfSliderThemeData(
                  //           activeTrackHeight: 0.02 * size.width,
                  //           inactiveTrackHeight: 0.02 * size.width,
                  //           thumbRadius: 0.02 * size.width,
                  //           overlayRadius: 0,
                  //         ),
                  //         child: SfSlider(
                  //           // inactiveColor: const Color(0XFFb9dedf),
                  //           // activeColor: const Color(0XFFf1b843),
                  //           // thumbIcon: Container(
                  //           //   color: AppColor.lightYellow,
                  //           //   child: Image.asset(
                  //           //     LocalImage.volumnButton,
                  //           //   ),
                  //           // ),
                  //           min: 0.0,
                  //           max: 10.0,
                  //           value: 0,
                  //           onChanged: (value) {},
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
