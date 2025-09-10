import 'dart:io';
import 'package:EngKid/presentation/management_space/profile/profile_parent/profile_parent_controller.dart';
import 'package:EngKid/utils/font_size.dart';
import 'package:EngKid/utils/images.dart';
import 'package:EngKid/utils/timer_cowndown.dart';
import 'package:EngKid/widgets/commom/commom_widget.dart';
import 'package:EngKid/widgets/input/text_field_widget.dart';
import 'package:EngKid/widgets/pinput/pinput_widget.dart';
import 'package:EngKid/widgets/register/item_dropdown_have_title.dart';
import 'package:EngKid/widgets/text/image_text.dart';
import 'package:EngKid/widgets/text/regular_text.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:EngKid/utils/app_color.dart';
import 'package:EngKid/utils/im_utils.dart';
import 'package:EngKid/widgets/button/image_button.dart';
import 'package:EngKid/widgets/dialog/dialog_alert.dart';
import 'package:EngKid/widgets/image/cache_image.dart';
import 'package:intl/intl.dart';

class ProfileParentScreen extends GetView<ProfileParentController> {
  const ProfileParentScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      body: _buildUI(size, context),
    );
  }

  Widget _buildUI(Size size, BuildContext context) {
    return Container(
      width: Get.width,
      height: Get.height,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(LocalImage.spaceBg),
          fit: BoxFit.fill,
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: Platform.isIOS ? 20 : 0),
            child: _buildHeader(size),
          ),
          Expanded(
              child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: Get.height * 0.02, vertical: Get.height * 0.01),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Stack(
                      children: [
                        Obx(
                          () => ClipOval(
                            child: controller.imagePath.isNotEmpty
                                ? Image.file(
                                    File(controller.imagePath),
                                    fit: BoxFit.cover,
                                    height: 0.11 * size.height,
                                    width: 0.11 * size.height,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Image.asset(
                                        LocalImage.avatarParent,
                                        width: 0.11 * size.height,
                                        height: 0.11 * size.height,
                                        fit: BoxFit.cover,
                                      );
                                    },
                                  )
                                : ClipRRect(
                                    borderRadius: BorderRadius.circular(
                                        0.06 * size.height),
                                    child: CacheImage(
                                      url: controller.urlImage,
                                      width: 0.11 * size.height,
                                      height: 0.11 * size.height,
                                    ),
                                  ),
                          ),
                        ),
                        Obx(
                          () => controller.isEdit
                              ? Positioned(
                                  bottom: 0,
                                  right: 5,
                                  child: GestureDetector(
                                    onTap: () {
                                      CommonWidget.bottomSheet(
                                        controller.listItemBts,
                                        (index) {
                                          controller.getFunctionByIndex(
                                              index, context);
                                        },
                                        context,
                                      );
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.white,
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.white.withOpacity(0.5),
                                            blurRadius: 10,
                                            spreadRadius: 2,
                                          ),
                                        ],
                                      ),
                                      child: Semantics(
                                        label: 'camera',
                                        child: const Icon(
                                          Icons.camera_alt_outlined,
                                          color: AppColor.blue,
                                          size: 20,
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              : const SizedBox(),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: Get.height * 0.02),
                    child: Obx(
                      () => SizedBox(
                        width: Get.width,
                        child: CommonWidget.textFieldWithTitle(
                            validateNotify: controller.validateName,
                            horizontal: 6,
                            vertical: 0,
                            title: 'parent_name'.tr,
                            child: TextFieldWidget(
                                enabled: controller.isEdit ? true : false,
                                prefixIcon: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.person,
                                      color: AppColor.blue,
                                      size: 22,
                                    ),
                                  ],
                                ),
                                onChange: (val) {
                                  controller.onChangeInput(
                                      input: val,
                                      type: ProfileInputType.nameParent);
                                },
                                controller: controller.nameController,
                                hintText: '')),
                      ),
                    ),
                  ),
                  Obx(
                    () => SizedBox(
                      width: Get.width,
                      child: CommonWidget.textFieldWithTitle(
                          validateNotify: controller.validatePhoneNumber,
                          horizontal: 6,
                          vertical: 0,
                          title: 'phone_number'.tr,
                          child: TextFieldWidget(
                              enabled: controller.isEdit ? true : false,
                              prefixIcon: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.phone,
                                    color: AppColor.blue,
                                    size: 22,
                                  ),
                                ],
                              ),
                              keyboardType: TextInputType.number,
                              suffixIcon: const SizedBox(),
                              onChange: (val) {
                                controller.onChangeInput(
                                    input: val,
                                    type: ProfileInputType.phoneNumber);
                              },
                              controller: controller.phoneNumberController,
                              hintText: '')),
                    ),
                  ),
                  Obx(
                    () => SizedBox(
                      width: Get.width,
                      child: CommonWidget.textFieldWithTitle(
                          validateNotify: controller.validateGmail,
                          horizontal: 6,
                          vertical: 0,
                          title: 'Email'.tr,
                          child: TextFieldWidget(
                              enabled: controller.isEdit ? true : false,
                              prefixIcon: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.email,
                                    color: AppColor.blue,
                                    size: 22,
                                  ),
                                ],
                              ),
                              onChange: (val) {
                                controller.onChangeInput(
                                    input: val, type: ProfileInputType.email);
                              },
                              controller: controller.emailController,
                              hintText: '')),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        RegularText(
                          'sex'.tr,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: Fontsize.small,
                            fontWeight: FontWeight.w500,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        SizedBox(
                          width: size.width * 0.4,
                        ),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ...[
                                "male",
                                "female",
                              ].map((sex) => Row(
                                children: [
                                  RegularText(
                                    sex.tr,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: Fontsize.small,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(
                                    width: Get.width * 0.02,
                                  ),
                                  Obx(
                                        () => GestureDetector(
                                      onTap: () {
                                        controller.selectSex(sex);
                                      },
                                      child: Image.asset(
                                        controller.sex == sex
                                            ? LocalImage.checkboxChecked
                                            : LocalImage.checkboxUnChecked,
                                        width: 24,
                                        height: 24,
                                      ),
                                    ),
                                  ),
                                ],
                              ))
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Obx(
                        () => SizedBox(
                      width: Get.width,
                      child: CommonWidget.textFieldWithTitle(
                        validateNotify: controller.validateDateOfBirth,
                        horizontal: 6,
                        vertical: 0,
                        title: 'date_of_birth'.tr,
                        child: TextFieldWidget(
                            controller: controller.dateOfBirthController,
                            enabled: controller.isEdit ? true : false,
                            prefixIcon: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.code,
                                  color: AppColor.red,
                                  size: 22,
                                ),
                              ],
                            ),
                            onChange: (val) {
                              controller.onChangeInput(
                                  input: val,
                                  type: ProfileInputType.dateOfBirth);
                            },
                            hintText: '',
                            suffixIcon: GestureDetector(
                              onTap: () async {
                                final selectedDates =
                                await showCalendarDatePicker2Dialog(
                                  context: Get.context!,
                                  config:
                                  CalendarDatePicker2WithActionButtonsConfig(
                                    calendarType:
                                    CalendarDatePicker2Type.single,
                                    selectedDayHighlightColor: Colors.red,
                                  ),
                                  dialogSize:
                                  Size(Get.width * 0.8, Get.height * 0.5),
                                  value: [
                                    controller.selectedDate ?? DateTime.now()
                                  ],
                                );

                                if (selectedDates != null &&
                                    selectedDates.isNotEmpty) {
                                  controller.selectedDate = selectedDates.first;
                                  controller.dateOfBirthRx =
                                      DateFormat('dd/MM/yyyy')
                                          .format(selectedDates.first!);

                                  controller.onChangeInput(
                                      input: controller.dateOfBirthRx,
                                      type: ProfileInputType.dateOfBirth);
                                }
                              },
                              child: Icon(
                                Icons.calendar_month,
                                size: 30,
                                color: controller.isEdit
                                    ? AppColor.red
                                    : AppColor.gray,
                              ),
                            )),
                      ),
                    ),
                  ),
                  // Padding(
                  //   padding: EdgeInsets.only(top: size.width * 0.1),
                  //   child: RegularText(
                  //     isUpperCase: true,
                  //     'note_profile'.tr,
                  //     maxLines: 2,
                  //     style: const TextStyle(
                  //       color: AppColor.red,
                  //       fontSize: 14,
                  //       fontStyle: FontStyle.italic,
                  //       fontWeight: FontWeight.bold,
                  //       wordSpacing: 1,
                  //       height: 1.5,
                  //     ),
                  //   ),
                  // )
                ],
              ),
            ),
          )),
          Obx(
            () => Padding(
              padding: EdgeInsets.only(bottom: Get.height * 0.02),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: ImageText(
                  text: 'update_profile'.tr,
                  pathImage: LocalImage.shapeButton,
                  isUpperCase: true,
                  onTap: controller.isEdit
                      ? () async {
                          await controller.updateProfileParent();
                        }
                      : () async {
                        },
                  width: size.width * 0.6,
                  height: size.height * 0.08,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(Size size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: EdgeInsets.all(0.03 * Get.width),
          child: ImageButton(
            pathImage:
            LocalImage.backButton,
            onTap: (){
              Get.back();

            },
            width: size.width * 0.12,
            height: size.height * 0.06,
            semantics: 'back',
          ),
        ),
        ImageText(
          pathImage: LocalImage.shapeSpaceParent,
          width: 0.6 * Get.width,
          height: 0.05 * Get.height,
          text: "parent_info",
          style: TextStyle(
            color: Colors.white,
            fontSize: IMUtils.isMobile() ? Fontsize.bigger : Fontsize.larger,
            fontWeight: FontWeight.w600,
          ),
        ),
        Obx(
          () => Padding(
            padding: EdgeInsets.all(0.03 * Get.width),
            child: Semantics(
              label: controller.isEdit ? 'edit' : 'not_edit',
              child: GestureDetector(
                  onTap: () => controller.isEditBtn(),
                  child: Container(
                      width: size.width * 0.12,
                      height: size.height * 0.05,
                      decoration: const BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage(LocalImage.buttonEnter))),
                      child: Icon(
                        controller.isEdit ? Icons.edit : Icons.edit_off_sharp,
                        size: 25,
                        color: Colors.white,
                      ))),
            ),
          ),
        )
      ],
    );
  }

  void _diaLogEnterOtp() {
    Get.dialog(
      TweenAnimationBuilder(
        tween: Tween<double>(begin: 0.5, end: 1.0),
        duration: const Duration(milliseconds: 250),
        curve: Curves.fastEaseInToSlowEaseOut,
        builder: (context, double value, child) {
          return Transform.scale(
            scale: value,
            child: Opacity(
              opacity: value,
              child: child,
            ),
          );
        },
        child: Dialog(
          child: Container(
            width: Get.width * 0.8,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(7)),
            padding: const EdgeInsets.all(15),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Obx(
                  () => RegularText(
                    !controller.isConfirm
                        ? 'notification'.tr
                        : 'new_phone_number'.tr,
                    style: TextStyle(
                        fontSize: Fontsize.normal, fontWeight: FontWeight.bold),
                  ),
                ),
                Obx(
                  () => !controller.isConfirm
                      ? Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Text(
                              '${'otp_send'.tr} ${controller.phoneNumber}'),
                        )
                      : const SizedBox(),
                ),
                Obx(
                  () => controller.isConfirm
                      ? Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: Get.height * 0.03,
                              horizontal: Get.height * 0.05),
                          child: SizedBox(
                            width: Get.width / 2,
                            child: CommonWidget.textFieldWithTitle(
                              horizontal: 6,
                              vertical: 0,
                              title: 'new_phone_number'.tr,
                              validateNotify: controller.validateNewPhoneNumber,
                              child: TextFieldWidget(
                                  enabled: true,
                                  prefixIcon: const Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.phone,
                                        color: AppColor.blue,
                                        size: 22,
                                      ),
                                    ],
                                  ),
                                  onChange: (val) {
                                    controller.onChangeInput(
                                        input: val,
                                        type: ProfileInputType.newPhoneNumber);
                                  },
                                  keyboardType: TextInputType.number,
                                  controller: controller.phoneNumberController,
                                  hintText: 'new_phone_number'),
                            ),
                          ),
                        )
                      : const SizedBox(),
                ),
                Obx(
                  () => !controller.isConfirm
                      ? PinPutOtpWidget(
                          controller: controller.pinPutController.obs,
                          onCompleted: (pin) {
                            controller.isDisableButton();
                          },
                          onChanged: (val) {
                            if (val.length == 6) {
                              controller.isDisableButton();
                            } else {
                              controller.isActiveButton();
                            }
                          },
                          length: 6,
                          isDisabled: controller.isDisable,
                        )
                      : const SizedBox(),
                ),
                Obx(
                  () => !controller.isConfirm
                      ? Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: Center(
                            child: Text(
                              'not_receive_otp'.tr,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        )
                      : const SizedBox(),
                ),
                Obx(
                  () => !controller.isConfirm
                      ? Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: Center(
                              child: controller.isResend
                                  ? GestureDetector(
                                      onTap: () =>
                                          controller.resendOTP(), // Gọi hàm mới
                                      child: Text('re_send'.tr,
                                          style: const TextStyle(
                                              fontSize: 14, color: Colors.red)))
                                  : _countTime()),
                        )
                      : const SizedBox(),
                ),
                Obx(
                  () => Padding(
                    padding: EdgeInsets.only(top: Get.height * 0.02),
                    child: ImageText(
                      text: controller.isConfirm ? 'confirm' : 'next',
                      pathImage: LocalImage.shapeButton,
                      onTap: controller.isConfirm
                          ? () {
                              if (controller.validateDateNewPhone()) {
                                Get.back();
                              }
                            }
                          : () {
                              controller.setTrueIsConfirm();
                            },
                      isDisable: controller.isDisable,
                      isUpperCase: true,
                      width: Get.width * 0.3,
                      height: Get.height * 0.06,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ).then((_) {
      controller.setFalseIsConfirm();
    });
  }

  Widget _countTime() {
    return Countdown(
      controller: controller.timeController,
      seconds: 10,
      build: (BuildContext context, double time) => Text(
          '${'re_send_otp_later'.tr} (${time.toInt().toString()}s)',
          style: const TextStyle(color: Colors.red)),
      interval: const Duration(milliseconds: 100),
      onFinished: () => controller.activeIsResend(),
    );
  }
}
