import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:EngKid/presentation/core/topic_service.dart';
import 'package:EngKid/presentation/core/user_service.dart';
import 'package:EngKid/utils/app_color.dart';
import 'package:EngKid/utils/app_route.dart';
import 'package:EngKid/utils/font_size.dart';
import 'package:EngKid/utils/images.dart';
import 'package:EngKid/utils/lib_function.dart';
import 'package:EngKid/widgets/text/image_text.dart';
import 'package:EngKid/widgets/text/regular_text.dart';

class DialogSurveyResult extends StatelessWidget {
  DialogSurveyResult(
      {super.key,
      required this.isCorrect,
      required this.numOfCorrect,
      required this.totalQuestion,
      required this.onTap,
      required this.goLibrary,
      required this.goeLibrary});
  final bool isCorrect;
  final int numOfCorrect;
  final int totalQuestion;
  final Function onTap;
  final bool goLibrary;
  final bool goeLibrary;
  final UserService _userService = Get.find<UserService>();
  final TopicService _topicService = Get.find<TopicService>();
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      backgroundColor: Colors.transparent,
      elevation: 0,
      content: Stack(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 0.06 * size.height),
            child: Container(
              height: isCorrect ? size.height * 0.75 : size.height * 0.55,
              width: isCorrect ? size.width * 0.5 : size.width * 0.55,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(isCorrect
                      ? LocalImage.surveyCorrect
                      : LocalImage.surveyIncorrect),
                  fit: BoxFit.fill,
                ),
              ),
              child: isCorrect
                  ? Column(
                      // crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                          // Image.asset(
                          //   LocalImage.mascotHappy,
                          //   width: size.width * 0.15,
                          //   height: size.height * 0.3,
                          // ),
                          RegularText(
                            "safety_survey_6",
                            data: {
                              'numOfQuiz': "$numOfCorrect/$totalQuestion",
                            },
                            style: TextStyle(
                                fontWeight: FontWeight.w800,
                                color: AppColor.blue,
                                fontSize: Fontsize.small + 1),
                          ),
                          RegularText(
                            "safety_survey_7",
                            style: TextStyle(
                                fontWeight: FontWeight.w800,
                                color: AppColor.gray,
                                fontSize: Fontsize.small),
                          ),
                          RichText(
                            textAlign: TextAlign.start,
                            text: TextSpan(
                              text: "safety_survey_8".tr,
                              style: TextStyle(
                                color: AppColor.gray,
                                fontSize: Fontsize.small,
                                fontWeight: FontWeight.w800,
                                fontFamily: 'Lato',
                              ),
                              children: <TextSpan>[
                                TextSpan(
                                    text: "app_name".tr.toUpperCase(),
                                    style: const TextStyle(color: AppColor.red))
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 0.1 * size.height,
                          )
                        ])
                  : Column(
                      // crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        // Image.asset(
                        //   LocalImage.mascotSad,
                        //   width: size.width * 0.15,
                        //   height: size.height * 0.3,
                        // ),
                        RegularText(
                          "safety_survey_4",
                          data: {
                            'numOfQuiz': "$numOfCorrect/$totalQuestion",
                          },
                          maxLines: 1,
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            color: AppColor.red,
                            fontSize: Fontsize.small + 1,
                          ),
                        ),
                        SizedBox(
                          width: 0.4 * size.width,
                          child: RegularText(
                            "safety_survey_5",
                            maxLines: 2,
                            style: TextStyle(
                                fontWeight: FontWeight.w800,
                                color: AppColor.gray,
                                fontSize: Fontsize.small),
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
              text: isCorrect ? 'start' : 'watch_again',
              isUpperCase: true,
              onTap: () async {
                if (isCorrect) {
                  await LibFunction.effectConfirmPop();
                  if (!_userService.currentUser.surveyPassed) {
                    // _userService.changeUserProfile(
                    //     type: UserDataUpdateType.surveyPassed, value: true);
                  }
                  Get.back(); // close dialog
                  if (!goLibrary) {
                    LibFunction.rePlayBackgroundSound();
                    // Get.offAllNamed(AppRoute.kidSpace); // out route
                  } else {
                    LibFunction.rePlayBackgroundSound();
                    // _topicService.getGradesFromStorage();
                    // Get.offNamed(
                    //     goeLibrary ? AppRoute.eLibrary : AppRoute.chooseGrade,
                    //     arguments: true);
                  }
                } else {
                  onTap();
                  Get.back();
                }
              },
              pathImage: isCorrect
                  ? LocalImage.questionSuccessButton
                  : LocalImage.shapeButton,
              width: size.width * 0.16,
              height: size.height * 0.14,
            ),
          )),
        ],
      ),
    );
  }
}
