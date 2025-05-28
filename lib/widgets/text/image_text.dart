import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:EngKid/utils/font_size.dart';
import 'package:EngKid/widgets/text/regular_text.dart';

/// A widget that displays an image with text overlay.
/// This widget is useful for creating buttons or interactive elements with an image background and text label.
class ImageText extends StatefulWidget {
  const ImageText(
      {Key? key,
      this.onTap,
      required this.pathImage,
      required this.text,
      this.style = const TextStyle(),
      this.textAlign,
      this.maxLines,
      this.width = 0,
      this.height = 0,
      this.data,
      this.isUpperCase = false,
      this.padding = EdgeInsets.zero,
      this.isDisable})
      : super(key: key);
  final Function? onTap;
  final double? width;
  final double? height;
  final String pathImage;
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;
  final Map<String, String>? data;
  final bool? isUpperCase;
  final EdgeInsets padding;
  final bool? isDisable;

  @override
  State<ImageText> createState() => _ImageTextState();
}

class _ImageTextState extends State<ImageText> {
  bool isPressed = false;

  @override
  Widget build(BuildContext context) {
    final TextStyle baseStyle = TextStyle(
      color: widget.isDisable == true ? Colors.grey : Colors.white,
      fontSize: Fontsize.normal,
      fontWeight: FontWeight.w600,
    );
    return Opacity(
      opacity: widget.isDisable == true ? 0.5 : (isPressed ? 0.5 : 1.0),
      child: GestureDetector(
        onTap: widget.isDisable == true
            ? null
            : () {
                try {
                  widget.onTap!();
                } catch (e) {
                  //
                }
              },
        onTapDown: (TapDownDetails details) {
          setState(() {
            isPressed = true;
          });
        },
        onTapUp: (TapUpDetails details) {
          setState(() {
            isPressed = false;
          });
        },
        onTapCancel: () {
          setState(() {
            isPressed = false;
          });
        },
        child: Container(
          width: widget.width!,
          height: widget.height!,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(widget.pathImage),
              fit: BoxFit.fill,
            ),
          ),
          child: Padding(
            padding: widget.padding,
            child: Center(
              child: RegularText(
                widget.text.tr,
                data: widget.data,
                isUpperCase: widget.isUpperCase,
                textAlign: widget.textAlign,
                maxLines: widget.maxLines,
                style: baseStyle.merge(widget.style),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
