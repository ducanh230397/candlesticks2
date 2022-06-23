import 'package:flutter/material.dart';

class PaintDrawTime extends CustomPainter {
  final DateTime date;

  const PaintDrawTime({
    required this.date
  });

  String numberFormat(int value) {
    return "${value < 10 ? 0 : ""}$value";
  }

  String dateText(DateTime date) {
    return numberFormat(date.day) + "/" + numberFormat(date.month) + "/" + numberFormat(date.year);
  }

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = Color(0xFF333333)
      ..style = PaintingStyle.fill;


    final textStyle = TextStyle(
        color: Colors.white,
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 16/14
    );


    final textSpan = TextSpan(
      text: dateText(date),
      style: textStyle,
    );
    final textPainter = TextPainter(
      text: textSpan,
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout(
      minWidth: 0,
      maxWidth: 999,
    );
   var panelWidth =  textPainter.width;
    canvas.drawRect(Offset(-4 - panelWidth / 2, 0) &  Size(panelWidth + 9, 22), paint);

    final offset = Offset(-panelWidth /2, 0);
    textPainter.paint(canvas, offset);


  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }

}