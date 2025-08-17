import 'package:EngKid/presentation/forgot_pass/forgot_pass_controller.dart';
import 'package:EngKid/presentation/my_library/my_library_ui.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:EngKid/utils/app_color.dart';
import 'package:EngKid/utils/app_route.dart';
import 'package:EngKid/utils/font_size.dart';
import 'package:EngKid/utils/images.dart';
import 'package:EngKid/widgets/input/landscape_textfield.dart';
import 'package:EngKid/widgets/text/image_text.dart';
import 'package:EngKid/widgets/text/regular_text.dart';

class ForgotPassScreen extends GetView<ForgotPassController> {
  const ForgotPassScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        width: size.width,
        height: size.height,
        // decoration: const BoxDecoration(
        //   image: DecorationImage(
        //     image: AssetImage(LocalImage.loginBg),
        //     fit: BoxFit.fill,
        //   ),
        // ),
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            0.1 * size.height, // Left
            0.0,               // Top
            0.1 * size.height, // Right
            0.1 * size.height, // Bottom
          ),
          child: Stack(
            children: [
              Center(
                child: Container(
                  width: 0.7 * size.width,
                  height: 0.73 * size.height,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(LocalImage.shapeLogin),
                      fit: BoxFit.fill,
                    ),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 0.12 * size.height),
                          child: RegularText(
                            'forgot_password'.tr,
                            style: TextStyle(
                              color: AppColor.red,
                              fontSize: Fontsize.huge,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: Text(
                                    "email".tr,
                                    style: TextStyle(
                                      fontSize: Fontsize.normal,
                                      fontWeight: FontWeight.w600,
                                      color: AppColor.gray,
                                    ),
                                  ),
                                ),
                                Obx(
                                  () => SizedBox(
                                    width: 0.3 * size.width,
                                    child: LandScapeTextField(
                                      maxLength: 30,
                                      input: controller.email,
                                      keyboardType: TextInputType.text,
                                      backgroundColor: Colors.transparent,
                                      borderColor: Colors.black38,
                                      textAlign: Alignment.bottomCenter,
                                      textStyle: TextStyle(
                                        fontSize: Fontsize.biggest,
                                        fontWeight: FontWeight.w600,
                                        color: AppColor.gray,
                                      ),
                                      onChange: (text) =>
                                          controller.onChangeInput(
                                        input: text,
                                        type: ForgotPassInputType.email,
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned.fill(
                                  child: Align(
                                    alignment: Alignment.bottomCenter,
                                    child: ImageText(
                                      text: 'send_otp'.tr,
                                      pathImage: LocalImage.shapeButton,
                                      onTap: () {
                                      },
                                      isUpperCase: true,
                                      width: size.width * 0.1,
                                      height: size.height * 0.08,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: Text(
                                    "OTP",
                                    style: TextStyle(
                                      fontSize: Fontsize.normal,
                                      fontWeight: FontWeight.w600,
                                      color: AppColor.gray,
                                    ),
                                  ),
                                ),
                                Obx(
                                      () => SizedBox(
                                    width: 0.3 * size.width,
                                    child: LandScapeTextField(
                                      maxLength: 30,
                                      input: controller.otp,
                                      keyboardType: TextInputType.text,
                                      backgroundColor: Colors.transparent,
                                      borderColor: Colors.black38,
                                      textAlign: Alignment.bottomCenter,
                                      textStyle: TextStyle(
                                        fontSize: Fontsize.biggest,
                                        fontWeight: FontWeight.w600,
                                        color: AppColor.gray,
                                      ),
                                      onChange: (text) =>
                                          controller.onChangeInput(
                                            input: text,
                                            type: ForgotPassInputType.otp,
                                          ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: Text(
                                    "password".tr,
                                    style: TextStyle(
                                      fontSize: Fontsize.normal,
                                      fontWeight: FontWeight.w600,
                                      color: AppColor.gray,
                                    ),
                                  ),
                                ),
                                Obx(
                                  () => SizedBox(
                                    width: 0.3 * size.width,
                                    child: LandScapeTextField(
                                      input: controller.password,
                                      keyboardType: TextInputType.text,
                                      backgroundColor: Colors.transparent,
                                      borderColor: Colors.black38,
                                      textAlign: Alignment.bottomCenter,
                                      textStyle: TextStyle(
                                        fontSize: Fontsize.biggest,
                                        fontWeight: FontWeight.w600,
                                        color: AppColor.gray,
                                      ),
                                      onChange: (text) =>
                                          controller.onChangeInput(
                                        input: text,
                                        type: ForgotPassInputType.password,
                                      ),
                                      //hide password
                                      obscureText: true,
                                    ),
                                  ),
                                )
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: Text(
                                    "confirm_password".tr,
                                    style: TextStyle(
                                      fontSize: Fontsize.normal,
                                      fontWeight: FontWeight.w600,
                                      color: AppColor.gray,
                                    ),
                                  ),
                                ),
                                Obx(
                                      () => SizedBox(
                                    width: 0.3 * size.width,
                                    child: LandScapeTextField(
                                      input: controller.confirmPassword,
                                      keyboardType: TextInputType.text,
                                      backgroundColor: Colors.transparent,
                                      borderColor: Colors.black38,
                                      textAlign: Alignment.bottomCenter,
                                      textStyle: TextStyle(
                                        fontSize: Fontsize.biggest,
                                        fontWeight: FontWeight.w600,
                                        color: AppColor.gray,
                                      ),
                                      onChange: (text) =>
                                          controller.onChangeInput(
                                            input: text,
                                            type: ForgotPassInputType.confirmPassword,
                                          ),
                                      //hide password
                                      obscureText: true,
                                    ),
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned.fill(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 0.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ImageText(
                          text: 'login'.tr,
                          pathImage: LocalImage.shapeButton,
                          onTap: () {
                            Get.toNamed(AppRoute.login);
                          },
                          isUpperCase: true,
                          width: size.width * 0.18,
                          height: size.height * 0.14,
                        ),

                        const SizedBox(width: 20.0),

                        // Nút thứ hai (Change Password)
                        ImageText(
                          text: 'change_password'.tr,
                          pathImage: LocalImage.shapeButtonSubmit,
                          onTap: () {},
                          isUpperCase: true,
                          width: size.width * 0.18,
                          height: size.height * 0.14,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned.fill(
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: GestureDetector(
                    onTap: () {
                      // Get.toNamed(AppRoute.speechTextSample);
                    },
                    child: Image.asset(
                      LocalImage.mascotWelcome,
                      width: size.width * 0.28,
                      height: size.height * 0.38,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
