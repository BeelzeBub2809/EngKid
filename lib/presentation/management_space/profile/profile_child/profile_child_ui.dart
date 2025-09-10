import 'dart:io';

import 'package:EngKid/presentation/core/user_service.dart';
import 'package:EngKid/presentation/management_space/profile/profile_child/profile_child_controlller.dart';
import 'package:EngKid/utils/app_color.dart';
import 'package:EngKid/utils/font_size.dart';
import 'package:EngKid/utils/images.dart';
import 'package:EngKid/utils/lib_function.dart';
import 'package:EngKid/widgets/commom/commom_widget.dart';
import 'package:EngKid/widgets/dialog/dialog_alert.dart';
import 'package:EngKid/widgets/image/cache_image.dart';
import 'package:EngKid/widgets/input/text_field_widget.dart';
import 'package:EngKid/widgets/register/item_dropdown_have_title.dart';
import 'package:EngKid/widgets/text/image_text.dart';
import 'package:EngKid/widgets/text/regular_text.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:multi_select_flutter/chip_display/multi_select_chip_display.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:EngKid/widgets/button/image_button.dart';

import '../../../../utils/im_utils.dart';

class ProfileChildScreen extends GetView<ProfileChildController> {
  const ProfileChildScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    final UserService userService = Get.find<UserService>();

