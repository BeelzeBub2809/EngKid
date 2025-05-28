import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:EzLish/utils/app_color.dart';

/// Custom TextField Widget
/// This widget provides a customizable text field with various properties such as title, validation, keyboard type, and more.
class TextFieldWidget extends StatefulWidget {
  final String? title;
  final String? validateValue;
  final bool? enabled;
  final TextInputType? keyboardType;
  final bool? obscureText;
  final RxString? controller;
  final int? maxLines;
  final int? maxLength;
  final Function(String)? onChange;
  final Widget? suffixIcon;
  final TextStyle? hintStyle;
  final String? hintText;
  final Widget? prefixIcon;
  final FocusNode? focusNode;
  final VoidCallback? onTab;

  const TextFieldWidget({
    Key? key,
    this.title,
    this.validateValue,
    this.enabled,
    this.keyboardType,
    this.obscureText,
    this.controller,
    this.maxLines,
    this.maxLength,
    this.onChange,
    this.suffixIcon,
    this.hintStyle,
    this.hintText,
    this.prefixIcon,
    this.focusNode,
    this.onTab,
  }) : super(key: key);

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<TextFieldWidget> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.controller?.value ?? '');

    _controller.addListener(() {
      if (widget.controller != null) {
        widget.controller!.value = _controller.text;
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.title != null && widget.title!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Text(widget.title!,
                style: const TextStyle(fontStyle: FontStyle.italic)),
          ),
        DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(5),
            border: Border.all(
              color: (widget.validateValue != null &&
                      widget.validateValue!.isNotEmpty)
                  ? Colors.red
                  : const Color(0xFFEFEFEF),
              width: 1.5,
            ),
          ),
          child: TextField(
            focusNode: widget.focusNode,
            cursorColor: Colors.blue,
            enabled: widget.enabled,
            onTap: widget.onTab,
            keyboardType: widget.keyboardType ?? TextInputType.text,
            obscureText: widget.obscureText ?? false,
            controller: _controller,
            maxLines: widget.maxLines ?? 1,
            maxLength: widget.maxLength,
            onChanged: (value) {
              widget.onChange?.call(value);
            },
            decoration: InputDecoration(
              counterText: '',
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 13),
              suffixIcon: widget.suffixIcon,
              hintStyle: widget.hintStyle ??
                  const TextStyle(
                      fontSize: 15,
                      fontStyle: FontStyle.italic,
                      color: AppColor.gray),
              hintText: widget.hintText?.tr ?? '',
              border: InputBorder.none,
              prefixIcon: widget.prefixIcon != null
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(width: 10),
                        widget.prefixIcon!,
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: SizedBox(
                            height: 25,
                            width: 1,
                            child: ColoredBox(color: Colors.blue),
                          ),
                        ),
                      ],
                    )
                  : null,
            ),
          ),
        ),
        if (widget.validateValue != null && widget.validateValue!.isNotEmpty)
          Text(widget.validateValue!.tr,
              style: const TextStyle(fontSize: 12, color: Colors.red)),
      ],
    );
  }
}
