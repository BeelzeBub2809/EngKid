// ignore_for_file: use_named_constants
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:EngKid/utils/app_color.dart';
import 'package:EngKid/utils/font_size.dart';
import 'package:EngKid/utils/images.dart';
import 'package:EngKid/widgets/button/image_button.dart';
import 'package:EngKid/widgets/text/regular_text.dart';

import 'bar_chart.dart';
import 'report_controller.dart';

class ReportScreen extends GetView<ReportController> {
  const ReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: double.infinity,
          padding: EdgeInsets.all(0.05 * size.height),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(0.08 * size.height),
            color: const Color(0XFFf0f1eb),
          ),
          child: Row(
            children: [
              ContentLeft(
                size: size,
                controller: controller,
              ),
              SizedBox(width: 0.03 * size.height),
              RightContent(
                controller: controller,
                size: size,
              )
            ],
          ),
        ),
      ],
    );
  }
}

class RightContent extends StatelessWidget {
  const RightContent({
    super.key,
    required this.controller,
    required this.size,
  });

  final Size size;
  final ReportController controller;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Stack(
        children: [
          Column(
            children: [
              Obx(
                () => Container(
                  width: double.infinity,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // AI Advice Button
                        Obx(
                          () => GestureDetector(
                            onTap: controller.isLoadingAdvice.value
                                ? null
                                : () => controller.getAdviceFromAI(),
                            child: Container(
                              decoration: BoxDecoration(
                                color: AppColor.primary,
                                borderRadius: BorderRadius.circular(0.018 * size.width),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              padding: EdgeInsets.symmetric(
                                horizontal: 0.015 * size.width,
                                vertical: 0.012 * size.height,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (controller.isLoadingAdvice.value)
                                    SizedBox(
                                      width: 0.012 * size.width,
                                      height: 0.012 * size.width,
                                      child: const CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                      ),
                                    )
                                  else
                                    Icon(
                                      Icons.psychology,
                                      color: Colors.white,
                                      size: 0.018 * size.width,
                                    ),
                                  SizedBox(width: 0.006 * size.width),
                                  RegularText(
                                    'Lời khuyên từ AI',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                      fontSize: Fontsize.smallest,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        SizedBox(width: 0.02 * size.width),

                        // Navigation tabs - wrapped in flexible container
                        Row(
                          children: List.generate(
                            controller.navBar.length,
                            (index) => Container(
                              margin: EdgeInsets.only(
                                right: index < controller.navBar.length - 1
                                    ? 0.01 * size.width
                                    : 0
                              ),
                              child: GestureDetector(
                                onTap: () {
                                  controller.onChooseFeature(index);
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: controller.navBar[index].value.isActive
                                        ? AppColor.red
                                        : Colors.white,
                                    borderRadius:
                                        BorderRadius.circular(0.018 * size.width),
                                  ),
                                  constraints: BoxConstraints(
                                    minWidth: 0.08 * size.width,
                                    maxWidth: 0.12 * size.width,
                                  ),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 0.015 * size.width,
                                    vertical: 0.015 * size.height,
                                  ),
                                  child: Center(
                                    child: RegularText(
                                      controller.navBar[index].value.title,
                                      data: const {"week": ""},
                                      maxLines: 1,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: controller.navBar[index].value.isActive
                                            ? Colors.white
                                            : AppColor.gray,
                                        fontWeight: FontWeight.w700,
                                        fontSize: Fontsize.smallest,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 0.03 * size.height),
              Expanded(
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(0.04 * size.height),
                    color: Colors.white,
                  ),
                  padding: EdgeInsets.only(
                    top: 0.015 * size.height,
                    bottom: 0.015 * size.height,
                    left: 0.015 * size.width,
                    right: 0.015 * size.width,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 0.5 * size.width,
                        height: 0.12 * size.height,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                RegularText(
                                  'back'.tr,
                                  style: TextStyle(
                                      fontSize: Fontsize.smaller,
                                      color: AppColor.blue),
                                ),
                                SizedBox(
                                  width: size.height * 0.01,
                                ),
                                ImageButton(
                                  pathImage: LocalImage.backAcc,
                                  onTap: () {
                                    controller.onChangeDay(type: TypeFunc.prev);
                                  },
                                  semantics: 'back',
                                  width: 0.05 * size.width,
                                  height: 0.05 * size.width,
                                ),
                              ],
                            ),
                            SizedBox(
                              width: 0.01 * size.width,
                            ),
                            Container(
                              width: 0.2 * size.width,
                              height: 0.08 * size.height,
                              decoration: const BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage(
                                    LocalImage.shapeName,
                                  ),
                                  fit: BoxFit.fill,
                                ),
                              ),
                              child: Padding(
                                padding: EdgeInsets.only(
                                    top: controller.indexActive == 2
                                        ? 0.015 * size.height
                                        : 0.015 * size.height),
                                child: Obx(
                                  () => RichText(
                                    textAlign: TextAlign.center,
                                    text: TextSpan(
                                      text: controller.indexActive == 0 &&
                                              controller.isShowThis.value
                                          ? "this_week".tr
                                          : controller.indexActive == 1 &&
                                                  controller.isShowThis.value
                                              ? "this_month".tr
                                              : controller.indexActive == 2
                                                  ? "num_of_year".trParams({
                                                      "year": controller
                                                          .currentDate.year
                                                          .toString()
                                                    })
                                                  : '',
                                      style: TextStyle(
                                        color: AppColor.blue,
                                        fontSize: controller.indexActive == 2
                                            ? Fontsize.normal
                                            : Fontsize.smallest,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'Lato',
                                        height: !controller.isShowThis.value
                                            ? 0.9
                                            : controller.indexActive == 2
                                                ? 0
                                                : 1.1,
                                      ),
                                      children: controller.indexActive == 2
                                          ? []
                                          : <TextSpan>[
                                              TextSpan(
                                                text: "\n${controller.timeSub}",
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize:
                                                      Fontsize.smallest - 1,
                                                ),
                                              )
                                            ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 0.01 * size.width,
                            ),
                            Row(
                              children: [
                                ImageButton(
                                  pathImage: LocalImage.nextAcc,
                                  onTap: () {
                                    controller.onChangeDay(type: TypeFunc.next);
                                  },
                                  semantics: 'next',
                                  width: 0.05 * size.width,
                                  height: 0.05 * size.width,
                                ),
                                RegularText(
                                  'next'.tr,
                                  style: TextStyle(
                                      fontSize: Fontsize.smaller,
                                      color: AppColor.blue),
                                ),
                                SizedBox(
                                  width: size.height * 0.01,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Obx(
                        () => controller.isLoading.value
                            ? Container(
                                width: 0.5 * size.height,
                                height: 0.38 * size.height,
                                padding: EdgeInsets.all(0.02 * size.height),
                                child: const Center(
                                  child: LoadingIndicator(
                                    indicatorType:
                                        Indicator.ballClipRotateMultiple,
                                    colors: [AppColor.primary],
                                  ),
                                ))
                            : SizedBox(
                                height: 0.38 * size.height,
                                child: BarChartTime(controller: controller),
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ContentLeft extends StatelessWidget {
  const ContentLeft({
    super.key,
    required this.size,
    required this.controller,
  });

  final Size size;
  final ReportController controller;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 0.23 * size.width,
      height: double.infinity,
      child: RawScrollbar(
        thumbColor: Colors.transparent,
        trackColor: Colors.transparent,
        radius: Radius.circular(0.008 * 2 * size.width),
        thumbVisibility: true,
        thickness: 0.008 * size.width,
        interactive: true,
        padding: EdgeInsets.only(
          top: 0.03 * size.height,
          bottom: 0.01 * size.height,
          right: 0 * size.width,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Obx(
                () => ItemContentLeft(
                  size: size,
                  title: "num_of_lesson_learned",
                  sub: "lesson",
                  image: LocalImage.reportBook,
                  number: controller.totalReaded.value,
                ),
              ),
              SizedBox(height: 0.02 * size.height),
              Obx(
                () => ItemContentLeft(
                  size: size,
                  title: "average_time_per_day",
                  sub: "minute",
                  image: LocalImage.reportSandclock,
                  number: (controller.averageTime / 60).ceil(),
                ),
              ),
              SizedBox(height: 0.02 * size.height),
              Obx(
                () => ItemContentLeft(
                  size: size,
                  title: "total_time",
                  sub: "minute",
                  image: LocalImage.reportClock,
                  number: (controller.totalTime / 60).ceil(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ItemContentLeft extends StatelessWidget {
  const ItemContentLeft({
    super.key,
    required this.size,
    required this.title,
    required this.sub,
    required this.image,
    required this.number,
  });

  final Size size;
  final String title;
  final String sub;
  final String image;
  final int number;

  @override
  Widget build(BuildContext context) {
    final String tmp = sub.tr;
    return Container(
      width: double.infinity,
      height: 0.2 * size.height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(0.04 * size.height),
        color: Colors.white,
      ),
      padding: EdgeInsets.only(
        top: 0.015 * size.height,
        bottom: 0.015 * size.height,
        left: 0.015 * size.width,
        right: 0.015 * size.width,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: 0.2 * size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RegularText(
                  title,
                  maxLines: 2,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    height: 0.9,
                    color: AppColor.gray,
                    fontSize: Fontsize.smallest,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    NumberToImage(size: size, number: number, unit: ""),
                    SizedBox(width: 0.02 * size.height),
                    RegularText(
                      tmp.toLowerCase(),
                      maxLines: 1,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: AppColor.red,
                        fontSize: Fontsize.smaller,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const Expanded(child: SizedBox()),
                    ImageButton(
                        pathImage: image,
                        onTap: () {},
                        width: 0.03 * size.width,
                        height: 0.03 * size.width)
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class NumberToImage extends StatelessWidget {
  const NumberToImage({
    super.key,
    required this.size,
    required this.number,
    required this.unit,
  });

  final Size size;
  final int number;
  final String unit;

  @override
  Widget build(BuildContext context) {
    final List<String> numbers = number.toString().split('');
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        ...List.generate(
          numbers.length,
          (index) => Image.asset(
            'assets/images/number_${int.parse(numbers[index])}.png',
            width: 0.08 * size.height,
            height: 0.1 * size.height,
          ),
        ),
        RegularText(
          unit,
          style: TextStyle(
            color: AppColor.gray,
            fontSize: Fontsize.small,
            fontWeight: FontWeight.w700,
          ),
        )
      ],
    );
  }
}
