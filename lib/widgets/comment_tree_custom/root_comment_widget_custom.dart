import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:EngKid/widgets/comment_tree_custom/tree_theme_data_custom.dart';
import 'package:provider/provider.dart';

class RootCommentWidgetCustom extends StatelessWidget {
  final PreferredSizeWidget avatar;
  final Widget content;

  const RootCommentWidgetCustom(this.avatar, this.content, {super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: RootPainter(
        avatar.preferredSize,
        context.watch<TreeThemeDataCustom>().lineColor,
        context.watch<TreeThemeDataCustom>().lineWidth,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          avatar,
          // const SizedBox(
          //   width: 8,
          // ),
          Expanded(
            child: content,
          )
        ],
      ),
    );
  }
}

class RootPainter extends CustomPainter {
  Size? avatar;
  late Paint _paint;
  Color? pathColor;
  double? strokeWidth;

  RootPainter(this.avatar, this.pathColor, this.strokeWidth) {
    _paint = Paint()
      ..color = pathColor!
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth!
      ..strokeCap = StrokeCap.round;
  }

  @override
  void paint(Canvas canvas, Size size) {
    // Tạo một path cho đường thẳng
    Path path = Path();
    path.moveTo(avatar!.width / 2, avatar!.height);
    path.lineTo(avatar!.width / 2, size.height);

    // Sử dụng đường nét đứt
    Path dashedPath = _createDashedPath(path);
    canvas.drawPath(dashedPath, _paint);
  }

  // Hàm tạo đường nét đứt
  Path _createDashedPath(Path source) {
    const dashWidth = 3.0;
    const dashSpace = 3.0;
    Path path = Path();
    double distance = 0.0;

    for (PathMetric pathMetric in source.computeMetrics()) {
      while (distance < pathMetric.length) {
        final double nextDash = distance + dashWidth;
        path.addPath(
          pathMetric.extractPath(distance, nextDash),
          Offset.zero,
        );
        distance = nextDash + dashSpace;
      }
    }

    return path;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