    return Scaffold(
      floatingActionButton: Obx(
        () => Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: EdgeInsets.only(left: 0.06 * size.width),
            child: ImageText(
              text:
                  'update_profile'.tr,
              pathImage: LocalImage.shapeButton,
              isUpperCase: true,
              onTap: controller.isEdit
                  ? () async {
                      await controller.updateProfileChild();
                    }
                  : () async {
                    },
              width: size.width * 0.6,
              height: size.height * 0.07,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          width: size.width,
          height: size.height,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                LocalImage.quizBg,
              ),
              fit: BoxFit.fill,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: size.width * 0.03),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildHeader(size, context),
                  Row(
                    children: [
                      SizedBox(
                        width: size.width * 0.08,
                        height: size.width * 0.13,
                      ),
                      SizedBox(
                        width: size.width * 0.05,
                      ),
                      Expanded(
                        child: SizedBox(
                          height: LibFunction.scaleForCurrentValue(size, 500),
                          // --- BỌC WIDGET BÊN TRONG BẰNG Obx ---
                          child: Obx(() {
                            // Lấy danh sách children từ service.
                            // `Obx` sẽ theo dõi `userService.childProfiles` và rebuild khi nó thay đổi.
                            final childrenList = userService.childProfiles.childProfiles;

                            // Trả về PageView.builder với dữ liệu mới nhất
                            return PageView.builder(
                              controller: controller.pageController,
                              // Dùng `childrenList` đã lấy ở trên
                              itemCount: childrenList.length,
                              onPageChanged: (index) {
                                // Bây giờ hàm này sẽ được gọi khi bạn vuốt
                                controller.onChangeChild(childrenList[index], index);
                              },
                              itemBuilder: (context, index) {
                                return AnimatedBuilder(
                                  animation: controller.pageController,
                                  builder: (context, child) {
                                    double value = 1.0;
                                    if (controller.pageController.position.haveDimensions) {
                                      value = controller.pageController.page! - index;
                                      value = (1 - (value.abs() * 0.3)).clamp(0.7, 1.0);
                                    }
                                    return Center(
                                      child: Transform.scale(
                                        scale: value,
                                        child: Container(
                                          margin: const EdgeInsets.symmetric(horizontal: 5),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              // Vẫn dùng controller.indexChild để check border
                                              color: index == controller.indexChild.value
                                                  ? AppColor.red
                                                  : Colors.transparent,
                                              width: 1,
                                            ),
                                            shape: BoxShape.circle,
                                          ),
                                          child: Stack(
                                            clipBehavior: Clip.none,
                                            children: [
                                              // Obx(() {
                                              //   // Lấy path avatar từ controller hoặc từ `childrenList`
                                              //   final path = controller.pathAvatars[index] ??
                                              //       childrenList[index].avatar;
                                              //   return ClipOval(
                                              //     child: CacheImage(
                                              //       url: path,
                                              //       width: LibFunction.scaleForCurrentValue(
                                              //           size,
                                              //           index == controller.indexChild.value
                                              //               ? 450
                                              //               : 400),
                                              //       height: LibFunction.scaleForCurrentValue(
                                              //           size,
                                              //           index == controller.indexChild.value
                                              //               ? 450
                                              //               : 400),
                                              //     ),
                                              //   );
                                              // }),
                                              Obx(
                                                    () => ClipOval(
                                                  child: controller.imagePath.isNotEmpty && index == controller.indexChild.value
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
                                                      url: controller.pathAvatars[index] ?? childrenList[index].avatar,
                                                      width: 0.11 * size.height,
                                                      height: 0.11 * size.height,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Obx(
                                                    () => index == controller.indexChild.value &&
                                                    controller.isEdit // Dùng .value cho biến RxBool
                                                    ? Positioned(
                                                  bottom: -10,
                                                  right: 0,
                                                  left: 0,
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
                                                      child: const Icon(Icons.camera_alt,
                                                          size: 20)),
                                                )
                                                    : const SizedBox(),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                            );
                          }),
                        ),
                      ),
                      SizedBox(
                        width: size.width * 0.05,
                      ),
                      SizedBox(
                        width: size.width * 0.08,
                        height: size.width * 0.13,
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: Get.height * 0.02),
                    child: Obx(
                      () => SizedBox(
                        width: Get.width,
                        child: CommonWidget.textFieldWithTitle(
                            validateNotify: controller.validateChildName,
                            horizontal: 6,
                            vertical: 0,
                            title: 'child_name_add'.tr,
                            child: Obx(
                              () => TextFieldWidget(
                                  enabled: controller.isEdit ? true : false,
                                  prefixIcon: const Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.person,
                                        color: AppColor.red,
                                        size: 22,
                                      ),
                                    ],
                                  ),
                                  onChange: (val) {
                                    controller.onChangeInput(
                                        input: val,
                                        type: ProfileChildInputType.childName);
                                  },
                                  controller: controller.childNameController,
                                  hintText: ''),
                            )),
                      ),
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
                                  type: ProfileChildInputType.dateOfBirth);
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
                                      type: ProfileChildInputType.dateOfBirth);
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Obx(
                            () => ItemDropdownHaveTitle(
                              title: 'grade_add',
                              isEdit: controller.isEdit,
                              items: controller.gradeList
                                  .map((org) => {
                                        'id': org.id,
                                        'name': org.name,
                                      })
                                  .toList(),
                              selectedItem: controller.selectedGrade,
                              onChanged: (value) {
                                if (value != null) {
                                  controller.updateSelectedGrade(value);
                                }
                              },
                              width: Get.width / 2.25,
                            ),
                          ),
                          Obx(() => controller.validateGrade.isNotEmpty
                              ? Padding(
                                  padding: const EdgeInsets.only(top: 5),
                                  child: RegularText(controller.validateGrade,
                                      style: const TextStyle(
                                          fontSize: 12, color: AppColor.red)),
                                )
                              : const SizedBox())
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _buildShortTitle(List<Map<String, dynamic>> list) {
    String result = list.map((e) => e['title']).join(', ');
    if (result.length > 30) {
      return '${result.substring(0, 30)}...';
    }
    return result;
  }

  Widget _buildHeader(Size size, BuildContext context) {
    EdgeInsets safePadding = MediaQuery.of(context).padding;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: safePadding.top),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ImageButton(
            pathImage: LocalImage.backButton,
            onTap: () {
              Get.back();
            },
            width: size.width * 0.13,
            height: size.height * 0.07,
            semantics: 'back',
          ),
          ImageText(
            pathImage: LocalImage.shapeSpaceStudent,
            width: 0.6 * Get.width,
            height: 0.05 * Get.height,
            text: "child_info",
            style: TextStyle(
              color: Colors.white,
              fontSize: IMUtils.isMobile() ? Fontsize.bigger : Fontsize.larger,
              fontWeight: FontWeight.w600,
            ),
          ),
          Obx(
            () => Semantics(
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
        ],
      ),
    );
  }

  void _diaLogChangeAvt(Size size) {
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
        child: StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              backgroundColor: Colors.transparent, // 👈 Quan trọng!

              child: Container(
                width: Get.width * 0.8,
                height: Get.height * 0.4,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    image: const DecorationImage(
                      image: AssetImage(LocalImage.safetyGuideBg),
                      fit: BoxFit.fill,
                    )),
                padding: const EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ImageText(
                      pathImage: LocalImage.shapeSpaceStudent,
                      width: 0.6 * Get.width,
                      height: 0.05 * Get.height,
                      text: "Chọn ảnh đại diện",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: Fontsize.larger,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Obx(
                      () => SizedBox(
                        height: size.height * 0.2,
                        width: size.width,
                        child: ListView.builder(
                          itemCount: controller.listImageAvt.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            final imageUrl = controller.listImageAvt[index];
                            return Center(
                              child: GestureDetector(
                                onTap: () {
                                  controller.onChangeIndexAvt(index);
                                  setState(() {});
                                },
                                child: Container(
                                  width: 70,
                                  height: 70,
                                  margin: const EdgeInsets.only(right: 20),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(35),
                                    border: Border.all(
                                      color: index == controller.indexAvt.value
                                          ? AppColor.red
                                          : AppColor.gray,
                                      width: 2,
                                    ),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(35),
                                    child: Image.network(
                                      imageUrl,
                                      width: 70,
                                      height: 70,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: ImageText(
                        onTap: () {
                          controller.onChangeAvt(
                              controller.indexChild.value,
                              controller
                                  .listImageAvt[controller.indexAvt.value]);
                        },
                        pathImage: LocalImage.shapeButton,
                        width: 0.3 * Get.width,
                        height: 0.05 * Get.height,
                        text: "Chọn",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: Fontsize.larger,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
