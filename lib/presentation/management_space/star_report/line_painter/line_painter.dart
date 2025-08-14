import 'package:flutter/material.dart';
import 'package:EngKid/domain/core/entities/entities.dart';

import 'dart:ui' as ui;

import 'package:EngKid/utils/app_color.dart';

class LinePainter extends CustomPainter {
  final List<DayOf> daysOf;
  final double width;
  final double height;
  final double maxStarOfWeek;
  final double heightChart;
  LinePainter(
      {required this.daysOf,
      required this.width,
      required this.height,
      required this.maxStarOfWeek,
      required this.heightChart});
  @override
  void paint(Canvas canvas, Size size) {
    const pointMode = ui.PointMode.polygon;

    final points = daysOf
        .map(
          (e) => Offset(
            e.left * width + 0.02 * width,
            e.value == 0
                ? heightChart
                : heightChart -
                    (e.value / maxStarOfWeek) * heightChart +
                    0.1 * heightChart,
          ),
        )
        .toList();

    final paint = Paint()
      ..color = AppColor.green
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;
    canvas.drawPoints(pointMode, points, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
