import 'package:candlesticks/src/widgets/paint_draw_time.dart';
import 'package:flutter/material.dart';

class DrawSelectedStockTime extends StatelessWidget {
  final DateTime date;
  const DrawSelectedStockTime({
    required this.date
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 22,
      width: 0,
      child: CustomPaint(
        painter: PaintDrawTime(
          date: date
        ),
      ),
    );
  }
}