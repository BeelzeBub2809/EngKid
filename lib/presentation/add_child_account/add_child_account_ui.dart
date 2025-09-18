import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:multi_select_flutter/chip_display/multi_select_chip_display.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:EngKid/presentation/add_child_account/add_child_account_controller.dart';
import 'package:EngKid/utils/app_color.dart';
import 'package:EngKid/utils/font_size.dart';
import 'package:EngKid/utils/im_utils.dart';
import 'package:EngKid/widgets/button/image_button.dart';
import 'package:EngKid/widgets/commom/commom_widget.dart';
import 'package:EngKid/widgets/text/regular_text.dart';
import 'package:sizer/sizer.dart';
import '../../utils/app_route.dart';
import '../../utils/images.dart';
import '../../utils/lib_function.dart';
import '../../widgets/input/landscape_textfield.dart';
import '../../widgets/input/text_field_widget.dart';
import '../../widgets/register/item_dropdown_address.dart';
import '../../widgets/text/image_text.dart';

class AddChildAccountScreen extends GetView<AddChildAccountController> {
  const AddChildAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (controller.router == '1') {
          Get.offAllNamed(AppRoute.login);
          return false;
        }
        return false;
      },
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              width: Get.width,
              height: Get.height,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(LocalImage.spaceBg),
                  fit: BoxFit.fill,
                ),
              ),
              child: Container(
                width: Get.width,
                margin: EdgeInsets.only(
                    top: 0.2 * Get.height,
                    left: 0.08 * Get.height,
                    right: 0.08 * Get.height,
                    bottom: 0.08 * Get.height),
                height: Get.height,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(LocalImage.shapeLogin),
                    fit: BoxFit.fill,
                  ),
                ),
                child: Obx(
                  () => Padding(
                    padding: EdgeInsets.only(
                        right: Get.height * 0.05,
                        left: Get.height * 0.05,
                        bottom: Get.height * 0.1,
                        top: controller.showShadow ? Get.height * 0.05 : 0),
                    child: RawScrollbar(
                      controller: controller.scrollController,
                      thumbVisibility: true,
                      thickness: 6,
                      thumbColor: Colors.grey,
                      radius: const Radius.circular(8),
                      padding: EdgeInsets.only(
                          left: Get.width * 0.02, top: Get.height * 0.02),
                      child: SingleChildScrollView(
                        controller: controller.scrollController,
                        child: Column(
                          children: [
                            _buildAddChildUI(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            /// back button

            Positioned(
              top: -10,
              left: 0,
              child: Padding(
                padding: EdgeInsets.all(0.03 * Get.width),
                child: ImageButton(
                  onTap: () {
                    Get.back();
                  },
                  pathImage: LocalImage.backButton,
                  semantics: 'back',
                  width: IMUtils.isMobile()
                      ? Get.width * 0.07
                      : Get.width * 0.08,
                  height: Get.height * 0.14,
                ),
              ),
            ),

            /// title
            Positioned.fill(
                top: Get.height * 0.05,
                child: Align(
                    alignment: Alignment.topCenter,
                    child: RegularText(
                      'my_dear_child'.tr,
                      style: TextStyle(
                          fontSize: Fontsize.bigger,
                          fontWeight: FontWeight.bold,
                          color: AppColor.red),
                    ))),

            /// button add

            Positioned.fill(
              bottom: Get.height * 0.02,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: ImageText(
                  text: 'add'.tr,
                  pathImage: LocalImage.shapeButton,
                  onTap: () {
                    // if(controller.numberChild) {
                    //
                    // }else{
                    //   LibFunction.toast('Bạn chỉ được tạo tối đa 3 con');
                    // }
                    controller.createChildAccount();
                  },
                  isUpperCase: true,
                  width: Get.width * 0.18,
                  height: Get.height * 0.14,
                ),
              ),
            ),
            Positioned.fill(
              right: Get.height * -0.18,
              child: Align(
                alignment: Alignment.bottomRight,
                child: Image.asset(
                  LocalImage.mascotWelcome,
                  width: Get.width * 0.28,
                  height: Get.height * 0.3,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddChildUI() {
    return Column(
      children: [
        Padding(
          padding:
              EdgeInsets.only(top: Get.height * 0.05, right: Get.height * 0.05),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              RegularText(
                'child_name_add'.tr,
                style: TextStyle(
                  fontSize: Fontsize.normal,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              Obx(
                () => SizedBox(
                  width: 0.32 * Get.width,
                  child: LandScapeTextField(
                    maxLength: 30,
                    input: controller.childNameRx,
                    keyboardType: TextInputType.text,
                    backgroundColor: Colors.transparent,
                    placeHolder: 'child_name_add'.tr,
                    borderColor: Colors.black38,
                    textAlign: Alignment.bottomLeft,
                    textStyle: TextStyle(
                      fontSize: Fontsize.larger,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                    onChange: (text) => controller.onChangeInput(
                      input: text,
                      type: AddChildInputType.childName,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Obx(
          () => Padding(
            padding: EdgeInsets.only(
                top: controller.validateChildName.isNotEmpty ? 10 : 0,
                right: controller.validateChildName.isNotEmpty ? 25 : 0),
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                controller.validateChildName.tr,
                style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Colors.red),
              ),
            ),
          ),
        ),
        Padding(
          padding:
              EdgeInsets.only(top: Get.height * 0.05, right: Get.height * 0.05),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              RegularText(
                'date_of_birth'.tr,
                style: TextStyle(
                  fontSize: Fontsize.normal,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Obx(
                    () => SizedBox(
                      width: 0.275 * Get.width,
                      child: LandScapeTextField(
                        maxLength: 30,
                        isDisable: true,
                        input: controller.dateOfBirthRx,
                        keyboardType: TextInputType.text,
                        backgroundColor: Colors.transparent,
                        borderColor: Colors.black38,
                        textAlign: Alignment.bottomLeft,
                        placeHolder: 'choose_date_of_birth'.tr,
                        textStyle: TextStyle(
                          fontSize: Fontsize.larger,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                        onChange: (text) => controller.onChangeInput(
                          input: text,
                          type: AddChildInputType.dateOfBirth,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: Get.height * 0.03),
                  GestureDetector(
                    onTap: () {
                      showDialog(
                        context: Get.context!,
                        builder: (context) {
                          return Dialog(
                            insetPadding: const EdgeInsets.all(20),
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.9,
                              height: MediaQuery.of(context).size.height * 0.7,
                              padding: const EdgeInsets.all(14),
                              child: CalendarDatePicker2(
                                config: CalendarDatePicker2Config(
                                  calendarType: CalendarDatePicker2Type.single,
                                  calendarViewMode: CalendarDatePicker2Mode.day,
                                  weekdayLabels: [
                                    'sunday'.tr,
                                    'monday'.tr,
                                    'tuesday'.tr,
                                    'wednesday'.tr,
                                    'thursday'.tr,
                                    'friday'.tr,
                                    'saturday'.tr
                                  ],
                                  weekdayLabelTextStyle:
                                      const TextStyle(fontSize: 14),
                                  dayTextStyle: const TextStyle(fontSize: 14),
                                ),
                                value: [
                                  controller.selectedDate ?? DateTime.now()
                                ],
                                onValueChanged: (dates) {
                                  if (dates.isNotEmpty) {
                                    controller.selectedDate = dates.first;
                                    controller.dateOfBirthRx =
                                        DateFormat('dd/MM/yyyy')
                                            .format(dates.first);
                                    Navigator.pop(context);
                                  }
                                },
                              ),
                            ),
                          );
                        },
                      );
                    },
                    child: const Icon(Icons.calendar_month, size: 30),
                  )
                ],
              ),
            ],
          ),
        ),
        Obx(
          () => Padding(
            padding: EdgeInsets.only(
                top: controller.validateDateOfBirth.isNotEmpty ? 10 : 0,
                right: controller.validateDateOfBirth.isNotEmpty ? 25 : 0),
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                controller.validateDateOfBirth.tr,
                style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Colors.red),
              ),
            ),
          ),
        ),

        Padding(
          padding: const EdgeInsets.only(top: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RegularText(
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
                  ...[
                    "male",
                    "female",
                    "other"
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
                            width: Get.width * 0.01,
                          ),
                          Obx(
                            () => GestureDetector(
                              onTap: () {
                                controller.selectSex(sex);
                              },
                              child: Image.asset(
                                controller.sexRx == sex
                                    ? LocalImage.checkboxChecked
                                    : LocalImage.checkboxUnChecked,
                                width: 24,
                                height: 24,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: Get.width * 0.03,
                          ),
                        ],
                      ))
                ],
              )
            ],
          ),
        ),
        Obx(
          () => Padding(
            padding: EdgeInsets.only(
                top: controller.validateSex.isNotEmpty ? 10 : 0,
                right: controller.validateSex.isNotEmpty ? 15 : 0),
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                controller.validateSex.tr,
                style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Colors.red),
              ),
            ),
          ),
        ),
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //   children: [
        //     Padding(
        //       padding: EdgeInsets.only(
        //           right: !IMUtils.isMobile()
        //               ? 0.04 * Get.height
        //               : 0.05 * Get.height),
        //       child: Obx(
        //         () => ItemDropdownAddress(
        //           title: "grade_add",
        //           validateValue: controller.validateGrade,
        //           isAddChild: true,
        //           items: controller.gradeList
        //               .map((org) => {
        //                     'id': org.id,
        //                     'name': org.group,
        //                   })
        //               .toList(),
        //           selectedItem: controller.selectedGrade,
        //           onChanged: (value) {
        //             if (value != null) {
        //               controller.updateSelectedGrade(value);
        //             }
        //           },
        //           width: Get.height / 2.3,
        //         ),
        //       ),
        //     ),
        //   ],
        // ),
      ],
    );
  }
}
