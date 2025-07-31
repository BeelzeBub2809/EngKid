import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:EngKid/utils/app_color.dart';
import 'package:EngKid/utils/font_size.dart';
import 'package:EngKid/utils/images.dart';
import 'package:EngKid/widgets/button/image_button.dart';
import 'package:EngKid/widgets/text/image_text.dart';
import 'package:EngKid/widgets/text/regular_text.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

import 'setting_controller.dart';

class SettingScreen extends GetView<SettingController> {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Container(
      width: double.infinity,
      height: 0.8 * size.height,
      padding: EdgeInsets.only(
        left: 0.11 * size.height,
        right: 0.11 * size.height,
        top: 0.08 * size.height,
        bottom: 0.08 * size.height,
      ),
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(LocalImage.shapePersonalInfo),
          fit: BoxFit.fill,
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              height: 0.5 * size.height,
              child: Row(
                children: [
                  LeftSetting(size: size, controller: controller),
                  SizedBox(width: 0.02 * size.width),
                  RightSetting(size: size, controller: controller),
                ],
              ),
            ),
            ImageText(
              text: 'confirm',
              pathImage: LocalImage.shapeButton,
              isUpperCase: true,
              style: TextStyle(fontSize: Fontsize.smallest),
              onTap: controller.onConfirm,
              width: 0.11 * size.width,
              height: 0.08 * size.height,
            )
          ],
        ),
      ),
    );
  }
}

class RightSetting extends StatelessWidget {
  const RightSetting({
    super.key,
    required this.size,
    required this.controller,
  });

