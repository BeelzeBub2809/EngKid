import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

/// A custom OTP input widget that allows users to enter a one-time password (OTP).
/// This widget uses the `PinCodeTextField` from the `pin_code_fields` package to create a pin input field.
class PinPutOtpWidget extends StatefulWidget {
  final RxString controller;
  final Function(String) onCompleted;
  final Function(String) onChanged;
  final int length;
  final bool isDisabled;

  const PinPutOtpWidget({
    super.key,
    required this.controller,
    required this.onCompleted,
    required this.onChanged,
    this.length = 6,
    this.isDisabled = false,
  });

  @override
  _PinPutOtpWidgetState createState() => _PinPutOtpWidgetState();
}

class _PinPutOtpWidgetState extends State<PinPutOtpWidget> {
  late TextEditingController _controller;
  late bool isDisable;

  @override
  void initState() {
    super.initState();
    isDisable = widget.isDisabled;
    _controller = TextEditingController(text: widget.controller.value);

  }


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15, top: 25),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: PinCodeTextField(
          length: widget.length,
          controller: _controller,
          appContext: context,
          keyboardType: TextInputType.number,
          autoDismissKeyboard: true,
          cursorColor: Colors.blueAccent,
          textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          pinTheme: PinTheme(
            shape: PinCodeFieldShape.box,
            borderRadius: BorderRadius.circular(5),
            fieldHeight: Get.height * 0.065,
            fieldWidth: Get.width * 0.11,
            inactiveFillColor: Colors.grey.withOpacity(0.2),
            activeFillColor: Colors.white,
            selectedFillColor: Colors.white,
            inactiveColor: Colors.red.withOpacity(0.1),
            activeColor: Colors.redAccent,
            selectedColor: Colors.redAccent.withOpacity(0.8),
          ),
          onCompleted: (pin) {
            setState(() {
              isDisable = true;
            });
            widget.onCompleted(pin);
          },
          onChanged: (value) {
            setState(() {
              isDisable = value.length == widget.length;
            });
            widget.onChanged(value);
          },
        ),
      ),
    );
  }
}
