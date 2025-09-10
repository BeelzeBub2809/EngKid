// ignore_for_file: use_named_constants

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:EngKid/domain/core/entities/entities.dart';
import 'package:EngKid/utils/app_color.dart';
import 'package:EngKid/utils/font_size.dart';
import 'package:EngKid/utils/images.dart';
import 'package:EngKid/utils/lib_function.dart';
import 'package:EngKid/widgets/loading/loading_dialog.dart';
import 'package:EngKid/widgets/text/image_text.dart';
import 'package:EngKid/widgets/text/regular_text.dart';
import 'week_controller.dart';
import 'package:EngKid/presentation/management_space/star_report/line_painter/line_painter.dart';

class WeekScreen extends GetView<WeekController> {
  const WeekScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final heightChart = 0.15 * size.height;
    return Container(
      width: 0.65 * size.width,
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
            ? const LoadingDialog()
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
                  child: Column(children: [
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
                                    style:
                                        const TextStyle(color: AppColor.yellow))
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    ...List.generate(
                      2,
                      (index) {
                        final List<DayOf> daysOf = index == 0
                            ? controller.daysOfThisWeek
                            : controller.daysOfLastWeek;
                        final double maxY = (index == 0
                                ? controller.maxYThisWeek
                                : controller.maxYLastWeek) +
                            2; // giảm padding để biểu đồ hiển thị tốt hơn // thay đổi số để chart không bị tràn

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
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            index == 0
                                                ? 'this_week'.tr
                                                : 'last_week'.tr,
                                            style: TextStyle(
                                              fontSize: Fontsize.smallest,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                          Text(
                                            index == 0
                                                ? controller.curWeek
                                                : controller.preWeek,
                                            style: TextStyle(
                                              fontSize: Fontsize.smallest - 2,
                                              fontWeight: FontWeight.w600,
                                              color: AppColor.gray,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Container(
                                        width: LibFunction.scaleForCurrentValue(
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
                                                  "${index == 0 ? controller.totalThisWeek.ceil() : controller.totalLastWeek.ceil()} ",
                                              style: TextStyle(
                                                color: AppColor.yellow,
                                                fontSize: Fontsize.smallest - 1,
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
                                      SizedBox(
                                        height: heightChart,
                                        width: 0.65 * size.width,
                                        child: CustomPaint(
                                          size: const Size(
                                              double.infinity, double.infinity),
                                          painter: LinePainter(
                                            daysOf: daysOf,
                                            height: size.height,
                                            width: size.width,
                                            heightChart: heightChart,
                                            maxStarOfWeek: maxY,
                                          ),
                                        ),
                                      ),
                                      ...List.generate(
                                        daysOf.length,
                                        (idx) => Positioned.fill(
                                          top: heightChart -
                                              ((heightChart / maxY) *
                                                  daysOf[idx].value) -
                                              0.005 * size.width +
                                              0.1 * heightChart,
                                          left: daysOf[idx].left * size.width +
                                              0.02 * size.width -
                                              0.005 * size.width,
                                          child: Align(
                                            alignment: Alignment.topLeft,
                                            child: Image.asset(
                                              LocalImage.starLineChart,
                                              width: 0.01 * size.width,
                                              height: 0.01 * size.width,
                                            ),
                                          ),
                                        ),
                                      ),
                                      ...List.generate(
                                        daysOf.length,
                                        (idx) {
                                          // Tìm giá trị cao nhất để highlight
                                          final isMaxValue = daysOf[idx]
                                                  .value ==
                                              daysOf
                                                  .map((day) => day.value)
                                                  .reduce(
                                                      (a, b) => a > b ? a : b);

                                          final double pointY = heightChart -
                                              ((heightChart / maxY) *
                                                  daysOf[idx].value);
                                          final bool isNearTop =
                                              pointY < 0.08 * size.height;

                                          return Positioned.fill(
                                            top: isNearTop
                                                ? pointY + 0.02 * size.height
                                                : pointY - 0.062 * size.height,
                                            left:
                                                daysOf[idx].left * size.width +
                                                    0.02 * size.width -
                                                    0.015 * size.width,
                                            child: Align(
                                              alignment: Alignment.topLeft,
                                              child: Stack(
                                                children: [
                                                  Padding(
                                                    padding: EdgeInsets.all(
                                                        0.005 * size.width),
                                                    child: RegularText(
                                                      daysOf[idx]
                                                          .value
                                                          .toStringAsFixed(1),
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
                                                            : Fontsize.smallest,
                                                      ),
                                                    ),
                                                  ),
                                                  Positioned.fill(
                                                    child: Align(
                                                      alignment:
                                                          Alignment.topRight,
                                                      child: Image.asset(
                                                        LocalImage.hightLight,
                                                        width:
                                                            0.012 * size.width,
                                                        height:
                                                            0.012 * size.width,
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
                                  Stack(
                                    children: [
                                      SizedBox(
                                        height: 0.07 * size.height,
                                        width: 0.65 * size.width,
                                      ),
                                      ...List.generate(
                                        daysOf.length,
                                        (idx) => Positioned.fill(
                                          bottom: 0,
                                          left: daysOf[idx].left * size.width,
                                          child: Align(
                                            alignment: Alignment.bottomLeft,
                                            child: ImageText(
                                              onTap: () {},
                                              text: daysOf[idx].text,
                                              maxLines: 1,
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontStyle: FontStyle.italic,
                                                fontSize: Fontsize.smaller,
                                              ),
                                              pathImage: LocalImage.calendar,
                                              width: 0.05 * size.width,
                                              height: 0.07 * size.height,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 0.02 * size.height),
                          ],
                        );
                      },
                    ),
                  ]),
                ),
              ),
      ),
    );
  }
}
