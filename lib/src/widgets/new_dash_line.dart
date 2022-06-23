import 'package:candlesticks/src/widgets/draw_dash_line.dart';
import 'package:flutter/material.dart';

class NewDashLine extends StatelessWidget {
  final Axis direction;
  final Color color;
  final double dashWidth;
  final double dashSpace;
  final double? width;
  final double height;
  const NewDashLine({
    required this.direction,
    required this.color,
    required this.dashWidth,
    required this.dashSpace,
    this.width,
    required this.height
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: direction == Axis.vertical ? height : 1,
      width: direction == Axis.vertical ? 1 : height,
      child: CustomPaint(
        painter: DrawDashLine(
          direction: direction,
          color: color,
          dashWidth: dashWidth,
          dashSpace: dashSpace,
          width: width??1,

        ),
      ),
    );
  }
}