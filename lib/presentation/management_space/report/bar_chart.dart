import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:EngKid/presentation/management_space/report/report_controller.dart';
import 'package:EngKid/utils/app_color.dart';
import 'package:EngKid/utils/font_size.dart';
import 'package:EngKid/widgets/text/regular_text.dart';

class BarChartTime extends StatelessWidget {
  const BarChartTime({super.key, required this.controller});

  final ReportController controller;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Obx(
      () => controller.indexActive == 0
          ? AspectRatio(
              aspectRatio: 21 / 9,
              child: BarChart(
                BarChartData(
                  barTouchData: barTouchData,
                  titlesData: titlesData,
                  borderData: borderData,
                  barGroups: barGroupsWeek,
                  gridData: FlGridData(
                    show: false,
                  ),
                  alignment: BarChartAlignment.spaceAround,
                  maxY: controller.maxY + 0.1 * size.height,
                ),
              ),
            )
          : controller.indexActive == 1
              ? AspectRatio(
                  aspectRatio: 18 / 9,
                  child: BarChart(
                    BarChartData(
                      barTouchData: barTouchData,
                      titlesData: titlesData,
                      borderData: borderData,
                      barGroups: barGroupsMonth,
                      gridData: FlGridData(
                        show: false,
                      ),
                      alignment: BarChartAlignment.spaceAround,
                      maxY: controller.maxY + 0.1 * size.height,
                    ),
                  ),
                )
              : controller.indexActive == 2
                  ? AspectRatio(
                      aspectRatio: 23 / 9,
                      child: BarChart(
                        BarChartData(
                          barTouchData: barTouchDataYear,
                          titlesData: titlesData,
                          borderData: borderData,
                          barGroups: barGroupsYear,
                          gridData: FlGridData(
                            show: false,
                          ),
                          alignment: BarChartAlignment.spaceAround,
                          maxY: controller.maxY + 0.1 * size.height,
                        ),
                      ),
                    )
                  : const SizedBox(),
    );
  }

  BarTouchData get barTouchData => BarTouchData(
        enabled: false,
        touchTooltipData: BarTouchTooltipData(
          tooltipBgColor: Colors.transparent,
          tooltipPadding: EdgeInsets.zero,
          tooltipMargin: 0,
          getTooltipItem: (
            BarChartGroupData group,
            int groupIndex,
            BarChartRodData rod,
            int rodIndex,
          ) {
            return BarTooltipItem(
              "${rod.toY.round()}${"m".tr}",
              TextStyle(
                color: AppColor.gray,
                fontSize: Fontsize.smallest - 1,
                fontWeight: FontWeight.w500,
              ),
            );
          },
        ),
      );

  BarTouchData get barTouchDataYear => BarTouchData(
        enabled: false,
        touchTooltipData: BarTouchTooltipData(
          tooltipBgColor: Colors.transparent,
          tooltipPadding: EdgeInsets.zero,
          tooltipMargin: 0,
          getTooltipItem: (
            BarChartGroupData group,
            int groupIndex,
            BarChartRodData rod,
            int rodIndex,
          ) {
            return BarTooltipItem(
              "${rod.toY.round()}${"m".tr}",
              TextStyle(
                color: AppColor.gray,
                fontSize: Fontsize.smallest - 3,
                fontWeight: FontWeight.w500,
              ),
            );
          },
        ),
      );

  Widget getTitles(double value, TitleMeta meta) {
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 6,
      child: Obx(
        () => controller.indexActive == 0
            ? RegularText(
                controller
                    .daysOfWeek[value.ceil() > 6 ? 0 : value.ceil()].text.tr,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: Fontsize.small,
                ),
              )
            : controller.indexActive == 1
                ? RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      text: controller
                          .weeksOfMonth[value.ceil() > 3 ? 0 : value.ceil()]
                          .text
                          .trParams({
                        "week": "${value.ceil() > 3 ? 1 : value.ceil() + 1}"
                      }),
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: Fontsize.small,
                          height: 0.9),
                      children: <TextSpan>[
                        TextSpan(
                          text:
                              "\n${controller.weeksOfMonth[value.ceil() > 3 ? 0 : value.ceil()].subText}",
                          style: TextStyle(
                            color: AppColor.gray,
                            fontSize: Fontsize.smallest,
                          ),
                        )
                      ],
                    ),
                  )
                : Text(
                    controller
                        .monthsOfYear[value.ceil() > 11 ? 0 : value.ceil()]
                        .text
                        .tr,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: Fontsize.smallest - 4,
                    ),
                  ),
      ),
    );
  }

  FlTitlesData get titlesData => FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            getTitlesWidget: getTitles,
          ),
        ),
        // leftTitles: AxisTitles(
        //   sideTitles: SideTitles(showTitles: false),
        // ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 16,
            getTitlesWidget: (double value, TitleMeta meta) {
              // return value.toString();
              if (value == meta.max) {
                return Text(
                  'minute'.tr[0].toUpperCase() +
                      'minute'.tr.substring(1).toLowerCase(),
                  maxLines: 1,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: Fontsize.smallest - 3,
                    fontWeight: FontWeight.w500,
                  ),
                );
              }
              return const Text('');
            },
          ),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      );

  FlBorderData get borderData => FlBorderData(
        show: true,
        border: const Border(
          left: BorderSide(color: AppColor.gray, width: 0.8),
          bottom: BorderSide(color: AppColor.gray, width: 0.8),
        ),
      );

  LinearGradient get _barsGradient => const LinearGradient(
        colors: [
          Color(0XFF3E9DA8),
          Color(0XFF3E9DA8),
        ],
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
      );

  LinearGradient get _barsGradientYellow => const LinearGradient(
        colors: [
          Color(0XFFC48912),
          Color(0XFFC48912),
        ],
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
      );

  List<BarChartGroupData> get barGroupsWeek => List.generate(
        controller.daysOfWeek.length,
        (index) => BarChartGroupData(
          x: index,
          barRods: [
            BarChartRodData(
              toY: controller.daysOfWeek[index].value.toDouble(),
              gradient: controller.daysOfWeek[index].isHighlight
                  ? _barsGradientYellow
                  : _barsGradient,
              width: 30,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(3),
                topRight: Radius.circular(3),
              ),
            )
          ],
          showingTooltipIndicators: [0],
        ),
      );
  List<BarChartGroupData> get barGroupsMonth => List.generate(
        controller.weeksOfMonth.length,
        (index) => BarChartGroupData(
          x: index,
          barRods: [
            BarChartRodData(
              toY: controller.weeksOfMonth[index].value.toDouble(),
              gradient: controller.weeksOfMonth[index].isHighlight
                  ? _barsGradientYellow
                  : _barsGradient,
              width: 38,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(3),
                topRight: Radius.circular(3),
              ),
            )
          ],
          showingTooltipIndicators: [0],
        ),
      );

  List<BarChartGroupData> get barGroupsYear => List.generate(
        controller.monthsOfYear.length,
        (index) => BarChartGroupData(
          x: index,
          barRods: [
            BarChartRodData(
              toY: controller.monthsOfYear[index].value.toDouble(),
              gradient: controller.monthsOfYear[index].isHighlight
                  ? _barsGradientYellow
                  : _barsGradient,
              width: 20,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(3),
                topRight: Radius.circular(3),
              ),
            )
          ],
          showingTooltipIndicators: [0],
        ),
      );
}
