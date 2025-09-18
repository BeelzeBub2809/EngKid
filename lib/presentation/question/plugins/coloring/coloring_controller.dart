import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:get/get.dart';
import 'package:EngKid/domain/quiz/entities/entites.dart';
import 'package:EngKid/domain/quiz/quiz_usecases.dart';
import 'package:EngKid/utils/app_color.dart';
import 'package:EngKid/utils/lib_function.dart';

import '../../../../utils/images.dart';
import '../../../../widgets/text/image_text.dart';

class ColoringController extends GetxController
    with GetSingleTickerProviderStateMixin {
  String get coloringUrl {
    final List<String> listColoringImage = [
      LocalImage.coloring01,
      LocalImage.coloring02,
      LocalImage.coloring03,
      LocalImage.coloring04,
      LocalImage.coloring05,
      LocalImage.coloring06,
      LocalImage.coloring07,
      LocalImage.coloring08,
      LocalImage.coloring09,
      LocalImage.coloring10,
      LocalImage.coloring11,
      LocalImage.coloring12,
      LocalImage.coloring13,
      LocalImage.coloring14,
      LocalImage.coloring15,
      LocalImage.coloring16,
      LocalImage.coloring17,
      LocalImage.coloring18,
      LocalImage.coloring19,
      LocalImage.coloring20,
      LocalImage.coloring21,
      LocalImage.coloring22,
      LocalImage.coloring23,
      LocalImage.coloring24,
      LocalImage.coloring25,
      LocalImage.coloring26,
      LocalImage.coloring27,
      LocalImage.coloring28,
      LocalImage.coloring29,
      LocalImage.coloring30,
      LocalImage.coloring31,
      LocalImage.coloring32,
      LocalImage.coloring33,
      LocalImage.coloring34,
      LocalImage.coloring35,
    ];

    Random random = Random();

    return listColoringImage[random.nextInt(listColoringImage.length)];
  }

  late Function pickColorEvent;

  ColoringController();

  final RxBool _isStarted = false.obs;

  late BuildContext? contextDialog;
  Color pickerColor = const Color(0xff443a49);
  Color currentColor = const Color(0xff443a49);

  bool get isStarted => _isStarted.value;

  @override
  void onInit() {
    super.onInit();
    debugPrint("Init GameColoringController");
    try {} catch (e) {
      //
    }
  }

  void changeColor(Color color) {
    pickerColor = color;
  }

  void onPressStartColoring() async {
    await LibFunction.effectConfirmPop();
    _isStarted.value = true;
  }

  void onPressBack() {
    Get.back();
  }

  void openColorPicker() {
    showDialog(
      context: contextDialog!,
      builder: (BuildContext context) => AlertDialog(
        title: Padding(
          padding: const EdgeInsets.only(left: 25),
          child: Semantics(
              label: 'select_color'.tr, child: Text('select_color'.tr)),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 50),
        content: SizedBox(
          height: 300,
          child: ColorPicker(
            pickerColor: currentColor,
            onColorChanged: changeColor,
            colorPickerWidth: 220,
            pickerAreaHeightPercent: 0.5,
            enableAlpha: false,
            labelTypes: const [],
            displayThumbColor: false,
            paletteType: PaletteType.hslWithHue,
            pickerAreaBorderRadius: const BorderRadius.only(
                topLeft: Radius.circular(2), topRight: Radius.circular(2)),
            hexInputBar: false,
            portraitOnly: true,
          ),
        ),
        actions: <Widget>[
          ImageText(
            pathImage: LocalImage.shapeButton,
            width: Get.width * 0.13,
            height: Get.height * 0.12,
            onTap: () {
              Navigator.of(context).pop();
            },
            text: 'cancel',
          ),
          ImageText(
            pathImage: LocalImage.questionSuccessButton,
            width: Get.width * 0.13,
            height: Get.height * 0.12,
            text: 'confirm',
            onTap: () {
              currentColor = pickerColor;
              pickColorEvent(currentColor);
              Navigator.of(context).pop();
            },
          )
        ],
      ),
    );
  }
}
