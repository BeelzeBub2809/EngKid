import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:EngKid/utils/app_color.dart';
import 'package:EngKid/utils/lib_function.dart';
import 'package:EngKid/widgets/text/regular_text.dart';

class DialogAlert extends StatelessWidget {
  final String message;
  final bool? isCancel;

  const DialogAlert({super.key, required this.message, this.isCancel});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      content: Container(
        width: 0.4 * size.width,
        height: 0.3 * size.height,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: RegularText(
                'notification'.tr,
                style: const TextStyle(
                  color: AppColor.blue,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  color: AppColor.toastBackground,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(5),
                    bottomRight: Radius.circular(5),
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      RegularText(
                        message.tr,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.black),
                        maxLines: 8,
                      ),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: size.width * 0.05),
                        child: Row(
                          mainAxisAlignment: isCancel == true
                              ? MainAxisAlignment.spaceBetween
                              : MainAxisAlignment.center,
                          children: [
                            if (isCancel == true)
                              TextButton(
                                style: TextButton.styleFrom(
                                  backgroundColor: Colors.orange,
                                ),
                                onPressed: () {
                                  LibFunction.effectConfirmPop();
                                  Get.back();
                                },
                                child: RegularText(
                                  'cancel'.tr,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            TextButton(
                              style: TextButton.styleFrom(
                                backgroundColor: Colors.orange,
                              ),
                              onPressed: () {
                                LibFunction.effectConfirmPop();
                                Get.back();
                              },
                              child: RegularText(
                                'confirm'.tr,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
