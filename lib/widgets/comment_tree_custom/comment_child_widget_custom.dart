import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:EngKid/widgets/comment_tree_custom/tree_theme_data_custom.dart';
import 'package:provider/provider.dart';

class CommentChildWidgetCustom extends StatelessWidget {
  final PreferredSizeWidget? avatar;
  final Widget? content;
  final bool? isLast;
  final Size? avatarRoot;

  const CommentChildWidgetCustom({
    super.key,
    required this.isLast,
    required this.avatar,
    required this.content,
    required this.avatarRoot,
  });

  @override
  Widget build(BuildContext context) {
    final EdgeInsets padding =
        EdgeInsets.only(left: avatarRoot!.width * 2 / 3, bottom: 8, top: 8);

    return CustomPaint(
      painter: _Painter(
        isLast: isLast!,
        padding: padding,
        avatarRoot: avatarRoot,
        avatarChild: avatar!.preferredSize,
        pathColor: context.watch<TreeThemeDataCustom>().lineColor,
        strokeWidth: context.watch<TreeThemeDataCustom>().lineWidth,
      ),
      child: Container(
        padding: padding,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            avatar!,
            const SizedBox(
              width: 8,
            ),
            Expanded(child: content!),
          ],
        ),
      ),
    );
  }
}

class _Painter extends CustomPainter {
  bool isLast = false;

  EdgeInsets? padding;

  Size? avatarRoot;
  Size? avatarChild;
  Color? pathColor;
  double? strokeWidth;

  _Painter({
    required this.isLast,
    this.padding,
    this.avatarRoot,
    this.avatarChild,
    this.pathColor,
    this.strokeWidth,
  }) {
    _paint = Paint()
      ..color = pathColor!
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth!
      ..strokeCap = StrokeCap.round;
  }

  late Paint _paint;

  @override
  void paint(Canvas canvas, Size size) {
    final Path path = Path();
    path.moveTo(avatarRoot!.width / 2, 0);
    path.cubicTo(
      avatarRoot!.width / 2,
      0,
      avatarRoot!.width / 2,
      padding!.top + avatarChild!.height / 1,
      avatarRoot!.width,
      padding!.top + avatarChild!.height / 1,
    );

    // Vẽ đường cong dạng nét đứt
    Path dashedPath = _createDashedPath(path);
    canvas.drawPath(dashedPath, _paint);

    if (!isLast) {
      // Thay vì sử dụng canvas.drawLine, sử dụng Path để vẽ đường thẳng nét đứt
      Path linePath = Path()
        ..moveTo(avatarRoot!.width / 2, padding!.top + avatarChild!.height / 1)
        ..lineTo(avatarRoot!.width / 2, size.height);

      // Vẽ đường thẳng dạng nét đứt
      Path dashedLine = _createDashedPath(linePath);
      canvas.drawPath(dashedLine, _paint);
    }
  }

  // Hàm tạo đường nét đứt
  Path _createDashedPath(Path source) {
    const dashWidth = 3.0;
    const dashSpace = 3.0;
    Path path = Path();
    double distance = 0;

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
