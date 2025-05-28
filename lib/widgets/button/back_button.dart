import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:EzLish/utils/images.dart';
import 'package:EzLish/widgets/button/image_button.dart';

class BackButton extends StatelessWidget {
  const BackButton({super.key, required this.onTap});
  final Function? onTap;
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return ImageButton(
      onTap: () {
        if (onTap.runtimeType != Null) {
          onTap!();
        }
        Get.back();
      },
      pathImage: LocalImage.backButton,
      height: 0.075 * size.width,
      width: 0.075 * size.width,
    );
  }
}
