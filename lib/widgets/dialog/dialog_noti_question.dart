import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:EzLish/utils/app_color.dart';
import 'package:EzLish/utils/font_size.dart';
import 'package:EzLish/utils/images.dart';
import 'package:EzLish/utils/lib_function.dart';
import 'package:EzLish/widgets/button/image_button.dart';
import 'package:EzLish/widgets/text/image_text.dart';
import 'package:EzLish/widgets/text/regular_text.dart';

enum TypeDialog { warning, failed, success }

class DialogNotiQuestion extends StatelessWidget {
  const DialogNotiQuestion({
    super.key,
    required this.type,
    required this.onNext,
    required this.onReTry,
    required this.onClose,
  });
  final TypeDialog type;
  final Function onNext;
  final Function onReTry;
  final Function onClose;
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    late Widget main = Container();

    switch (type) {
      case TypeDialog.warning:
        main = Stack(
          children: [
            Container(
              height: size.height * 0.6,
              width: size.width * 0.6,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(LocalImage.shapeQuestionWarning),
                  fit: BoxFit.fill,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 0.06 * size.height,
                  ),
                  Image.asset(
                    LocalImage.questionWarning,
                    width: 0.25 * size.height,
                    height: 0.25 * size.height,
                  ),
                  SizedBox(
                    height: 0.02 * size.height,
                  ),
                  RegularText(
                    "note",
                    isUpperCase: true,
                    style: TextStyle(
                      color: const Color(0XFFFA8811),
                      fontSize: Fontsize.large,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(
                    height: 0.02 * size.height,
                  ),
                  RegularText(
                    "let_do_it",
                    style: TextStyle(
                      color: AppColor.textDefault,
                      fontSize: Fontsize.small,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(
                    height: 0.1 * size.height,
                  )
                ],
              ),
            ),
            Positioned.fill(
              top: 0.045 * size.width,
              right: 0.045 * size.width,
              child: Align(
                alignment: Alignment.topRight,
                child: ImageButton(
                  pathImage: LocalImage.questionCloseWarning,
                  onTap: () async {
                    await LibFunction.effectConfirmPop();
                    Get.back();
                  },
                  width: 0.04 * size.width,
                  height: 0.04 * size.width,
                ),
              ),
            ),
          ],
        );
        break;
      case TypeDialog.failed:
        main = Stack(
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 0.16 * size.height),
              child: Container(
                height: size.height * 0.6,
                width: size.width * 0.6,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                      LocalImage.shapeQuestionFail,
                    ),
                    fit: BoxFit.fill,
                  ),
                ),
                child: Column(
                  // crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 0.06 * size.height,
                    ),
                    SizedBox(
                      height: 0.02 * size.height,
                    ),
                    RegularText(
                      "not_exactly",
                      isUpperCase: true,
                      style: TextStyle(
                        color: const Color(0XFFFA8811),
                        fontSize: Fontsize.large,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(
                      height: 0.02 * size.height,
                    ),
                    RegularText(
                      "let_retry",
                      style: TextStyle(
                        color: AppColor.textDefault,
                        fontSize: Fontsize.small,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(
                      height: 0.1 * size.height,
                    )
                  ],
                ),
              ),
            ),
            Positioned.fill(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ImageText(
                      text: "retry",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: Fontsize.normal,
                        fontWeight: FontWeight.w600,
                      ),
                      isUpperCase: true,
                      onTap: () async {
                        await LibFunction.effectConfirmPop();
                        Get.back();
                        onReTry();
                      },
                      pathImage: LocalImage.questionWarningButton,
                      width: size.width * 0.18,
                      height: size.height * 0.12,
                    ),
                    SizedBox(
                      width: 0.03 * size.width,
                    ),
                    ImageText(
                      text: "next",
                      isUpperCase: true,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: Fontsize.normal,
                        fontWeight: FontWeight.w600,
                      ),
                      onTap: () async {
                        LibFunction.effectConfirmPop();
                        Get.back();
                        onNext();
                      },
                      pathImage: LocalImage.questionWarningButton,
                      width: size.width * 0.18,
                      height: size.height * 0.12,
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
        break;
      case TypeDialog.success:
        main = Stack(
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 0.16 * size.height),
              child: Container(
                height: size.height * 0.6,
                width: size.width * 0.6,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(LocalImage.shapeQuestionSuccess),
                    fit: BoxFit.fill,
                  ),
                ),
                child: Column(
                  // crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 0.06 * size.height,
                    ),
                    // Image.asset(
                    //   LocalImage.mascotHello,
                    //   width: 0.25 * size.height,
                    //   height: 0.25 * size.height,
                    // ),
                    SizedBox(
                      height: 0.02 * size.height,
                    ),
                    RegularText(
                      "exactly",
                      isUpperCase: true,
                      style: TextStyle(
                          color: const Color(0XFF45B083),
                          fontSize: Fontsize.large,
                          fontWeight: FontWeight.w800),
                    ),
                    SizedBox(
                      height: 0.02 * size.height,
                    ),
                    RegularText(
                      "continue_develop",
                      style: TextStyle(
                        color: AppColor.textDefault,
                        fontSize: Fontsize.small,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(
                      height: 0.1 * size.height,
                    )
                  ],
                ),
              ),
            ),
            Positioned.fill(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: ImageText(
                  text: "next",
                  isUpperCase: true,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: Fontsize.normal,
                    fontWeight: FontWeight.w600,
                  ),
                  onTap: () async {
                    LibFunction.effectConfirmPop();
                    Get.back();
                    onNext();
                  },
                  pathImage: LocalImage.questionSuccessButton,
                  width: size.width * 0.18,
                  height: size.height * 0.12,
                ),
              ),
            ),
          ],
        );
        break;
    }

    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      backgroundColor: Colors.transparent,
      elevation: 0,
      content: main,
    );
  }
}
