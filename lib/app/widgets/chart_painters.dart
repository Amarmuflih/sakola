import 'package:flutter/material.dart';

/// Line chart dengan titik indikator yang bisa disorot (tap bulan).
/// [dataPoints] harus sudah dinormalisasi ke rentang 0.0 - 1.0.
class LineChartPainter extends CustomPainter {
  final Color lineColor;
  final List<double> dataPoints;
  final int selectedIndex;

  LineChartPainter({
    required this.lineColor,
    required this.dataPoints,
    required this.selectedIndex,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (dataPoints.length < 2) return;

    final int lastIndex = dataPoints.length - 1;

    Paint linePaint = Paint()
      ..color = lineColor
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    Paint fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [lineColor.withOpacity(0.2), lineColor.withOpacity(0.0)],
      ).createShader(Rect.fromLTRB(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;

    Paint gridPaint = Paint()
      ..color = Colors.grey.shade200
      ..strokeWidth = 1;
    for (int i = 0; i <= lastIndex; i++) {
      double dx = size.width / lastIndex * i;
      canvas.drawLine(Offset(dx, 0), Offset(dx, size.height), gridPaint);
    }

    Path path = Path();
    List<Offset> points = [];

    for (int i = 0; i < dataPoints.length; i++) {
      points.add(
        Offset(
          size.width * (i / lastIndex),
          size.height * (1.0 - dataPoints[i]),
        ),
      );
    }

    path.moveTo(points[0].dx, points[0].dy);
    for (int i = 0; i < points.length - 1; i++) {
      double xc = (points[i].dx + points[i + 1].dx) / 2;
      double yc = (points[i].dy + points[i + 1].dy) / 2;
      path.quadraticBezierTo(points[i].dx, points[i].dy, xc, yc);
    }
    if (points.length > 1) {
      path.quadraticBezierTo(
        points[points.length - 2].dx,
        points[points.length - 2].dy,
        points.last.dx,
        points.last.dy,
      );
    }

    Path fillPath = Path.from(path);
    fillPath.lineTo(size.width, size.height);
    fillPath.lineTo(0, size.height);
    fillPath.close();

    canvas.drawPath(fillPath, fillPaint);
    canvas.drawPath(path, linePaint);

    final safeIndex = selectedIndex.clamp(0, points.length - 1);

    Paint dotPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    Paint dotBorderPaint = Paint()
      ..color = lineColor
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(points[safeIndex], 5, dotPaint);
    canvas.drawCircle(points[safeIndex], 5, dotBorderPaint);
  }

  @override
  bool shouldRepaint(covariant LineChartPainter oldDelegate) =>
      oldDelegate.selectedIndex != selectedIndex ||
      oldDelegate.dataPoints != dataPoints ||
      oldDelegate.lineColor != lineColor;
}

/// Donut setengah lingkaran (horizontal), dipakai untuk breakdown biaya.
class HalfDonutPainter extends CustomPainter {
  final List<Color> colors;
  final List<double> proportions;

  HalfDonutPainter({required this.colors, required this.proportions});

  @override
  void paint(Canvas canvas, Size size) {
    if (proportions.isEmpty) return;

    double strokeWidth = 35;
    Rect rect = Rect.fromCenter(
      center: Offset(size.width / 2, size.height),
      width: size.width - strokeWidth,
      height: (size.height * 2) - strokeWidth,
    );

    Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.butt;

    double startAngle = 3.14159;
    double totalAngle = 3.14159;

    for (int i = 0; i < proportions.length; i++) {
      paint.color = colors[i % colors.length];
      double sweepAngle = totalAngle * proportions[i];
      canvas.drawArc(rect, startAngle, sweepAngle, false, paint);
      startAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(covariant HalfDonutPainter oldDelegate) =>
      oldDelegate.proportions != proportions;
}

/// Donut setengah lingkaran (vertikal), dipakai untuk statistik gender siswa.
class VerticalHalfDonutPainter extends CustomPainter {
  final List<Color> colors;
  final List<double> proportions;

  VerticalHalfDonutPainter({required this.colors, required this.proportions});

  @override
  void paint(Canvas canvas, Size size) {
    if (proportions.isEmpty) return;

    double strokeWidth = 30;

    Rect rect = Rect.fromCenter(
      center: Offset(size.width, size.height / 2),
      width: size.height - strokeWidth,
      height: size.height - strokeWidth,
    );

    Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.butt;

    double startAngle = -1.5708;
    double totalAngle = -3.14159;

    for (int i = 0; i < proportions.length; i++) {
      paint.color = colors[i % colors.length];
      double sweepAngle = totalAngle * proportions[i];
      canvas.drawArc(rect, startAngle, sweepAngle, false, paint);
      startAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(covariant VerticalHalfDonutPainter oldDelegate) =>
      oldDelegate.proportions != proportions;
}
