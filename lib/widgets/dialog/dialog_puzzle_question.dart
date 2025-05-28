import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class PuzzleQuestionDialog extends StatelessWidget {
  final String question;
  final Function(String) onSubmit;
  final int limitInput;

  PuzzleQuestionDialog({required this.question, required this.onSubmit, required this.limitInput});

  @override
  Widget build(BuildContext context) {
    TextEditingController answerController = TextEditingController();

    return AlertDialog(
      title: Text(
        'answer_question'.tr,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            question,
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: answerController,
            decoration: InputDecoration(
              labelText: 'enter_answer'.tr,
              border: const OutlineInputBorder(),
            ),
            inputFormatters: [
              LengthLimitingTextInputFormatter(limitInput),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('cancel'.tr),
        ),
        ElevatedButton(
          onPressed: () {
            String answer = answerController.text;
            onSubmit(answer);
            Navigator.of(context).pop();
          },
          child: Text('confirm'.tr),
        ),
      ],
    );
  }
}
