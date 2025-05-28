import 'package:flutter/material.dart';
import 'package:EngKid/utils/font_size.dart';
import 'package:EngKid/widgets/text/regular_text.dart';

/// A modal that allows users to input text in a bottom sheet.
/// This widget is designed to be used in a landscape orientation,
class TextInputModal extends StatelessWidget {
  final String initialInput;
  final void Function(String text) onConfirm;
  final TextInputType? keyboardType;
  final int maxLength;
  final bool obscureText;

  const TextInputModal({
    super.key,
    this.initialInput = '',
    required this.onConfirm,
    this.keyboardType,
    this.maxLength = 15,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    final FocusNode focusNode = FocusNode();
    final TextEditingController inputController = TextEditingController(
      text: initialInput,
    );

    if (!focusNode.hasFocus) {
      focusNode.requestFocus();
    }

    void closeBottomSheet() {
      FocusScope.of(context).unfocus();
      onConfirm(inputController.text);
      Navigator.of(context).pop();
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(15),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: TextFormField(
                focusNode: focusNode,
                obscureText: obscureText,
                keyboardType: keyboardType,
                maxLength: maxLength,
                autofocus: true,
                controller: inputController,
                onFieldSubmitted: (value) => closeBottomSheet(),
                decoration: InputDecoration(
                  counterText: "",
                  contentPadding: const EdgeInsets.all(10.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.blue),
                  ),
                ),
                style: TextStyle(fontSize: Fontsize.normal),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
            ),
            SizedBox(
              width: 0.2 * size.height,
              child: TextButton(
                onPressed: () => closeBottomSheet(),
                style: TextButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const RegularText(
                  'Xong',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
