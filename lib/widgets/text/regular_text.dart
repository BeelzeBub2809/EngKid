import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:EngKid/utils/font_size.dart';

/// A widget that displays regular text with customizable styles and alignment.
/// This widget is useful for displaying text in various parts of the application with options for styling, alignment, and data parameters.
class RegularText extends StatelessWidget {
  final String text;
  final TextAlign? textAlign;
  final TextStyle? style;
  final int? maxLines;
  final Map<String, String>? data;
  final bool? isUpperCase;

  const RegularText(this.text,
      {super.key,
      this.style,
      this.textAlign,
      this.maxLines,
      this.data,
      this.isUpperCase = false});

  @override
  Widget build(BuildContext context) {
    final TextStyle baseStyle = TextStyle(
      color: Colors.black,
      decoration: TextDecoration.none,
      fontFamily: 'Lato',
      fontSize: Fontsize.normal,
    );

    final String tmp =
        data.runtimeType == Null ? text.tr : text.trParams(data!);

    return AutoSizeText(
      isUpperCase == true ? tmp.toUpperCase() : tmp,
      maxLines: maxLines,
      textAlign: textAlign ?? TextAlign.center,
      textScaleFactor: 1.0,
      overflow: TextOverflow.ellipsis,
      softWrap: true,
      style: style != null ? baseStyle.merge(style) : baseStyle,
    );
  }
}
