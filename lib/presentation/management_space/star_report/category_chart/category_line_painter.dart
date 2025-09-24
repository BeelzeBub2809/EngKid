import 'package:flutter/material.dart';
import 'package:EngKid/domain/core/entities/entities.dart';
import 'dart:ui' as ui;
import 'package:EngKid/utils/app_color.dart';

class CategoryLinePainter extends CustomPainter {
  final List<DayOf> categoriesData;
  final double chartWidth;
  final double chartHeight;
  final double maxValue;

  CategoryLinePainter({
    required this.categoriesData,
    required this.chartWidth,
    required this.chartHeight,
    required this.maxValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (categoriesData.isEmpty || maxValue <= 0) return;

    const pointMode = ui.PointMode.polygon;

    // Calculate points for categories
    final points = <Offset>[];

    for (int i = 0; i < categoriesData.length; i++) {
      final category = categoriesData[i];

      // Calculate X position (evenly distributed across width)
      final double x = (i * (chartWidth / categoriesData.length)) +
          (chartWidth / categoriesData.length / 2);

      // Calculate Y position
      final double y = category.value == 0
          ? chartHeight
          : chartHeight - ((category.value / maxValue) * chartHeight);

      points.add(Offset(x, y));
    }

    // Draw the line connecting all points
    final linePaint = Paint()
      ..color = AppColor.green
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    if (points.length > 1) {
      final path = Path();
      path.moveTo(points[0].dx, points[0].dy);

      for (int i = 1; i < points.length; i++) {
        path.lineTo(points[i].dx, points[i].dy);
      }

      canvas.drawPath(path, linePaint);
    }

    // Draw individual points
    final pointPaint = Paint()
      ..color = AppColor.green
      ..strokeWidth = 4.0
      ..strokeCap = StrokeCap.round;

    canvas.drawPoints(pointMode, points, pointPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate is! CategoryLinePainter ||
        oldDelegate.categoriesData != categoriesData ||
        oldDelegate.maxValue != maxValue ||
        oldDelegate.chartWidth != chartWidth ||
        oldDelegate.chartHeight != chartHeight;
  }
}
