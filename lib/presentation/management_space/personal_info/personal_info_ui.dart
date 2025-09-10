import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:EngKid/presentation/core/user_service.dart';
import 'package:EngKid/utils/app_color.dart';
import 'package:EngKid/utils/app_route.dart';
import 'package:EngKid/utils/font_size.dart';
import 'package:EngKid/utils/images.dart';
import 'package:EngKid/utils/lib_function.dart';
import 'package:EngKid/widgets/image/cache_image.dart';
import 'package:EngKid/widgets/input/landscape_textfield.dart';
import 'package:EngKid/widgets/loading/loading_dialog.dart';
import 'package:EngKid/widgets/text/image_text.dart';
import 'package:EngKid/widgets/text/regular_text.dart';

import '../../../utils/im_utils.dart';
import 'personal_info_controller.dart';

class PersonalInfoScreen extends GetView<PersonalInfoController> {
  const PersonalInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final UserService userService = Get.find<UserService>();
    print('with : ${size.width}');

    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: double.infinity,
          padding: EdgeInsets.only(
            left: 0.11 * size.height,
            right: 0.11 * size.height,
            top: 0.08 * size.height,
            bottom: 0.08 * size.height,
          ),
          margin: EdgeInsets.only(bottom: 0.02 * size.height),
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(LocalImage.shapePersonalInfo),
              fit: BoxFit.fill,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                flex: 4,
                child: Container(
                  padding: EdgeInsets.only(
                    left: 0.03 * size.height,
                    right: IMUtils.isMobile() ? 0.03 * size.height : 0.02 * size.height,
                    top: 0.01 * size.height,
                  ),
                  decoration: BoxDecoration(
                    color: AppColor.lightYellow,
                    borderRadius: BorderRadius.all(
                      Radius.circular(0.04 * size.height),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Row(
                          mainAxisAlignment: IMUtils.isMobile() ? MainAxisAlignment.center : MainAxisAlignment.spaceBetween,
                          children: [
                            RegularText(
                              'parent_info',
                              isUpperCase: true,
                              maxLines: 1,
                              style: TextStyle(
                                color: AppColor.red,
                                fontSize: IMUtils.isMobile() ? Fontsize.larger : Fontsize.small,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            if(IMUtils.isMobile())
                              SizedBox(width: Get.height * 0.03,),
                            GestureDetector(
                                onTap: (){
                                   Get.toNamed(AppRoute.profileParent);
                                },
                                  child: Image.asset(LocalImage.icEdit, width: 20, height: 20,)),

                          ],
                        ),
                      ),
                      SizedBox(height: 0.01 * size.height),
                      Obx(
                          () => Center(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(0.06 * size.height),
                            child: CacheImage(
                              url: controller.imageUrlParent,
                              width: 0.11 * size.height,
                              height: 0.11 * size.height,
                            ),
                          ),
                        ),
                      ),
                      // SizedBox(height: 0.03 * size.height),
                      const RegularText(
                        'parent_name',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          color: AppColor.gray,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 0.01 * size.height),
                      Obx(
                        () => LandScapeTextField(
                          maxLength: 30,
                          isDisable: true,
                          input: controller.parentName,
                          placeHolder: 'name_parents',
                          keyboardType: TextInputType.text,
                          onChange: (text) {
                            controller.onChangeInput(
                              input: text,
                              type: PersonalInfoInputType.name,
                            );
                          },
                          padding: EdgeInsets.only(left: 0.01 * size.width),
                          backgroundColor: const Color(0XFFe6e6e6),
                          borderRadius: 0.03 * size.height,
                        ),
                      ),
                      SizedBox(height: 0.03 * size.height),
                      const RegularText(
                        'parent_phone',
                        style: TextStyle(
                          color: AppColor.gray,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 0.01 * size.height),
                      Obx(
                        () => LandScapeTextField(
                          maxLength: 10,
                          input: controller.parentPhone,
                          keyboardType: TextInputType.phone,
                          isDisable: true,
                          placeHolder: 'parent_phone',
                          onChange: (text) {
                            controller.onChangeInput(
                              input: text,
                              type: PersonalInfoInputType.phone,
                            );
                          },
                          padding: EdgeInsets.only(left: 0.01 * size.width),
                          backgroundColor: const Color(0XFFe6e6e6),
                          borderRadius: 0.03 * size.height,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(width: 0.01 * size.width),
              Expanded(
                flex: 6,
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  padding: EdgeInsets.only(
                    left: 0.03 * size.height,
                    right: 0.03 * size.height,
                    top: 0.01 * size.height,
                  ),
                  decoration: BoxDecoration(
                    color: AppColor.lightBlue,
                    borderRadius: BorderRadius.all(
                      Radius.circular(0.04 * size.height),
                    ),
                  ),
                  child: RawScrollbar(
                    thumbColor: AppColor.blue,
                    trackColor: Colors.transparent,
                    radius: Radius.circular(0.008 * 2 * size.width),
                    thumbVisibility: true,
                    thickness: 0.008 * size.width,
                    interactive: true,
                    padding: EdgeInsets.only(
                      top: 0.03 * size.height,
                      bottom: 0.01 * size.height,
                      right: 0 * size.width,
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                RegularText(
                                  'child_info',
                                  isUpperCase: true,
                                  maxLines: 1,
                                  style: TextStyle(
                                    color: AppColor.red,
                                    fontSize: IMUtils.isMobile() ? Fontsize.larger : Fontsize.small,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                SizedBox(width: 0.03 * size.height),
                                GestureDetector(
                                    onTap: (){
                                      Get.toNamed(AppRoute.profileChild);

                                    },
                                    child: Image.asset(LocalImage.icEdit, width: 20, height: 20,))
                              ],
                            ),
                          ),
                          SizedBox(height: 0.01 * size.height),
                          SizedBox(
                            width: 3.1 * LibFunction.scaleForCurrentValue(size, 125),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: List.generate(
                                  userService.childProfiles.childProfiles.length,
                                      (index) => Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: LibFunction.scaleForCurrentValue(size, 5),
                                    ),
                                    child: GestureDetector(
                                      onTap: () {
                                        controller.onChangeChild(
                                            userService.childProfiles.childProfiles[index].id,
                                            index
                                        );
                                      },
                                      child: Obx(
                                            () => Container(
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: index == controller.indexChild.value
                                                  ? AppColor.blue
                                                  : Colors.transparent,
                                              width: 1,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              LibFunction.scaleForCurrentValue(size, 115),
                                            ),
                                          ),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              LibFunction.scaleForCurrentValue(size, 115),
                                            ),
                                            child: controller.pathAvatar.value != "" &&
                                                index == controller.indexChild.value
                                                ? Image.file(
                                              controller.fileAvatar!,
                                              width: LibFunction.scaleForCurrentValue(size, 115),
                                              height: LibFunction.scaleForCurrentValue(size, 115),
                                              fit: BoxFit.fill,
                                            )
                                                : CacheImage(
                                              url: userService
                                                  .childProfiles.childProfiles[index].avatar,
                                              width: LibFunction.scaleForCurrentValue(size, 115),
                                              height: LibFunction.scaleForCurrentValue(size, 115),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),

                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.center,
                          //   children: [
                          //     Obx(
                          //       () => controller.pathAvatar.value != ""
                          //           ? Padding(
                          //               padding:
                          //                   const EdgeInsets.only(right: 3.0),
                          //               child: GestureDetector(
                          //                 onTap: () {
                          //                   controller.cancelUpload();
                          //                 },
                          //                 child: Container(
                          //                   margin: EdgeInsets.symmetric(
                          //                     vertical: 0.01 * size.height,
                          //                   ),
                          //                   decoration: BoxDecoration(
                          //                     color: AppColor.gray,
                          //                     borderRadius: BorderRadius.all(
                          //                       Radius.circular(
                          //                           0.06 * size.height),
                          //                     ),
                          //                   ),
                          //                   padding: EdgeInsets.only(
                          //                     left: 0.01 * size.width,
                          //                     right: 0.01 * size.width,
                          //                     top: 0.005 * size.width,
                          //                     bottom: 0.005 * size.width,
                          //                   ),
                          //                   child: RegularText(
                          //                     'cancel',
                          //                     style: TextStyle(
                          //                       color: Colors.white,
                          //                       fontWeight: FontWeight.w600,
                          //                       fontSize: Fontsize.smallest,
                          //                     ),
                          //                   ),
                          //                 ),
                          //               ),
                          //             )
                          //           : const SizedBox(),
                          //     ),
                          //     GestureDetector(
                          //       onTap: () {
                          //         if (controller.pathAvatar.value != "") {
                          //           controller.onUploadChildAvatar();
                          //         } else {
                          //           controller.toogleImagePicker();
                          //         }
                          //       },
                          //       child: Obx(
                          //         () => Container(
                          //           margin: EdgeInsets.symmetric(
                          //             vertical: 0.01 * size.height,
                          //           ),
                          //           decoration: BoxDecoration(
                          //             color: controller.pathAvatar.value != ""
                          //                 ? AppColor.red
                          //                 : AppColor.blue,
                          //             borderRadius: BorderRadius.all(
                          //               Radius.circular(0.06 * size.height),
                          //             ),
                          //           ),
                          //           padding: EdgeInsets.only(
                          //             left: 0.01 * size.width,
                          //             right: 0.01 * size.width,
                          //             top: 0.005 * size.width,
                          //             bottom: 0.005 * size.width,
                          //           ),
                          //           child: RegularText(
                          //             controller.pathAvatar.value != ""
                          //                 ? 'confirm'
                          //                 : 'upload_avatar',
                          //             style: TextStyle(
                          //               color: Colors.white,
                          //               fontWeight: FontWeight.w600,
                          //               fontSize: Fontsize.smallest,
                          //             ),
                          //           ),
                          //         ),
                          //       ),
                          //     ),
                          //   ],
                          // ),
                          const SizedBox(height: 10),
                          Obx(
                            () => Column(
                              children: [
                                LabelValueInfo(
                                    label: 'child_name',
                                    value: userService
                                        .childProfiles
                                        .childProfiles[controller.indexChild.value]
                                        .name),
                                LabelValueInfo(
                                  label: 'Giới tính:',
                                  value: userService
                                      .childProfiles
                                      .childProfiles[controller.indexChild.value]
                                      .gender,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    RegularText(
                                      'grade',
                                      data: const {'grade': ': '},
                                      style: TextStyle(
                                        color: AppColor.gray,
                                        fontWeight: FontWeight.w600,
                                        fontSize: Fontsize.normal - 1,
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        width: double.infinity,
                                        decoration: const BoxDecoration(
                                          border: Border(
                                            bottom: BorderSide(
                                              color: Color.fromARGB(
                                                  255, 217, 217, 217),
                                              width: 0.8,
                                            ),
                                          ),
                                        ),
                                        child: RegularText(
                                          userService
                                              .childProfiles
                                              .childProfiles[controller.indexChild.value]
                                              .gradeId.toString(),
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                            color: AppColor.blue,
                                            fontWeight: FontWeight.w600,
                                            fontSize: Fontsize.normal - 1,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Obx(
          () => controller.isChanged.value
              ? Positioned.fill(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: ImageText(
                      text: 'confirm',
                      style: TextStyle(fontSize: Fontsize.small),
                      pathImage: LocalImage.shapeButton,
                      isUpperCase: true,
                      onTap: controller.onConfirm,
                      width: 0.16 * size.width,
                      height: 0.1 * size.height,
                    ),
                  ),
                )
              : const SizedBox(),
        ),
        Obx(() => controller.isLoading.value
            ? Container(
                decoration: BoxDecoration(
                  color: Colors.black26,
                  borderRadius: BorderRadius.all(
                    Radius.circular(0.08 * size.height),
                  ),
                ),
                padding: EdgeInsets.symmetric(vertical: 0.05 * size.height),
                child: const LoadingDialog(),
              )
            : const SizedBox()),
      ],
    );
  }
}

class LabelValueInfo extends StatelessWidget {
  const LabelValueInfo({
    super.key,
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        RegularText(
          label,
          data: const {'string': ' : '},
          style: TextStyle(
            color: AppColor.gray,
            fontWeight: FontWeight.w600,
            fontSize: Fontsize.normal - 1,
          ),
        ),
        Expanded(
          child: Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Color.fromARGB(255, 217, 217, 217),
                  width: 0.8,
                ),
              ),
            ),
            child: RegularText(
              value,
              textAlign: TextAlign.start,
              style: TextStyle(
                color: AppColor.blue,
                fontWeight: FontWeight.w600,
                fontSize: Fontsize.normal - 1,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
