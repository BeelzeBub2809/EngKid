import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:EngKid/utils/font_size.dart';
import 'package:EngKid/utils/images.dart';

class EmptyData extends StatelessWidget {
  final double width;
  final double height;
  final String des;
  final TextStyle? desStyle;
  const EmptyData({
    super.key,
    required this.width,
    required this.height,
    this.des = "",
    this.desStyle,
  });

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(
          LocalImage.empty,
          width: width,
          height: height,
        ),
        SizedBox(
          height: 0.01 * size.height,
        ),
        Text(
          des.tr,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: const Color(
              0xffC4C0B5,
            ),
            fontSize: Fontsize.normal,
            fontWeight: FontWeight.w400,
            decoration: TextDecoration.none,
            fontFamily: "Lato",
          ).merge(desStyle),
        )
      ],
    );
  }
}
