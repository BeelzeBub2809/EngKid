import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../utils/app_color.dart';
import '../../utils/font_size.dart';
import '../text/regular_text.dart';

/// A custom input field for user registration.
/// This widget allows users to input text with various configurations such as title, validation, keyboard type, and more.
class ItemInputRegister extends StatefulWidget {
  const ItemInputRegister(
      {super.key,
        required this.size,
        required this.controller,
        required this.title,
        required this.onChange,
        this.isTypeNumber,
        this.label,
        this.isLoginId,
        this.validateValue});

  final Size size;
  final RxString controller;
  final String title;
  final void Function(String) onChange;
  final bool? isTypeNumber;
  final String? label;
  final bool? isLoginId;
  final String? validateValue;

  @override
  State<ItemInputRegister> createState() => _ItemInputRegisterState();
}

class _ItemInputRegisterState extends State<ItemInputRegister> {
  late TextEditingController _textController;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(text: widget.controller.value);
    _focusNode = FocusNode();

    ever(widget.controller, (value) {
      if (_textController.text != value) {
        setState(() {
          _textController.text = value;
        });
      }
    });

    _focusNode.addListener(() {
      setState(() {});
    });
  }



  @override
  void dispose() {
    _textController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(_focusNode);
      },
      child: Container(
        color: Colors.transparent,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            RegularText(
              widget.title,
              style: TextStyle(
                color: Colors.black,
                fontSize: Fontsize.normal,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(width: widget.size.width * 0.3),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: _textController,
                    focusNode: _focusNode,
                    onChanged: (text) {
                      widget.onChange(text);
                      widget.controller.value = text;
                    },
                    keyboardType: widget.isTypeNumber == true
                        ? TextInputType.number
                        : TextInputType.text,
                    style: TextStyle(
                      color: widget.isLoginId == true
                          ? AppColor.red
                          : Colors.black,
                      fontSize: Fontsize.larger,
                      fontWeight: FontWeight.w600,
                      overflow: TextOverflow.ellipsis,
                    ),
                    maxLines: 1,
                    textAlign: TextAlign.right,
                    decoration: InputDecoration(
                        labelText: widget.label,
                        labelStyle: TextStyle(
                            fontSize: Fontsize.smaller,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic,
                            color: Colors.red)),
                  ),
                  if (widget.validateValue != null &&
                      widget.validateValue!.isNotEmpty)
                    const SizedBox(height: 5),
                  if (widget.validateValue != null &&
                      widget.validateValue!.isNotEmpty)
                    Text(widget.validateValue!.tr.toString(),
                        style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: AppColor.red)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}