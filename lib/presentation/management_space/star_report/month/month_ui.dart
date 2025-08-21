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
import 'month_controller.dart';

class MonthScreen extends GetView<MonthController> {
  const MonthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final widthChart = 0.33 * size.width;
    final heightChart = 0.35 * size.height;
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
                                        "stars": controller.total.value
                                            .ceil()
                                            .toString()
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
                          final double maxY = (index == 0
                                  ? controller.maxYThisMonth
                                  : controller.maxYLastMonth) +
                              2; // giảm padding để biểu đồ hiển thị tốt hơn
                          final List<DayOf> weeksOf = index == 0
                              ? controller.weeksOfThisMonth
                              : controller.weeksOfLastMonth;
                          return Column(
                            children: [
                              Container(
                                padding: EdgeInsets.all(0.01 * size.height),
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.circular(0.02 * size.height),
                                  color: const Color(0XFFe0e7fd),
                                ),
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
                                            Text(
                                              index == 0
                                                  ? 'this_month'.tr
                                                  : 'last_month'.tr,
                                              style: TextStyle(
                                                fontSize: Fontsize.smallest,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                            Text(
                                              '(${index == 0 ? controller.curMonth : controller.preMonth})',
                                              style: TextStyle(
                                                fontSize: Fontsize.smallest - 2,
                                                fontWeight: FontWeight.w600,
                                                color: AppColor.gray,
                                              ),
                                            ),
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
                                            right: 0.01 * size.width,
                                          ),
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
                                                    "${index == 0 ? controller.totalThisMonth.value.ceil() : controller.totalLastMonth.value.ceil()} ",
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
                                              child: BarCharStar(
                                                maxY: maxY,
                                                data: index == 0
                                                    ? weeksOf
                                                    : weeksOf,
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
                                          width: 0.32 * size.width,
                                          child: CustomPaint(
                                            size: const Size(double.infinity,
                                                double.infinity),
                                            painter: LinePainter(
                                              daysOf: weeksOf,
                                              height: size.height,
                                              width: size.width,
                                              heightChart: heightChart,
                                              maxStarOfWeek: maxY,
                                            ),
                                          ),
                                        ),
                                        ...List.generate(
                                          weeksOf.length,
                                          (idx) => Positioned.fill(
                                            top: heightChart -
                                                ((heightChart / maxY) *
                                                        weeksOf[idx].value +
                                                    0.008 * size.width),
                                            left:
                                                weeksOf[idx].left * size.width +
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
                                          weeksOf.length,
                                          (idx) => Positioned.fill(
                                            top: heightChart -
                                                ((heightChart / maxY) *
                                                    weeksOf[idx].value) -
                                                0.07 * size.height,
                                            left:
                                                weeksOf[idx].left * size.width -
                                                    0.016 * size.width,
                                            child: Align(
                                              alignment: Alignment.topLeft,
                                              child: Stack(
                                                children: [
                                                  Container(
                                                    padding: EdgeInsets.only(
                                                      top: 0.015 * size.height,
                                                    ),
                                                    width: widthChart / 4.5,
                                                    child: RegularText(
                                                      weeksOf[idx]
                                                          .value
                                                          .toString(),
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        color: AppColor.red,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        fontSize:
                                                            Fontsize.smallest,
                                                      ),
                                                    ),
                                                  ),
                                                  Positioned.fill(
                                                    right: 0.01 * size.width,
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
                                          ),
                                        ),
                                      ],
                                    ),
                                    Center(
                                      child: SizedBox(
                                        width: widthChart,
                                        height: 0.08 * size.height,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: List.generate(
                                            weeksOf.length,
                                            (idx) => SizedBox(
                                              width: widthChart / 4.5,
                                              height: 0.08 * size.height,
                                              child: Center(
                                                child: RichText(
                                                  textAlign: TextAlign.center,
                                                  text: TextSpan(
                                                    text: weeksOf[idx].text.tr,
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Colors.black,
                                                        fontSize:
                                                            Fontsize.small),
                                                    children: <TextSpan>[
                                                      TextSpan(
                                                        text: weeksOf[idx]
                                                            .subText,
                                                        style: TextStyle(
                                                          color: AppColor.gray,
                                                          fontSize:
                                                              Fontsize.smallest,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                        ),
                                                      )
                                                    ],
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
