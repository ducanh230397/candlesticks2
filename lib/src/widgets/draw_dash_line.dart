import 'package:flutter/material.dart';

class DrawDashLine extends CustomPainter {
  final Axis direction;
  final Color color;
  final double dashWidth;
  final double dashSpace;
  final double width;

  const DrawDashLine({
    required this.direction,
    required this.color,
    required this.dashWidth,
    required this.dashSpace,
    required this.width
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
    ..color = color
    ..strokeCap = StrokeCap.round
    ..strokeWidth = width;

    _drawDashedLine(canvas, size, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }

  void _drawDashedLine(Canvas canvas, Size size, Paint paint) {

    double startX = size.width;
    double y = 0;

    double startY = size.height;
    double x = 0;

    if(direction == Axis.horizontal) {
      while (startX > 0 + dashWidth) {
        canvas.drawLine(
            Offset(startX, y), Offset(startX - dashWidth, y), paint);

        startX -= dashWidth + dashSpace +2;
      }
    }
    else {
      while (startY > 0 + dashWidth) {
        canvas.drawLine(
            Offset(x, startY), Offset(x, startY - dashWidth), paint);

        startY -= dashWidth + dashSpace +2;
      }
    }
  }
}