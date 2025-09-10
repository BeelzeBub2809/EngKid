import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:EngKid/presentation/core/topic_service.dart';
import 'package:EngKid/presentation/core/user_service.dart';
import 'package:EngKid/presentation/my_library/my_library_controller.dart';
import 'package:EngKid/utils/app_color.dart';
import 'package:EngKid/utils/font_size.dart';
import 'package:EngKid/utils/images.dart';
import 'package:EngKid/widgets/button/image_button.dart';
import 'package:EngKid/widgets/image/cache_image.dart';
import 'package:EngKid/widgets/text/image_text.dart';
import 'package:EngKid/widgets/text/regular_text.dart';

class MyLibraryScreen extends GetView<MyLibraryController>{
  const MyLibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final TopicService topicService = Get.find<TopicService>();
    return Scaffold(
      body: Container(
        width: size.width,
        height: size.height,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(LocalImage.backgroundBlue),
            fit: BoxFit.fill,
          ),
        ),
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(children: [
                const Header(),
                Column(
                  children: [
                    RegularText(
                      "my_library",
                      maxLines: 1,
                      isUpperCase: true,
                      style: TextStyle(
                        color: AppColor.red,
                        fontWeight: FontWeight.w800,
                        fontSize: Fontsize.large,
                      ),
                    ),
                    Obx(
                          () => Padding(
                        padding: EdgeInsets.only(top: 0.04 * size.height),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                              topicService.grades.length-2, (index) {
                            return GradeIcon(
                                image: topicService.grades[index].image,
                                isOpen: topicService.grades[index].isOpen,
                                name: topicService.grades[index].name,
                                onPressGrade: () => controller
                                    .onPressGrade(topicService.grades[index]));
                          }),
                        ),
                      ),
                    ),
                    Obx(
                          () => topicService.grades.length > 3
                          ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                            topicService.grades.length-3, (index) {
                          return GradeIcon(
                            image: topicService.grades[3+index].image,
                            isOpen: topicService.grades[3+index].isOpen,
                            name: topicService.grades[3+index].name,
                            onPressGrade: () => controller.onPressGrade(
                                topicService.grades[3+index]),
                          );
                        }),
                      )
                          : const SizedBox(),
                    ),
                  ],
                )
              ]),
            ),
            Positioned.fill(
                right: 0.1 * size.width,
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [

                      Image.asset(
                        LocalImage.mascotWelcome,
                        height: 0.18 * size.width,
                        width: 0.12 * size.width,
                      ),
                    ],
                  ),
                )),
            Positioned.fill(
              left: 0.01 * size.width,
              child: Align(
                  alignment: Alignment.topLeft,
                  child: Column(
                    children: [
                      ImageButton(
                        pathImage: LocalImage.backButton,
                        height: 0.075 * size.width,
                        width: 0.075 * size.width,
                        onTap: () {
                          controller.onBackPress();
                        },
                      ),

                    ],
                  )),
            )
          ],
        ),
      ),
    );
  }
}

class GradeIcon extends StatelessWidget {
  const GradeIcon({
    super.key,
    required this.image,
    required this.isOpen,
    required this.name,
    required this.onPressGrade,
  });

  final String image;
  final bool isOpen;
  final String name;
  final Function onPressGrade;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        onPressGrade();
      },
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(
              top: 0.04 * size.height,
              bottom: 0.04 * size.height,
              left: 0.06 * size.height,
              right: 0.06 * size.height,
            ),
            child: Container(
              width: size.height * 0.28,
              height: size.height * 0.28,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(LocalImage.gradeShape),
                  fit: BoxFit.fill,
                ),
              ),
              child: Center(
                child: Image.asset(
                  image,
                  width: size.height * 0.18,
                  height: size.height * 0.18,
                ),
              ),
            ),
          ),
          if (!isOpen)
            Positioned.fill(
              child: Align(
                alignment: Alignment.center,
                child: Container(
                  width: size.height * 0.28,
                  height: size.height * 0.28,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(LocalImage.gradeShapeDisable),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
            ),
          if (!isOpen)
            Positioned.fill(
              child: Align(
                alignment: Alignment.center,
                child: Image.asset(
                  LocalImage.lock,
                  width: size.width * 0.05,
                  height: size.width * 0.05,
                ),
              ),
            ),
          Positioned.fill(
            child: Align(
              alignment: Alignment.topRight,
              child: ImageText(
                style: TextStyle(
                    fontSize: Fontsize.small,
                    color: Colors.white,
                    fontWeight: FontWeight.w700),
                text: name,
                // data: {'grade': name},
                maxLines: 1,
                isUpperCase: true,
                pathImage: LocalImage.gradeName,
                width: size.width * 0.09,
                height: size.width * 0.04,
              ),
            ),
          ),
          if (!isOpen)
            Positioned.fill(
              child: Align(
                alignment: Alignment.topRight,
                child: ImageText(
                  style: TextStyle(
                      fontSize: Fontsize.small,
                      color: Colors.grey,
                      fontWeight: FontWeight.w700),
                  text: '',
                  pathImage: LocalImage.gradeNameDisable,
                  width: size.width * 0.09,
                  height: size.width * 0.04,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class Header extends StatelessWidget {
  const Header({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final UserService userService = Get.find<UserService>();
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Column(
          //   mainAxisSize: MainAxisSize.min,
          //   children: [
          //     ImageButton(
          //       onTap: () {
          //         // userService.onPressStarBoard(isValidate: false);
          //       },
          //       pathImage: LocalImage.numOfStar,
          //       width: 0.06 * size.width,
          //       height: 0.06 * size.width,
          //     ),
          //     RegularText('star_board_title'.tr, style: TextStyle(fontSize: Fontsize.smaller, color: AppColor.yellow),)
          //   ],
          // ),
          // SizedBox(
          //   width: 0.02 * size.height,
          // ),
          GestureDetector(
            onTap: () {
              // userService.onPressProfile();
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black12,
                borderRadius: BorderRadius.circular(0.035 * size.height),
              ),
              padding: EdgeInsets.all(0.002 * size.height),
              width: 0.2 * size.width,
              height: 0.06 * size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(LocalImage.shapeAvatar),
                        fit: BoxFit.fill,
                      ),
                    ),
                    width: 0.055 * size.width,
                    height: 0.055 * size.width,
                    child: Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(0.04 * size.width),
                        child: CacheImage(
                          url: userService.currentUser.avatar,
                          width: 0.04 * size.width,
                          height: 0.04 * size.width,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 0.01 * size.width),
                  SizedBox(
                    width: 0.12 * size.width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        RegularText(
                          userService.currentUser.name,
                          maxLines: 1,
                          style: TextStyle(
                            color: AppColor.red,
                            fontWeight: FontWeight.w800,
                            fontSize: Fontsize.small + 1,
                          ),
                        ),
                        RegularText(
                          // "grade",
                          'Lớp: ${userService.currentUser.gradeId}' ?? '',
                          style: TextStyle(
                            color: AppColor.gray,
                            fontWeight: FontWeight.w800,
                            fontSize: Fontsize.small + 1,
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
