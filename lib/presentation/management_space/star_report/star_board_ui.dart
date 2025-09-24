import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:EngKid/presentation/management_space/star_report/category_chart/category_chart_ui.dart';
import 'package:EngKid/presentation/management_space/star_report/category_chart/category_chart_binding.dart';
import 'package:EngKid/presentation/management_space/star_report/month/month_binding.dart';
import 'package:EngKid/presentation/management_space/star_report/month/month_ui.dart';
import 'package:EngKid/presentation/management_space/star_report/week/week_binding.dart';
import 'package:EngKid/presentation/management_space/star_report/week/week_ui.dart';
import 'package:EngKid/presentation/management_space/star_report/year/year_binding.dart';
import 'package:EngKid/presentation/management_space/star_report/year/year_ui.dart';
import 'package:EngKid/utils/app_route.dart';
import 'package:EngKid/utils/font_size.dart';
import 'package:EngKid/utils/images.dart';
import 'package:EngKid/widgets/text/image_text.dart';

import 'star_board_controller.dart';

class StarBoardUI extends GetView<StarBoardController> {
  const StarBoardUI({super.key});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Stack(
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
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 0.78 * size.height,
              margin: EdgeInsets.only(bottom: 0.05 * size.height),
              padding: EdgeInsets.only(
                top: 0.03 * size.height,
                bottom: 0.03 * size.height,
                left: 0.05 * size.height,
              ),
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(LocalImage.shapeGoldenBoard),
                  fit: BoxFit.fill,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Tabs(controller: controller),
                      Obx(
                        () => controller.isLoading.value
                            ? Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                  ),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                          0.02 * size.height),
                                      color: Colors.black26,
                                    ),
                                    child: Center(
                                      child: SizedBox(
                                        height: 0.2 * size.width,
                                        child: ChartData(
                                          controller: controller,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            : ChartData(controller: controller),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class ChartData extends StatelessWidget {
  const ChartData({
    super.key,
    required this.controller,
  });

  final StarBoardController controller;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return SizedBox(
      width: 0.65 * size.width,
      height: 0.6 * size.height,
      child: Obx(
        () => Navigator(
          key: Get.nestedKey(AppRoute.managementStarBoardRouteKey),
          initialRoute: controller.initialChildPageRoute,
          onGenerateRoute: (settings) {
            switch (settings.name) {
              case AppRoute.starBoardCategoryChart:
                final args = settings.arguments as Map<String, dynamic>?;
                final learningPathId =
                    args != null && args['learningPathId'] != null
                        ? args['learningPathId'] as int
                        : -1;
                return GetPageRoute(
                  settings: settings,
                  page: () => const CategoryChartUI(),
                  binding: CategoryChartBinding(learningPathId: learningPathId),
                );
              case AppRoute.starBoardWeek:
                return GetPageRoute(
                  settings: settings,
                  page: () => const WeekScreen(),
                  binding: WeekBinding(),
                );
              case AppRoute.starBoardMonth:
                return GetPageRoute(
                  settings: settings,
                  page: () => const MonthScreen(),
                  binding: MonthBinding(),
                );
              case AppRoute.starBoardYear:
                return GetPageRoute(
                  settings: settings,
                  page: () => const YearScreen(),
                  binding: YearBinding(),
                );
              default:
                return GetPageRoute(
                  settings: settings,
                  page: () => const WeekScreen(),
                  binding: WeekBinding(),
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

  final StarBoardController controller;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Container(
      padding: EdgeInsets.only(top: 0.05 * size.height),
      height: 0.6 * size.height,
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
                  child: ImageText(
                    onTap: () {
                      controller.onChooseFeature(index);
                    },
                    pathImage: controller.navBar[index].isActive
                        ? LocalImage.shapeBoardTabActive
                        : LocalImage.shapeBoardTabUnActive,
                    text: controller.navBar[index].title,
                    data: const {'week': ''},
                    width: 0.12 * size.width,
                    height: 0.14 * size.height,
                    style: TextStyle(
                      color: controller.navBar[index].isActive
                          ? Colors.white
                          : Colors.black,
                      fontSize: Fontsize.larger,
                      fontWeight: FontWeight.w700,
                    ),
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
