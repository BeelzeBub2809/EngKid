import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:EngKid/utils/app_color.dart';
import 'package:EngKid/utils/font_size.dart';
import 'package:EngKid/utils/images.dart';
import 'package:EngKid/widgets/text/image_text.dart';
import 'package:EngKid/widgets/text/regular_text.dart';

import 'declare_parent_code_controller.dart';

class DeclareParentCodeScreen extends GetView<DeclareParentCodeController> {
  const DeclareParentCodeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        width: size.width,
        height: size.height,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(LocalImage.declareParentCodeBg),
            fit: BoxFit.fill,
          ),
        ),
        child: Center(
          child: Stack(
            children: [
              Container(
                width: 0.95 * size.width,
                height: 0.85 * size.height,
                padding: EdgeInsets.symmetric(horizontal: 0.02 * size.width),
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(LocalImage.shapePin),
                    fit: BoxFit.fill,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        RegularText(
                          'parent_setup',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: AppColor.red,
                            fontSize: Fontsize.large,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 0.02 * size.height),
                          child: SizedBox(
                            width: 0.4 * size.width,
                            child: Obx(
                              () => Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(
                                  controller.initialParentCode.length,
                                  (index) => Container(
                                    width: 0.06 * size.width,
                                    height: 0.06 * size.width,
                                    margin: const EdgeInsets.symmetric(
                                      horizontal: 3,
                                    ),
                                    decoration: BoxDecoration(
                                      image: const DecorationImage(
                                        image: AssetImage(
                                          LocalImage.inputPin,
                                        ),
                                        fit: BoxFit.fill,
                                      ),
                                      borderRadius: BorderRadius.circular(
                                          0.02 * size.height),
                                      boxShadow: controller.fillIndex == index
                                          ? [
                                              BoxShadow(
                                                color: Colors.black
                                                    .withOpacity(0.5),
                                                spreadRadius: 1,
                                                blurRadius: 5,
                                                offset: const Offset(0,
                                                    0), // changes position of shadow
                                              ),
                                            ]
                                          : null,
                                    ),
                                    child: Center(
                                      child: RegularText(
                                        controller.initialParentCode[index],
                                        style: TextStyle(
                                          fontSize: Fontsize.huge,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 0.03 * size.height,
                        ),
                        RegularText(
                          're_parent_setup',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: AppColor.red,
                            fontSize: Fontsize.large,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 0.02 * size.height),
                          child: SizedBox(
                            width: 0.4 * size.width,
                            child: Obx(
                              () => Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(
                                  controller.initialReParentCode.length,
                                  (index) => Container(
                                    width: 0.06 * size.width,
                                    height: 0.06 * size.width,
                                    margin: const EdgeInsets.symmetric(
                                      horizontal: 3,
                                    ),
                                    decoration: BoxDecoration(
                                      image: const DecorationImage(
                                        image: AssetImage(
                                          LocalImage.inputPin,
                                        ),
                                        fit: BoxFit.fill,
                                      ),
                                      borderRadius: BorderRadius.circular(
                                          0.02 * size.height),
                                      boxShadow:
                                          controller.fillIndex - 4 == index
                                              ? [
                                                  BoxShadow(
                                                    color: Colors.black
                                                        .withOpacity(0.5),
                                                    spreadRadius: 1,
                                                    blurRadius: 5,
                                                    offset: const Offset(0,
                                                        0), // changes position of shadow
                                                  ),
                                                ]
                                              : null,
                                    ),
                                    child: Center(
                                      child: RegularText(
                                        controller.initialReParentCode[index],
                                        style: TextStyle(
                                          fontSize: Fontsize.huge,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 0.03 * size.height,
                        ),
                        Obx(
                          () => controller.fillIndex == 7 &&
                                  controller.initialReParentCode[3] != ""
                              ? ImageText(
                                  text: 'confirm',
                                  pathImage: LocalImage.shapeButton,
                                  isUpperCase: true,
                                  onTap: () {
                                    controller.onConfirm();
                                  },
                                  height: size.height * 0.12,
                                  width: size.width * 0.16,
                                )
                              : const SizedBox(),
                        ),
                        SizedBox(
                          height: size.height * 0.03,
                        ),

                            Obx(
                              () => controller.fillIndex == 7 &&
                                      controller.initialReParentCode[3] != ""
                                  ? Row(
                                    children: [
                                      GestureDetector(
                                          onTap: () {
                                            controller.onPressSaveParentCode();
                                          },
                                          child: Image.asset(
                                            controller.saveParentCode
                                                ? LocalImage.checkboxChecked
                                                : LocalImage.checkboxUnChecked,
                                            width: 24,
                                            height: 24,
                                          ),
                                        ),
                                      SizedBox(
                                        width: size.height * 0.02,
                                      ),
                                      RegularText(
                                        'save_safety_code'.tr,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: AppColor.red,
                                          fontSize: Fontsize.normal,
                                        ),
                                      )
                                    ],
                                  )
                                  : const SizedBox(),
                            ),
                      ],
                    ),
                    SizedBox(
                      width: size.width * 0.25,
                      height: 0.06 * size.width * 4 + 0.03 * size.height * 6,
                      child: Center(
                        child: GridView.builder(
                          itemCount: controller.buttons.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            mainAxisSpacing: 0.02 * size.height,
                            crossAxisSpacing: 0.02 * size.height,
                            childAspectRatio: 1.1,
                          ),
                          itemBuilder: (context, index) => ImageText(
                            pathImage: controller.buttons[index],
                            onTap: () {
                              switch (index) {
                                case 0:
                                case 1:
                                case 2:
                                case 3:
                                case 4:
                                case 5:
                                case 6:
                                case 7:
                                case 8:
                                case 10:
                                  controller.onPressPin(
                                      number: (index > 9 ? 0 : index + 1)
                                          .toString(),
                                      type: "summation");
                                  break;
                                case 9:
                                  controller.onPressPin(
                                      number: '', type: "subtraction");
                                  break;
                                case 11:
                                  controller.onPressPin(
                                      number: '', type: "enter");
                                  break;
                              }
                            },
                            width: 0.06 * size.width,
                            height: 0.06 * size.width,
                            text: index == 11 ? 'enter' : '',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
