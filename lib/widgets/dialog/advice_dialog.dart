import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:EngKid/domain/core/entities/advice/advice_response.dart';
import 'package:EngKid/utils/app_color.dart';
import 'package:EngKid/utils/font_size.dart';
import 'package:EngKid/widgets/text/regular_text.dart';
import 'package:EngKid/widgets/button/image_button.dart';
import 'package:EngKid/utils/images.dart';

class AdviceDialog extends StatelessWidget {
  final AdviceData adviceData;

  const AdviceDialog({
    super.key,
    required this.adviceData,
  });

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: 0.8 * size.width,
        height: 0.7 * size.height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(0.04 * size.height),
        ),
        padding: EdgeInsets.all(0.03 * size.height),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: RegularText(
                    'Lời khuyên từ AI',
                    style: TextStyle(
                      fontSize: Fontsize.large,
                      fontWeight: FontWeight.bold,
                      color: AppColor.primary,
                    ),
                  ),
                ),
                ImageButton(
                  pathImage: LocalImage.buttonClose,
                  onTap: () => Get.back(),
                  width: 0.04 * size.width,
                  height: 0.04 * size.width,
                ),
              ],
            ),
            SizedBox(height: 0.02 * size.height),

            // Student info
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(0.02 * size.height),
              decoration: BoxDecoration(
                color: AppColor.lightBlue,
                borderRadius: BorderRadius.circular(0.02 * size.height),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RegularText(
                    'Tên học sinh: ${adviceData.studentName}',
                    style: TextStyle(
                      fontSize: Fontsize.normal,
                      fontWeight: FontWeight.w600,
                      color: AppColor.darkBlue,
                    ),
                  ),
                  SizedBox(height: 0.01 * size.height),
                  RegularText(
                    'Thời gian: ${_getPeriodText(adviceData.period)}',
                    style: TextStyle(
                      fontSize: Fontsize.smaller,
                      color: AppColor.gray,
                    ),
                  ),
                  RegularText(
                    'Khoảng thời gian: ${adviceData.startDate} - ${adviceData.endDate}',
                    style: TextStyle(
                      fontSize: Fontsize.smaller,
                      color: AppColor.gray,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 0.02 * size.height),

            // Advice content
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RegularText(
                      'Nội dung lời khuyên',
                      style: TextStyle(
                        fontSize: Fontsize.normal,
                        fontWeight: FontWeight.bold,
                        color: AppColor.primary,
                      ),
                    ),
                    SizedBox(height: 0.01 * size.height),
                    Container(
                      width: double.infinity,
                      constraints: BoxConstraints(
                        minHeight: 0.15 * size.height,
                        maxHeight: 0.3 * size.height, // Giới hạn chiều cao tối đa
                      ),
                      padding: EdgeInsets.all(0.02 * size.height),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8F9FA),
                        borderRadius: BorderRadius.circular(0.02 * size.height),
                        border: Border.all(color: AppColor.lightGray),
                      ),
                      child: SingleChildScrollView(
                        child: Text(
                          adviceData.advice,
                          style: TextStyle(
                            fontSize: Fontsize.smaller,
                            color: AppColor.darkGray,
                            height: 1.4,
                            fontFamily: 'Lato',
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 0.02 * size.height),

                    // Learning Summary
                    RegularText(
                      'Tóm tắt học tập',
                      style: TextStyle(
                        fontSize: Fontsize.normal,
                        fontWeight: FontWeight.bold,
                        color: AppColor.primary,
                      ),
                    ),
                    SizedBox(height: 0.01 * size.height),
                    _buildSummaryCard(size),
                    SizedBox(height: 0.02 * size.height),

                    // Class Comparison
                    RegularText(
                      'So sánh với lớp',
                      style: TextStyle(
                        fontSize: Fontsize.normal,
                        fontWeight: FontWeight.bold,
                        color: AppColor.primary,
                      ),
                    ),
                    SizedBox(height: 0.01 * size.height),
                    _buildComparisonCard(size),
                    SizedBox(height: 0.04 * size.height), // Thêm padding bottom
                  ],
                ),
              ),
            ),

            // Close button
            SizedBox(height: 0.02 * size.height),
            Center(
              child: GestureDetector(
                onTap: () => Get.back(),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 0.06 * size.width,
                    vertical: 0.015 * size.height,
                  ),
                  decoration: BoxDecoration(
                    color: AppColor.primary,
                    borderRadius: BorderRadius.circular(0.02 * size.height),
                  ),
                  child: RegularText(
                    'Đóng',
                    style: TextStyle(
                      fontSize: Fontsize.normal,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard(Size size) {
    final summary = adviceData.learningSummary;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(0.02 * size.height),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(0.02 * size.height),
        border: Border.all(color: AppColor.lightGray),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildSummaryItem(
                  'Tổng số bài đọc',
                  summary.totalReadings.toString(),
                  size,
                ),
              ),
              Expanded(
                child: _buildSummaryItem(
                  'Bài đã hoàn thành',
                  summary.completedReadings.toString(),
                  size,
                ),
              ),
            ],
          ),
          SizedBox(height: 0.01 * size.height),
          Row(
            children: [
              Expanded(
                child: _buildSummaryItem(
                  'Điểm trung bình',
                  '${summary.averageScore}/10',
                  size,
                ),
              ),
              Expanded(
                child: _buildSummaryItem(
                  'Tỷ lệ hoàn thành',
                  '${summary.completionRate}%',
                  size,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildComparisonCard(Size size) {
    final comparison = adviceData.classComparison;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(0.02 * size.height),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(0.02 * size.height),
        border: Border.all(color: AppColor.lightGray),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildSummaryItem(
                  'Thứ hạng lớp',
                  '${comparison.classRank}/${comparison.totalClassmates}',
                  size,
                ),
              ),
              Expanded(
                child: _buildSummaryItem(
                  'Điểm TB lớp',
                  comparison.classAverage.toString(),
                  size,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(String title, String value, Size size) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RegularText(
          title,
          style: TextStyle(
            fontSize: Fontsize.smallest,
            color: AppColor.gray,
          ),
        ),
        SizedBox(height: 0.005 * size.height),
        RegularText(
          value,
          style: TextStyle(
            fontSize: Fontsize.smaller,
            fontWeight: FontWeight.bold,
            color: AppColor.darkBlue,
          ),
        ),
      ],
    );
  }

  String _getPeriodText(String period) {
    switch (period.toLowerCase()) {
      case 'week':
        return 'Hàng tuần';
      case 'month':
        return 'Hàng tháng';
      case 'year':
        return 'Hàng năm';
      default:
        return period;
    }
  }
}