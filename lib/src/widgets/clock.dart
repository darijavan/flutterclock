import 'dart:math';

import 'package:flutter/material.dart';

class Clock extends StatefulWidget {
  /// The clock size
  final Size size;
  final bool smooth;

  const Clock({
    Key key,
    this.size = const Size.fromRadius(150),
    this.smooth = false,
  }) : super(key: key);

  @override
  _ClockState createState() => _ClockState();
}

class _ClockState extends State<Clock> with SingleTickerProviderStateMixin {
  AnimationController _animationController;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(
        seconds: 1,
      ),
    )..repeat();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.size.width,
      height: widget.size.height,
      child: AnimatedBuilder(
        builder: (_, __) => CustomPaint(
          painter: _ClockPainter(
            smooth: widget.smooth,
          ),
        ),
        animation: _animationController,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}

class _ClockPainter extends CustomPainter {
  var _dateTime = DateTime.now();
  final bool smooth;

  _ClockPainter({this.smooth});

  @override
  void paint(Canvas canvas, Size size) {
    var scale = min(size.width, size.height) / 300;

    var centerX = size.width / 2,
        centerY = size.height / 2,
        center = Offset(
          centerX,
          centerY,
        ),
        fullRadius = min(centerX, centerY),
        innerRadius = fullRadius * 0.95,
        centerRadius = 14.0 * scale,
        innerCircleBrush = Paint()..color = Color(0xff444974),
        outlineBrush = Paint()
          ..color = Color(0xffeaecff)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 12 * scale * scale,
        centerDotBrush = Paint()..color = Color(0xffeaecff),
        secHandBrush = Paint()
          ..color = Colors.orange[300]
          ..strokeCap = StrokeCap.round
          ..strokeWidth = 6 * scale * scale,
        minHandBrush = Paint()
          ..shader = RadialGradient(
            colors: [
              Color(0xff748ef6),
              Color(0xff77ddff),
            ],
          ).createShader(
            Rect.fromCircle(
              center: center,
              radius: fullRadius,
            ),
          )
          ..strokeCap = StrokeCap.round
          ..strokeWidth = 10 * scale * scale,
        hourHandBrush = Paint()
          ..shader = RadialGradient(
            colors: [
              Color(0xffea74ab),
              Colors.pink,
            ],
          ).createShader(
            Rect.fromCircle(
              center: center,
              radius: fullRadius,
            ),
          )
          ..strokeCap = StrokeCap.round
          ..strokeWidth = 14 * scale * scale,
        dashBrush = Paint()
          ..color = Color(0xffeaecff)
          ..strokeCap = StrokeCap.round
          ..strokeWidth = 2 * scale * scale;

    // Draw the inner circle
    canvas.drawCircle(center, innerRadius * scale, innerCircleBrush);

    // Draw the outline
    canvas.drawCircle(center, innerRadius * scale, outlineBrush);

    // Angle calculation
    var secAngle = !smooth
        ? (_dateTime.second * 6 - 90)
        : ((_dateTime.second + _dateTime.millisecond / 1000) * 6 - 90);
    var minAngle = !smooth
        ? (_dateTime.minute * 6 - 90)
        : ((_dateTime.minute + _dateTime.second / 60) * 6 - 90);
    var hourAngle = !smooth
        ? (_dateTime.hour * 30 - 90)
        : ((_dateTime.hour + _dateTime.minute / 60) * 30 - 90);

    // Draw the hour hand
    var hourHandX =
            centerX + innerRadius * 0.35 * scale * cos(hourAngle * pi / 180),
        hourHandY =
            centerY + innerRadius * 0.35 * scale * sin(hourAngle * pi / 180);
    canvas.drawLine(center, Offset(hourHandX, hourHandY), hourHandBrush);

    // Draw the minute hand
    var minHandX =
            centerX + innerRadius * 0.55 * scale * cos(minAngle * pi / 180),
        minHandY =
            centerY + innerRadius * 0.55 * scale * sin(minAngle * pi / 180);
    canvas.drawLine(center, Offset(minHandX, minHandY), minHandBrush);

    // Draw the second hand
    var secHandX =
            centerX + innerRadius * 0.75 * scale * cos(secAngle * pi / 180),
        secHandY =
            centerY + innerRadius * 0.75 * scale * sin(secAngle * pi / 180);
    canvas.drawLine(center, Offset(secHandX, secHandY), secHandBrush);

    // Draw the center dot
    canvas.drawCircle(center, centerRadius * scale, centerDotBrush);

    // Draw the outer dashes
    var outerCircleRadius = fullRadius, innerCircleRadius = fullRadius * 0.9;
    for (var i = 0; i < 360; i += 12) {
      var x1 = centerX + outerCircleRadius * cos((i - 90) * pi / 180),
          y1 = centerY + outerCircleRadius * sin((i - 90) * pi / 180),
          x2 = centerX + innerCircleRadius * cos((i - 90) * pi / 180),
          y2 = centerY + innerCircleRadius * sin((i - 90) * pi / 180);

      canvas.drawLine(Offset(x1, y1), Offset(x2, y2), dashBrush);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
