import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:EngKid/presentation/core/user_service.dart';
import 'package:EngKid/presentation/management_space/personal_info/personal_info_ui.dart';
import 'package:EngKid/presentation/management_space/setting/setting_binding.dart';
import 'package:EngKid/presentation/management_space/setting/setting_ui.dart';
import 'package:EngKid/utils/app_color.dart';
import 'package:EngKid/utils/app_route.dart';
import 'package:EngKid/utils/font_size.dart';
import 'package:EngKid/utils/images.dart';
import 'package:EngKid/utils/lib_function.dart';
import 'package:EngKid/widgets/button/image_button.dart';
import 'package:EngKid/widgets/image/cache_image.dart';
import 'package:EngKid/widgets/text/image_text.dart';
import 'package:EngKid/widgets/text/regular_text.dart';

import 'management_space_controller.dart';
import 'personal_info/personal_info_binding.dart';
import 'report/report_binding.dart';
import 'report/report_ui.dart';

class ManagementSpaceScreen extends GetView<ManagementSpaceController> {
  const ManagementSpaceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: size.width,
            height: size.height,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(LocalImage.safetyGuideBg),
                fit: BoxFit.fill,
              ),
            ),
            padding: EdgeInsets.only(
              top: 0.05 * size.height,
              bottom: 0.05 * size.height,
              left: 0.03 * size.height,
              right: 0.03 * size.height,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Tabs(controller: controller),
                Content(controller: controller),
              ],
            ),
          ),
          const Positioned.fill(
            child: Align(
              alignment: Alignment.topRight,
              child: Header(),
            ),
          ),
        ],
      ),
    );
  }
}

class Content extends StatelessWidget {
  const Content({
    super.key,
    required this.controller,
  });

  final ManagementSpaceController controller;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return SizedBox(
      width: 0.8 * size.width,
      height: 0.75 * size.height,
      child: Obx(
        () => Navigator(
          key: Get.nestedKey(AppRoute.managementSpaceNestedRouteKey),
          initialRoute: controller.initialChildPageRoute,
          onGenerateRoute: (settings) {
            switch (settings.name) {
              case AppRoute.report:
                return GetPageRoute(
                  page: () => const ReportScreen(),
                  binding: ReportBinding(),
                  transition: Transition.zoom,
                );
              case AppRoute.personalInfo:
                return GetPageRoute(
                  page: () => const PersonalInfoScreen(),
                  binding: PersonalInfoBinding(),
                  transition: Transition.zoom,
                );

              case AppRoute.settings:
                return GetPageRoute(
                  page: () => const SettingScreen(),
                  binding: SettingBinding(),
                  transition: Transition.zoom,
                );

              default:
                return GetPageRoute(
                  page: () => const ReportScreen(),
                  binding: ReportBinding(),
                  transition: Transition.zoom,
                );
            }
          },
        ),
      ),
    );
  }
}

class Tabs extends StatelessWidget {
  const Tabs({
    super.key,
    required this.controller,
  });

  final ManagementSpaceController controller;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Container(
      padding:
          EdgeInsets.only(top: 0.05 * size.height, bottom: 0.05 * size.height),
      height: 0.8 * size.height,
      child: RawScrollbar(
        thumbColor: Colors.transparent,
        trackColor: Colors.transparent,
        thumbVisibility: true,
        thickness: 0.008 * size.width,
        interactive: true,
        padding: EdgeInsets.only(
          top: 0.03 * size.height,
          bottom: 0.01 * size.height,
          right: -0.02 * size.width,
        ),
        controller: controller.scrollControllerNav,
        child: SingleChildScrollView(
          controller: controller.scrollControllerNav,
          child: Obx(
            () => Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                controller.navBar.length,
                (index) => Padding(
                  padding: EdgeInsets.symmetric(vertical: 0.02 * size.height),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      ImageText(
                        onTap: () {
                          controller.onChooseFeature(index);
                        },
                        pathImage: controller.navBar[index].value.isActive
                            ? LocalImage.managementSpaceTabSelected
                            : LocalImage.managementSpaceTabUnselected,
                        text: controller.navBar[index].value.title,
                        width: 0.12 * size.width,
                        height: 0.14 * size.height,
                        padding: EdgeInsets.all(0.01 * size.height),
                        style: TextStyle(
                          color: controller.navBar[index].value.isActive
                              ? AppColor.red
                              : AppColor.gray,
                          fontSize: Fontsize.larger,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(width: 0.01 * size.width),
                      if (controller.navBar[index].value.isActive)
                        Image.asset(LocalImage.menuSelected,
                            width: 0.03 * size.width, height: 0.03 * size.width)
                      else
                        SizedBox(
                          width: 0.03 * size.width,
                          height: 0.03 * size.width,
                        )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ImageButton(
                onTap: () async {
                  await LibFunction.effectConfirmPop();
                  Get.back();
                },
                semantics: 'back',
                pathImage: LocalImage.backButton,
                height: 0.075 * size.width,
                width: 0.075 * size.width,
              ),
              RegularText(
                'home'.tr,
                style:
                    TextStyle(fontSize: Fontsize.normal, color: AppColor.red),
              )
            ],
          ),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Column(
                children: [
                  ImageButton(
                    onTap: () {
                      // userService.onPressStarBoard(isValidate: false);
                    },
                    semantics: 'star_board_title',
                    pathImage: LocalImage.numOfStar,
                    width: 0.06 * size.width,
                    height: 0.06 * size.width,
                  ),
                  RegularText(
                    'star_board_title'.tr,
                    style: TextStyle(
                        fontSize: Fontsize.smallest, color: AppColor.yellow),
                  )
                ],
              ),
              SizedBox(
                width: 0.05 * size.height,
              ),
              GestureDetector(
                onTap: () async {
                  await LibFunction.effectConfirmPop();
                  // userService.logout();
                  userService.onPressProfile();
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white30,
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
                            borderRadius:
                                BorderRadius.circular(0.04 * size.width),
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
                              userService.currentUser.grade ?? '',
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
              ),
            ],
          )
        ],
      ),
    );
  }
}
