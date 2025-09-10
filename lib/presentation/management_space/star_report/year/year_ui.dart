// ignore_for_file: use_named_constants

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:EngKid/domain/core/entities/entities.dart';
import 'package:EngKid/utils/app_color.dart';
import 'package:EngKid/utils/font_size.dart';
import 'package:EngKid/utils/images.dart';
import 'package:EngKid/utils/lib_function.dart';
import 'package:EngKid/widgets/loading/loading_dialog.dart';
import 'package:EngKid/widgets/text/regular_text.dart';
import 'package:EngKid/presentation/management_space/star_report/line_painter/line_painter.dart';

import 'bar_chart.dart';
import 'year_controller.dart';

class YearScreen extends GetView<YearController> {
  const YearScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final heightChart = 0.35 * size.height;
    final widthChart = 0.65 * size.width;
    return Container(
      width: widthChart,
      height: 0.6 * size.height,
      padding: EdgeInsets.symmetric(horizontal: 0.03 * size.width),
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(LocalImage.surveyQuizShape),
          fit: BoxFit.fill,
        ),
      ),
      child: Obx(
        () => controller.isLoading.value
            ? const Center(child: LoadingDialog())
            : RawScrollbar(
                thumbColor: AppColor.yellow,
                trackColor: AppColor.gray,
                thumbVisibility: true,
                thickness: 0.008 * size.width,
                interactive: true,
                padding: EdgeInsets.only(
                  top: 0.03 * size.height,
                  bottom: 0.01 * size.height,
                  right: -0.02 * size.width,
                ),
                radius: Radius.circular(0.008 * 2 * size.width),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Center(
                        child: Container(
                          width: LibFunction.scaleForCurrentValue(
                            size,
                            600,
                            desire: 0,
                          ),
                          height: LibFunction.scaleForCurrentValue(
                            size,
                            108,
                            desire: 1,
                          ),
                          padding: EdgeInsets.only(left: 0.08 * size.width),
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(LocalImage.shapeStarBoardTotal),
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: RichText(
                              text: TextSpan(
                                text: "star_total".tr,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: Fontsize.smallest + 1,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Lato',
                                  height: 0.9,
                                ),
                                children: <TextSpan>[
                                  TextSpan(
                                      text: "num_of_star".trParams({
                                        "stars":
                                            controller.total.ceil().toString()
                                      }),
                                      style: const TextStyle(
                                          color: AppColor.yellow))
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      ...List.generate(
                        2,
                        (index) {
                          final List<DayOf> monthsOf = index == 0
                              ? controller.monthsOfThisYear
                              : controller.monthsOfLastYear;
                          final double maxY = (index == 0
                                  ? controller.maxYThisYear
                                  : controller.maxYLastYear) +
                              2; // giảm padding để biểu đồ hiển thị tốt hơn
                          return Column(
                            children: [
                              Container(
                                padding: EdgeInsets.all(0.01 * size.height),
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.circular(0.02 * size.height),
                                  color: const Color(0XFFe0e7fd),
                                ),
                                // child: const LineChartStar(),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            RegularText(
                                              'num_of_year',
                                              data: {
                                                "year": index == 0
                                                    ? controller.curYear
                                                    : controller.preYear
                                              },
                                              style: TextStyle(
                                                fontSize: Fontsize.smallest,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            )
                                          ],
                                        ),
                                        Container(
                                          width:
                                              LibFunction.scaleForCurrentValue(
                                            size,
                                            240,
                                            desire: 0,
                                          ),
                                          height:
                                              LibFunction.scaleForCurrentValue(
                                            size,
                                            80,
                                            desire: 0,
                                          ),
                                          padding: EdgeInsets.only(
                                              top: 0.01 * size.height,
                                              right: 0.01 * size.width),
                                          decoration: const BoxDecoration(
                                            image: DecorationImage(
                                              image: AssetImage(
                                                LocalImage.totalStar,
                                              ),
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                          child: Align(
                                            alignment: Alignment.centerRight,
                                            child: RichText(
                                              text: TextSpan(
                                                text:
                                                    "${index == 0 ? controller.totalThisYear.ceil() : controller.totalLastYear.ceil()} ",
                                                style: TextStyle(
                                                  color: AppColor.yellow,
                                                  fontSize:
                                                      Fontsize.smallest - 1,
                                                  fontWeight: FontWeight.w600,
                                                  fontFamily: 'Lato',
                                                ),
                                                children: <TextSpan>[
                                                  TextSpan(
                                                    text: "star".tr,
                                                    style: const TextStyle(
                                                        color: Colors.black),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Stack(
                                      children: [
                                        Positioned.fill(
                                          bottom: -0.03 * size.height,
                                          child: Align(
                                            alignment: Alignment.bottomCenter,
                                            child: SizedBox(
                                              height: heightChart,
                                              width: widthChart,
                                              child: BarChartStar(
                                                data: monthsOf,
                                                maxY: maxY,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          decoration: const BoxDecoration(
                                            border: Border(
                                              bottom: BorderSide(
                                                //                   <--- left side
                                                color: Colors.black,
                                                width: 0.6,
                                              ),
                                            ),
                                          ),
                                          height: heightChart,
                                          width: widthChart,
                                          child: CustomPaint(
                                            size: const Size(double.infinity,
                                                double.infinity),
                                            painter: LinePainter(
                                                daysOf: monthsOf,
                                                height: size.height,
                                                width: size.width,
                                                heightChart: heightChart,
                                                maxStarOfWeek: maxY),
                                          ),
                                        ),
                                        ...List.generate(
                                          monthsOf.length,
                                          (idx) => Positioned.fill(
                                            top: heightChart -
                                                ((heightChart / maxY) *
                                                        monthsOf[idx].value +
                                                    0.008 * size.width),
                                            left: monthsOf[idx].left *
                                                    size.width +
                                                0.02 * size.width -
                                                0.005 * size.width,
                                            child: Align(
                                              alignment: Alignment.topLeft,
                                              child: Image.asset(
                                                LocalImage.starLineChart,
                                                width: 0.015 * size.width,
                                                height: 0.015 * size.width,
                                              ),
                                            ),
                                          ),
                                        ),
                                        ...List.generate(
                                          monthsOf.length,
                                          (idx) {
                                            // Tìm giá trị cao nhất để highlight
                                            final isMaxValue = monthsOf[idx]
                                                    .value ==
                                                monthsOf
                                                    .map((month) => month.value)
                                                    .reduce((a, b) =>
                                                        a > b ? a : b);

                                            final double pointY = heightChart -
                                                ((heightChart / maxY) *
                                                    monthsOf[idx].value);
                                            final bool isNearTop =
                                                pointY < 0.08 * size.height;

                                            return Positioned.fill(
                                              top: isNearTop
                                                  ? pointY + 0.02 * size.height
                                                  : pointY - 0.07 * size.height,
                                              left: monthsOf[idx].left *
                                                  size.width,
                                              child: Align(
                                                alignment: Alignment.topLeft,
                                                child: Stack(
                                                  children: [
                                                    Container(
                                                      padding: EdgeInsets.only(
                                                          top: 0.02 *
                                                              size.height),
                                                      width: widthChart / 14,
                                                      child: Text(
                                                        monthsOf[idx]
                                                            .value
                                                            .toStringAsFixed(1),
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                          color: isMaxValue
                                                              ? AppColor.blue
                                                              : AppColor.red,
                                                          fontWeight: isMaxValue
                                                              ? FontWeight.w900
                                                              : FontWeight.w700,
                                                          fontSize: isMaxValue
                                                              ? Fontsize
                                                                      .smallest +
                                                                  1
                                                              : Fontsize
                                                                  .smallest,
                                                        ),
                                                      ),
                                                    ),
                                                    Positioned.fill(
                                                      child: Align(
                                                        alignment:
                                                            Alignment.topRight,
                                                        child: Image.asset(
                                                          LocalImage.hightLight,
                                                          width: 0.012 *
                                                              size.width,
                                                          height: 0.012 *
                                                              size.width,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: List.generate(
                                        monthsOf.length,
                                        (idx) => SizedBox(
                                          width: widthChart / 14,
                                          height: 0.04 * size.height,
                                          child: Center(
                                            child: RichText(
                                              textAlign: TextAlign.center,
                                              text: TextSpan(
                                                text: monthsOf[idx].text.tr,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w400,
                                                    color: Colors.black,
                                                    fontSize:
                                                        Fontsize.smallest - 3),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 0.02 * size.height),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