  final Size size;
  final SettingController controller;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 3,
      child: Container(
        width: double.infinity,
        height: double.infinity,
        padding: EdgeInsets.only(
          left: 0.03 * size.height,
          right: 0.03 * size.height,
          top: 0.01 * size.height,
        ),
        decoration: BoxDecoration(
          color: AppColor.lightYellow,
          borderRadius: BorderRadius.all(
            Radius.circular(0.04 * size.height),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: RegularText(
                'safety_code',
                maxLines: 1,
                style: TextStyle(
                  color: AppColor.red,
                  fontSize: Fontsize.larger,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            SizedBox(
              height: 0.02 * size.height,
            ),
            Center(
              child: SizedBox(
                width: 0.15 * size.width,
                child: RegularText(
                  'old_safety_code',
                  maxLines: 1,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    color: AppColor.gray,
                    fontWeight: FontWeight.w600,
                    fontSize: Fontsize.smaller,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 0.01 * size.height,
            ),
            Center(
              child: SizedBox(
                height: 0.035 * size.width,
                width: 0.15 * size.width,
                child: PinCodeTextField(
                  appContext: context,
                  length: 4,
                  cursorColor: Colors.black45,
                  onChanged: (text) => controller.parentCodeInput = text,
                  enablePinAutofill: false,
                  keyboardType: TextInputType.number,
                  enableActiveFill: true,
                  animationType: AnimationType.none,
                  autoFocus: false,
                  textStyle: TextStyle(
                    fontFamily: 'Lato',
                    fontSize: Fontsize.small,
                    fontWeight: FontWeight.bold,
                  ),
                  boxShadows: const [
                    BoxShadow(
                      offset: Offset(1.5, 1.5),
                      color: Colors.black26,
                      blurRadius: 2,
                    )
                  ],
                  pinTheme: PinTheme(
                    shape: PinCodeFieldShape.box,
                    borderRadius: BorderRadius.circular(3),
                    fieldHeight: 0.03 * size.width,
                    fieldWidth: 0.03 * size.width,
                    selectedFillColor: const Color(0xFFe3e1e4),
                    selectedColor: const Color(0xFFe3e1e4),
                    activeColor: const Color(0xFFe3e1e4),
                    activeFillColor: const Color(0xFFe3e1e4),
                    inactiveColor: const Color(0xFFe3e1e4),
                    inactiveFillColor: const Color(0xFFe3e1e4),
                  ),
                ),
              ),
            ),
            Center(
              child: SizedBox(
                width: 0.15 * size.width,
                child: RegularText(
                  'new_safety_code',
                  maxLines: 1,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    color: AppColor.gray,
                    fontWeight: FontWeight.w600,
                    fontSize: Fontsize.smaller,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 0.01 * size.height,
            ),
            Center(
              child: SizedBox(
                height: 0.035 * size.width,
                width: 0.15 * size.width,
                child: PinCodeTextField(
                  appContext: context,
                  length: 4,
                  onChanged: (text) => controller.newParentCodeInput = text,
                  enablePinAutofill: false,
                  keyboardType: TextInputType.number,
                  enableActiveFill: true,
                  animationType: AnimationType.none,
                  // autoFocus: true,
                  textStyle: TextStyle(
                    fontFamily: 'Lato',
                    fontSize: Fontsize.normal,
                    fontWeight: FontWeight.bold,
                  ),
                  boxShadows: const [
                    BoxShadow(
                      offset: Offset(1.5, 1.5),
                      color: Colors.black26,
                      blurRadius: 2,
                    )
                  ],
                  pinTheme: PinTheme(
                    shape: PinCodeFieldShape.box,
                    borderRadius: BorderRadius.circular(3),
                    fieldHeight: 0.03 * size.width,
                    fieldWidth: 0.03 * size.width,
                    selectedFillColor: const Color(0xFFe3e1e4),
                    selectedColor: const Color(0xFFe3e1e4),
                    activeColor: const Color(0xFFe3e1e4),
                    activeFillColor: const Color(0xFFe3e1e4),
                    inactiveColor: const Color(0xFFe3e1e4),
                    inactiveFillColor: const Color(0xFFe3e1e4),
                  ),
                ),
              ),
            ),
            Center(
              child: SizedBox(
                width: 0.15 * size.width,
                child: RegularText(
                  're_new_safety_code',
                  maxLines: 1,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    color: AppColor.gray,
                    fontWeight: FontWeight.w600,
                    fontSize: Fontsize.smaller,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 0.01 * size.height,
            ),
            Center(
              child: SizedBox(
                height: 0.035 * size.width,
                width: 0.15 * size.width,
                child: PinCodeTextField(
                  appContext: context,
                  length: 4,
                  onChanged: (text) => controller.reParentCodeInput = text,
                  enablePinAutofill: false,
                  keyboardType: TextInputType.number,
                  enableActiveFill: true,
                  animationType: AnimationType.none,
                  // autoFocus: true,
                  textStyle: TextStyle(
                    fontFamily: 'Lato',
                    fontSize: Fontsize.normal,
                    fontWeight: FontWeight.bold,
                  ),
                  boxShadows: const [
                    BoxShadow(
                      offset: Offset(1.5, 1.5),
                      color: Colors.black26,
                      blurRadius: 2,
                    )
                  ],
                  cursorColor: AppColor.gray,
                  cursorHeight: 0.02 * size.width,
                  pinTheme: PinTheme(
                    shape: PinCodeFieldShape.box,
                    borderRadius: BorderRadius.circular(3),
                    fieldHeight: 0.03 * size.width,
                    fieldWidth: 0.03 * size.width,
                    selectedFillColor: const Color(0xFFe3e1e4),
                    selectedColor: const Color(0xFFe3e1e4),
                    activeColor: const Color(0xFFe3e1e4),
                    activeFillColor: const Color(0xFFe3e1e4),
                    inactiveColor: const Color(0xFFe3e1e4),
                    inactiveFillColor: const Color(0xFFe3e1e4),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LeftSetting extends StatelessWidget {
  const LeftSetting({
    super.key,
    required this.size,
    required this.controller,
  });

  final Size size;
  final SettingController controller;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 3,
      child: Container(
        padding: EdgeInsets.only(
          left: 0.03 * size.height,
          right: 0.03 * size.height,
          top: 0.01 * size.height,
        ),
        decoration: BoxDecoration(
          color: AppColor.lightYellow,
          borderRadius: BorderRadius.all(
            Radius.circular(0.04 * size.height),
          ),
        ),
        child: Obx(
          () => Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: RegularText(
                  'language',
                  data: const {'string': ': '},
                  maxLines: 1,
                  style: TextStyle(
                    color: AppColor.red,
                    fontSize: Fontsize.larger,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              SizedBox(
                height: 0.1 * size.height,
              ),
              ...List.generate(
                controller.languages.length,
                (index) => GestureDetector(
                  onTap: () => controller.onToggleSwitch(index),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 0.02 * size.height),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          controller.languages[index].value.isChecked
                              ? LocalImage.radioLangChecked
                              : LocalImage.radioLangUnchecked,
                          width: 0.04 * size.width,
                          height: 0.04 * size.width,
                        ),
                        SizedBox(width: 0.02 * size.width),
                        SizedBox(
                          width: 0.12 * size.width,
                          child: RegularText(
                            controller.languages[index].value.name,
                            textAlign: TextAlign.start,
                            maxLines: 2,
                            style: TextStyle(
                              color: AppColor.gray,
                              fontWeight: FontWeight.w600,
                              fontSize: Fontsize.smaller,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 0.01 * size.height,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
