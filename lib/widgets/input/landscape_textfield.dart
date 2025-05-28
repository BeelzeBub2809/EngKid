import 'package:flutter/material.dart';
import 'package:EzLish/utils/font_size.dart';
import 'package:EzLish/widgets/text/regular_text.dart';

import 'text_input_modal.dart';

/// A custom text field widget designed for landscape orientation.
/// This widget allows users to input text in a bottom sheet modal,
class LandScapeTextField extends StatelessWidget {
  final void Function(String text) onChange;
  final TextInputType? keyboardType;
  final String input;
  final int maxLength;
  final bool obscureText;
  final String placeHolder;
  final Alignment textAlign;
  final TextStyle? textStyle;
  final Color borderColor;
  final Color backgroundColor;
  final double? width;
  final Function? setIsFullScreen;
  final bool isDisable;
  final double borderRadius;
  final EdgeInsets padding;
  final bool? enable;

  const LandScapeTextField({
    super.key,
    required this.input,
    required this.onChange,
    this.keyboardType,
    this.maxLength = 255,
    this.placeHolder = '',
    this.obscureText = false,
    this.textAlign = Alignment.centerLeft,
    this.textStyle,
    this.borderColor = Colors.transparent,
    this.backgroundColor = Colors.black12,
    this.width = double.infinity,
    this.setIsFullScreen,
    this.isDisable = false,
    this.borderRadius = 3,
    this.padding = EdgeInsets.zero,
    this.enable,
  });

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        if (isDisable) return;
        if (setIsFullScreen.runtimeType != Null) {
          setIsFullScreen!(true);
        }
        showBottomSheet(
          context: context,
          builder: (BuildContext context) => TextInputModal(
            initialInput: input,
            onConfirm: onChange,
            keyboardType: keyboardType,
            maxLength: maxLength,
            obscureText: obscureText,
          ),
          backgroundColor: Colors.white,
        );
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: Container(
          height: TextInputType.multiline == keyboardType
              ? 0.1 * size.height * 5
              : 0.1 * size.height,
          width: width,
          padding: padding,
          decoration: BoxDecoration(
            color: backgroundColor,
            border: Border(
                bottom: BorderSide(
              color: borderColor,
              width: 1.5,
            )),
          ),
          constraints: BoxConstraints(minWidth: 0.4 * size.width),
          child: Align(
            alignment: textAlign,
            child: keyboardType == TextInputType.multiline
                ? RegularText(
                    placeHolder.isNotEmpty && input.isEmpty || input.isEmpty
                        ? placeHolder
                        : input,
                    maxLines: 5,
                    textAlign: TextAlign.justify,
                    style: placeHolder.isNotEmpty && input == ''
                        ? TextStyle(
                            // color: AppColor.placeholder,
                            fontSize: Fontsize.smaller,
                          )
                        : textStyle,
                  )
                : RegularText(
                    placeHolder.isNotEmpty && input.isEmpty || input.isEmpty
                        ? placeHolder
                        : obscureText == true
                            ? input.replaceAll(
                                RegExp("."),
                                "•",
                              ) //replace all character by • for obsecure
                            : input,
                    style: placeHolder.isNotEmpty && input == ''
                        ? TextStyle(
                            // color: AppColor.placeholder,
                            fontSize: Fontsize.smaller,
                          )
                        : textStyle,
                  ),
          ),
        ),
      ),
    );
  }
}
