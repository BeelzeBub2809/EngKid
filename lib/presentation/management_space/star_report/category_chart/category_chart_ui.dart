// ignore_for_file: use_named_constants

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:EngKid/utils/app_color.dart';
import 'package:EngKid/utils/font_size.dart';
import 'package:EngKid/utils/images.dart';
import 'package:EngKid/utils/lib_function.dart';
import 'package:EngKid/widgets/loading/loading_dialog.dart';
import 'package:EngKid/widgets/text/image_text.dart';
import 'package:EngKid/widgets/text/regular_text.dart';
import 'category_chart_controller.dart';
import 'category_line_painter.dart';

class CategoryChartUI extends GetView<CategoryChartController> {
  const CategoryChartUI({super.key});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final heightChart = 0.2 * size.height;

    // Handle case when controller is not ready
    if (!Get.isRegistered<CategoryChartController>()) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 0.03 * size.width),
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(LocalImage.surveyQuizShape),
            fit: BoxFit.fill,
          ),
        ),
        child: const Center(child: LoadingDialog()),
      );
    }

    return Container(
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
            : controller.learningPathStars.value == null
                ? Center(
                    child: RegularText(
                      'No data available',
                      style: TextStyle(
                        fontSize: Fontsize.normal,
                        color: AppColor.gray,
                      ),
                    ),
                  )
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
                          // Total stars header
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
                                  image: AssetImage(
                                      LocalImage.shapeStarBoardTotal),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Obx(
                                  () => RichText(
                                    text: TextSpan(
                                      text: "Total Stars: ",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: Fontsize.smallest + 1,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'Lato',
                                        height: 0.9,
                                      ),
                                      children: <TextSpan>[
                                        TextSpan(
                                          text: controller.learningPathStars
                                                  .value?.totalStars
                                                  .toString() ??
                                              '0',
                                          style: const TextStyle(
                                              color: AppColor.yellow),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),

                          SizedBox(height: 0.02 * size.height),

                          // Categories chart
                          Container(
                            padding: EdgeInsets.all(0.02 * size.height),
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.circular(0.02 * size.height),
                              color: const Color(0XFFe0e7fd),
                            ),
                            child: Column(
                              children: [
                                // Chart header
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Categories Progress',
                                          style: TextStyle(
                                            fontSize: Fontsize.small,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        Obx(
                                          () => Text(
                                            '${controller.learningPathStars.value?.completedItems ?? 0}/${controller.learningPathStars.value?.totalItems ?? 0} items completed',
                                            style: TextStyle(
                                              fontSize: Fontsize.smallest - 2,
                                              fontWeight: FontWeight.w600,
                                              color: AppColor.gray,
                                            ),
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
                                      height: LibFunction.scaleForCurrentValue(
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
                                          image:
                                              AssetImage(LocalImage.totalStar),
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                      child: Align(
                                        alignment: Alignment.centerRight,
                                        child: Obx(
                                          () => RichText(
                                            text: TextSpan(
                                              text:
                                                  "${controller.learningPathStars.value?.totalStars ?? 0} ",
                                              style: TextStyle(
                                                color: AppColor.yellow,
                                                fontSize: Fontsize.smallest - 1,
                                                fontWeight: FontWeight.w600,
                                                fontFamily: 'Lato',
                                              ),
                                              children: const <TextSpan>[
                                                TextSpan(
                                                  text: "stars",
                                                  style: TextStyle(
                                                      color: Colors.black),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                                SizedBox(height: 0.02 * size.height),

                                // Horizontal scrollable chart
                                Obx(
                                  () => controller.categoriesData.isEmpty
                                      ? Container(
                                          height: heightChart,
                                          child: Center(
                                            child: RegularText(
                                              'No categories found',
                                              style: TextStyle(
                                                fontSize: Fontsize.normal,
                                                color: AppColor.gray,
                                              ),
                                            ),
                                          ),
                                        )
                                      : SizedBox(
                                          height: heightChart +
                                              0.1 *
                                                  size.height, // Extra space for labels
                                          child: SingleChildScrollView(
                                            scrollDirection: Axis.horizontal,
                                            child: SizedBox(
                                              width: controller
                                                      .needsHorizontalScroll
                                                  ? controller.totalChartWidth *
                                                      size.width
                                                  : size.width * 0.8,
                                              child: Stack(
                                                children: [
                                                  // Chart area
                                                  Positioned(
                                                    top: 0,
                                                    left: 0,
                                                    right: 0,
                                                    height: heightChart,
                                                    child: CustomPaint(
                                                      size: Size(
                                                        controller
                                                                .needsHorizontalScroll
                                                            ? controller
                                                                    .totalChartWidth *
                                                                size.width
                                                            : size.width * 0.8,
                                                        heightChart,
                                                      ),
                                                      painter:
                                                          CategoryLinePainter(
                                                        categoriesData:
                                                            controller
                                                                .categoriesData
                                                                .toList(),
                                                        chartWidth: controller
                                                                .needsHorizontalScroll
                                                            ? controller
                                                                    .totalChartWidth *
                                                                size.width
                                                            : size.width * 0.8,
                                                        chartHeight:
                                                            heightChart,
                                                        maxValue: controller
                                                            .maxYValue.value,
                                                      ),
                                                    ),
                                                  ),

                                                  // Star points
                                                  ...controller.categoriesData
                                                      .asMap()
                                                      .entries
                                                      .map(
                                                    (entry) {
                                                      final idx = entry.key;
                                                      final category =
                                                          entry.value;
                                                      final chartWidth = controller
                                                              .needsHorizontalScroll
                                                          ? controller
                                                                  .totalChartWidth *
                                                              size.width
                                                          : size.width * 0.8;

                                                      return Positioned(
                                                        top: category.value == 0
                                                            ? heightChart -
                                                                0.01 *
                                                                    size.width
                                                            : heightChart -
                                                                ((category.value /
                                                                        controller
                                                                            .maxYValue
                                                                            .value) *
                                                                    heightChart) -
                                                                0.01 *
                                                                    size.width,
                                                        left: (idx *
                                                                (chartWidth /
                                                                    controller
                                                                        .categoriesData
                                                                        .length)) +
                                                            (chartWidth /
                                                                controller
                                                                    .categoriesData
                                                                    .length /
                                                                2) -
                                                            0.01 * size.width,
                                                        child: Image.asset(
                                                          LocalImage
                                                              .starLineChart,
                                                          width: 0.015 *
                                                              size.width,
                                                          height: 0.015 *
                                                              size.width,
                                                        ),
                                                      );
                                                    },
                                                  ).toList(),

                                                  // Value labels
                                                  ...controller.categoriesData
                                                      .asMap()
                                                      .entries
                                                      .map(
                                                    (entry) {
                                                      final idx = entry.key;
                                                      final category =
                                                          entry.value;
                                                      final chartWidth = controller
                                                              .needsHorizontalScroll
                                                          ? controller
                                                                  .totalChartWidth *
                                                              size.width
                                                          : size.width * 0.8;

                                                      final double pointY = category
                                                                  .value ==
                                                              0
                                                          ? heightChart
                                                          : heightChart -
                                                              ((category.value /
                                                                      controller
                                                                          .maxYValue
                                                                          .value) *
                                                                  heightChart);
                                                      final bool isNearTop =
                                                          pointY <
                                                              0.08 *
                                                                  size.height;

                                                      return Positioned(
                                                        top: isNearTop
                                                            ? pointY +
                                                                0.02 *
                                                                    size.height
                                                            : pointY -
                                                                0.062 *
                                                                    size.height,
                                                        left: (idx *
                                                                (chartWidth /
                                                                    controller
                                                                        .categoriesData
                                                                        .length)) +
                                                            (chartWidth /
                                                                controller
                                                                    .categoriesData
                                                                    .length /
                                                                2) -
                                                            0.02 * size.width,
                                                        child: Container(
                                                          padding: EdgeInsets
                                                              .all(0.005 *
                                                                  size.width),
                                                          decoration:
                                                              BoxDecoration(
                                                            color: category
                                                                    .isHighlight
                                                                ? AppColor.blue
                                                                    .withOpacity(
                                                                        0.8)
                                                                : AppColor.red
                                                                    .withOpacity(
                                                                        0.8),
                                                            borderRadius: BorderRadius
                                                                .circular(0.01 *
                                                                    size.width),
                                                          ),
                                                          child: RegularText(
                                                            category.value
                                                                .toInt()
                                                                .toString(),
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                              fontSize: Fontsize
                                                                  .smallest,
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  ).toList(),

                                                  // Category labels at bottom
                                                  Positioned(
                                                    bottom: 0,
                                                    left: 0,
                                                    right: 0,
                                                    height: 0.1 * size.height,
                                                    child: Row(
                                                      children: controller
                                                          .categoriesData
                                                          .asMap()
                                                          .entries
                                                          .map(
                                                        (entry) {
                                                          final category =
                                                              entry.value;
                                                          final chartWidth = controller
                                                                  .needsHorizontalScroll
                                                              ? controller
                                                                      .totalChartWidth *
                                                                  size.width
                                                              : size.width *
                                                                  0.8;

                                                          return Container(
                                                            width: chartWidth /
                                                                controller
                                                                    .categoriesData
                                                                    .length,
                                                            child: Center(
                                                              child: ImageText(
                                                                onTap: () {},
                                                                text: category
                                                                    .text,
                                                                maxLines: 2,
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontStyle:
                                                                      FontStyle
                                                                          .italic,
                                                                  fontSize:
                                                                      Fontsize.smallest -
                                                                          2,
                                                                ),
                                                                pathImage:
                                                                    LocalImage
                                                                        .calendar,
                                                                width: 0.08 *
                                                                    size.width,
                                                                height: 0.08 *
                                                                    size.height,
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                      ).toList(),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                ),
                              ],
                            ),
                          ),

                          // SizedBox(height: 0.02 * size.height),

                          // // Statistics summary
                          // Obx(
                          //   () => Container(
                          //     padding: EdgeInsets.all(0.02 * size.height),
                          //     decoration: BoxDecoration(
                          //       borderRadius:
                          //           BorderRadius.circular(0.02 * size.height),
                          //       color: Colors.white.withOpacity(0.8),
                          //     ),
                          //     child: Row(
                          //       mainAxisAlignment:
                          //           MainAxisAlignment.spaceEvenly,
                          //       children: [
                          //         _buildStatItem(
                          //           size,
                          //           'Categories',
                          //           controller.learningPathStars.value
                          //                   ?.categories.length
                          //                   .toString() ??
                          //               '0',
                          //           Icons.category,
                          //           AppColor.blue,
                          //         ),
                          //         _buildStatItem(
                          //           size,
                          //           'Total Items',
                          //           controller
                          //                   .learningPathStars.value?.totalItems
                          //                   .toString() ??
                          //               '0',
                          //           Icons.list_alt,
                          //           AppColor.green,
                          //         ),
                          //         _buildStatItem(
                          //           size,
                          //           'Completed',
                          //           controller.learningPathStars.value
                          //                   ?.completedItems
                          //                   .toString() ??
                          //               '0',
                          //           Icons.check_circle,
                          //           AppColor.yellow,
                          //         ),
                          //       ],
                          //     ),
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  ),
      ),
    );
  }

  Widget _buildStatItem(
      Size size, String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Container(
          width: 0.12 * size.width,
          height: 0.12 * size.width,
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            borderRadius: BorderRadius.circular(0.06 * size.width),
          ),
          child: Icon(
            icon,
            color: color,
            size: 0.06 * size.width,
          ),
        ),
        SizedBox(height: 0.01 * size.height),
        RegularText(
          value,
          style: TextStyle(
            fontSize: Fontsize.normal,
            fontWeight: FontWeight.w800,
            color: color,
          ),
        ),
        RegularText(
          label,
          style: TextStyle(
            fontSize: Fontsize.smallest,
            fontWeight: FontWeight.w600,
            color: AppColor.gray,
          ),
        ),
      ],
    );
  }
}
