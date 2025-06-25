import 'dart:async';
import 'package:EngKid/presentation/register/register_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:local_captcha/local_captcha.dart';
import '../../utils/app_color.dart';
import '../../utils/font_size.dart';
import '../../utils/images.dart';
import '../../utils/timer_cowndown.dart';
import '../../widgets/commom/commom_widget.dart';
import '../../widgets/input/text_field_widget.dart';
import '../../widgets/pinput/pinput_widget.dart';
import '../../widgets/register/item_dropdown_have_title.dart';
import '../../widgets/register/item_input_register.dart';
import '../../widgets/text/image_text.dart';
import '../../widgets/text/regular_text.dart';

class RegisterScreen extends GetView<RegisterController> {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return  Scaffold(
      body: _buildUI(size, context),
    );
  }

  Widget _buildUI(Size size, BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          alignment: Alignment.topLeft,
          width: size.width,
          height: size.height * 0.26,
          // decoration: const BoxDecoration(
          //   image: DecorationImage(
          //     image: AssetImage(LocalImage.loginBg),
          //     fit: BoxFit.fitWidth,
          //   ),
          // ),
          child: GestureDetector(
            onTap: () {
              Get.back();
            },
            child: Padding(
              padding: EdgeInsets.only(
                  top: 0.04 * size.width, left: 0.04 * size.width),
              child: Image.asset(
                LocalImage.backButton,
                width: size.width * 0.12,
                height: size.height * 0.06,
                fit: BoxFit.fill,
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            width: size.width,
            height: size.height - 120,
            margin: EdgeInsets.only(
                left: 10, right: 10, bottom: size.height * 0.05),
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(LocalImage.shapeLogin),
                fit: BoxFit.fill,
              ),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: size.width * 0.04),
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: size.height * 0.02),
                            child: RegularText(
                              "register".tr,
                              style: TextStyle(
                                color: AppColor.red,
                                fontSize: Fontsize.huge,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Obx(
                            () => ItemInputRegister(
                              size: size,
                              controller: controller.nameParentsRx.obs,
                              validateValue: controller.validateNameParents,
                              title: "full name",
                              onChange: (text) {
                                controller.onChangeInput(
                                    input: text,
                                    type: RegisterInputType.nameParents);
                              },
                            ),
                          ),
                          Obx(
                            () => ItemInputRegister(
                              size: size,
                              controller: controller.loginId.obs,
                              title: "user_name",
                              validateValue: controller.validateIdLogin,
                              isLoginId: true,
                              onChange: (text) {
                                controller.onChangeInput(
                                    input: text,
                                    type: RegisterInputType.loginId);
                              },
                            ),
                          ),
                          Obx(
                            () => ItemInputRegister(
                              size: size,
                              controller: controller.phoneNumberRx.obs,
                              title: 'phone_number'.tr,
                              validateValue: controller.validatePhoneNumber,
                              onChange: (text) {
                                controller.onChangeInput(
                                    input: text,
                                    type: RegisterInputType.phoneNumber);
                              },
                              isTypeNumber: true,
                            ),
                          ),
                          Obx(
                            () => ItemInputRegister(
                              size: size,
                              controller: controller.gmailAddressRx.obs,
                              validateValue: controller.validateGmail,
                              title: 'Email',
                              onChange: (text) {
                                controller.onChangeInput(
                                    input: text,
                                    type: RegisterInputType.gmailAddress);
                              },
                            ),
                          ),

                          /// form enter info

                          Padding(
                            padding: const EdgeInsets.only(top: 25),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'sex'.tr,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: Fontsize.normal,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    ...["male", "female", "other"]
                                        .map((gender) => Row(
                                              children: [
                                                Text(
                                                  gender.tr,
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: Fontsize.small,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: size.width * 0.02,
                                                ),
                                                Obx(
                                                  () => GestureDetector(
                                                    onTap: () {
                                                      controller
                                                          .selectGender(gender);
                                                    },
                                                    child: Image.asset(
                                                      controller.sexRx == gender
                                                          ? LocalImage
                                                              .checkboxChecked
                                                          : LocalImage
                                                              .checkboxUnChecked,
                                                      width: 24,
                                                      height: 24,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: size.width * 0.02,
                                                ),
                                              ],
                                            ))
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Obx(
                            () => Padding(
                              padding: EdgeInsets.only(
                                  top: controller.validateSex.isNotEmpty
                                      ? 10
                                      : 0),
                              child: Text(
                                controller.validateSex.tr,
                                style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.red),
                              ),
                            ),
                          ),
                          Obx(() => ItemInputRegister(
                                size: size,
                                controller: controller.password.obs,
                                validateValue: controller.validatePassword,
                                title: 'password'.tr,
                                onChange: (text) {
                                  controller.onChangeInput(
                                      input: text,
                                      type: RegisterInputType.password);
                                },
                                isTypeNumber: false,
                              )),
                          Obx(() => ItemInputRegister(
                                size: size,
                                controller: controller.confirmPassword.obs,
                                validateValue:
                                    controller.validateConfirmPassword,
                                title: 'confirm_password'.tr,
                                onChange: (text) {
                                  controller.onChangeInput(
                                      input: text,
                                      type: RegisterInputType.confirmPassword);
                                },
                                isTypeNumber: false,
                              )),
                        ],
                      ),
                    ),
                  ),

                  /// button next
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        alignment: Alignment.bottomLeft,
                        padding: EdgeInsets.only(right: size.width * 0.08),
                        width: 100,
                        height: 100,
                        child: Image.asset(
                          LocalImage.mascotWelcome,
                          width: size.width * 0.3,
                          height: size.height * 0.3,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            bottom: size.height * 0.03,
                            top: size.height * 0.03),
                        child: Align(
                          alignment: Alignment.bottomRight,
                          child: ImageText(
                            text: 'next'.tr,
                            pathImage: LocalImage.shapeButtonSubmit,
                            onTap: () async {
                              if (await controller.validateSignUp()) {
                                controller.signUpAccount();
                              }
                            },
                            isUpperCase: true,
                            width: size.width * 0.3,
                            height: size.height * 0.06,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
