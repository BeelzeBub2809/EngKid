import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import 'package:EzLish/utils/font_size.dart';
import 'package:EzLish/widgets/text/regular_text.dart';

/// A custom loading dialog widget that displays a loading animation and a message.
/// This widget is useful for indicating that a process is ongoing, such as data fetching or processing.
class LoadingDialog extends StatelessWidget {
  const LoadingDialog({
    super.key,
    this.sizeIndi,
    this.color,
    this.des,
  });

  final double? sizeIndi;
  final Color? color;
  final String? des;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Stack(
      children: [
        Align(
          child: LoadingAnimationWidget.threeArchedCircle(
            color: color ?? Colors.white,
            size: sizeIndi ?? size.height * 0.5,
          ),
        ),
        Align(
          child: RegularText(
            des ?? 'waiting'.tr,
            style: TextStyle(
              color: Colors.white,
              fontSize: Fontsize.large,
              decoration: TextDecoration.none,
            ),
          ),
        ),
      ],
    );
  }
}
