import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

/// A custom image button widget that displays an image and handles tap events.
/// It provides visual feedback by changing opacity when pressed.
class ImageButton extends StatefulWidget {
  const ImageButton({
    Key? key,
    this.onTap,
    required this.pathImage,
    this.width = 0,
    this.height = 0,
    this.padding,
  }) : super(key: key);
  final Function? onTap;
  final double? width;
  final double? height;
  final String pathImage;
  final EdgeInsets? padding;

  @override
  State<ImageButton> createState() => _ImageButtonState();
}

class _ImageButtonState extends State<ImageButton> {
  bool isPressed = false;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: isPressed ? 0.5 : 1.0,
      child: GestureDetector(
        onTap: () {
          widget.onTap!();
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
        child: Padding(
          padding: widget.padding ?? const EdgeInsets.all(0),
          child: Image.asset(
            widget.pathImage,
            width: widget.width,
            height: widget.height,
          ),
        ),
      ),
    );
  }
}
