import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:EzLish/utils/app_color.dart';
import 'package:EzLish/widgets/text/regular_text.dart';

class ToastDialog extends StatelessWidget {
  final String message;

  const ToastDialog(this.message, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15.0),
      decoration: BoxDecoration(
        color: AppColor.toastBackground.withOpacity(0.6),
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: RegularText(
        message.tr,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}
