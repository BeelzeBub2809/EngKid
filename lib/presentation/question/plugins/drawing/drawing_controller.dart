import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:get/get.dart';
import 'package:EngKid/domain/quiz/entities/entites.dart';
import 'package:EngKid/domain/quiz/quiz_usecases.dart';
import 'package:EngKid/utils/images.dart';
import 'package:EngKid/utils/lib_function.dart';
import 'package:EngKid/widgets/button/image_button.dart';
import 'package:EngKid/widgets/text/image_text.dart';

class DrawingController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late Function pickColorEvent;
  DrawingController();

  final RxBool _isStarted = false.obs;

  late BuildContext? contextDialog;
  Color pickerColor = const Color(0xff443a49);
  Color currentColor = const Color(0xff443a49);

  bool get isStarted => _isStarted.value;

  @override
  void onInit() {
    super.onInit();
    debugPrint("Init GameDrawController");
    try {} catch (e) {
      //
    }
  }

  void changeColor(Color color) {
    pickerColor = color;
  }

  void onPressStartDrawing() async {
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
        // content: HueRingPicker(
        //   pickerColor: currentColor,
        //   onColorChanged: changeColor,
        //   enableAlpha: false,
        //   displayThumbColor: false,
        // ),
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
