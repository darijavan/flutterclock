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
    return Transform.scale(
      scale: min(widget.size.width, widget.size.height) / 300,
      child: Container(
        width: widget.size.width,
        height: widget.size.height,
        child: AnimatedBuilder(
          builder: (_, __) => CustomPaint(
            painter: _ClockPainter(widget.smooth),
          ),
          animation: _animationController,
        ),
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

  _ClockPainter(this.smooth);

  @override
  void paint(Canvas canvas, Size size) {
    var centerX = size.width / 2,
        centerY = size.height / 2,
        center = Offset(
          centerX,
          centerY,
        ),
        fullRadius = min(centerX, centerY),
        outerRadius = 40.0,
        centerRadius = 16.0,
        innerCircleBrush = Paint()..color = Color(0xff444974),
        outlineBrush = Paint()
          ..color = Color(0xffeaecff)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 16,
        centerDotBrush = Paint()..color = Color(0xffeaecff),
        secHandBrush = Paint()
          ..color = Colors.orange[300]
          ..strokeCap = StrokeCap.round
          ..strokeWidth = 6,
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
          ..strokeWidth = 10,
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
          ..strokeWidth = 14,
        dashBrush = Paint()
          ..color = Color(0xffeaecff)
          ..strokeCap = StrokeCap.round
          ..strokeWidth = 4;

    // Draw the inner circle
    canvas.drawCircle(center, fullRadius - outerRadius, innerCircleBrush);

    // Draw the outline
    canvas.drawCircle(center, fullRadius - outerRadius, outlineBrush);

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
    var hourHandX = centerX + 50 * cos(hourAngle * pi / 180),
        hourHandY = centerY + 50 * sin(hourAngle * pi / 180);
    canvas.drawLine(center, Offset(hourHandX, hourHandY), hourHandBrush);

    // Draw the minute hand
    var minHandX = centerX + 70 * cos(minAngle * pi / 180),
        minHandY = centerY + 70 * sin(minAngle * pi / 180);
    canvas.drawLine(center, Offset(minHandX, minHandY), minHandBrush);

    // Draw the second hand
    var secHandX = centerX + 80 * cos(secAngle * pi / 180),
        secHandY = centerY + 80 * sin(secAngle * pi / 180);
    canvas.drawLine(center, Offset(secHandX, secHandY), secHandBrush);

    // Draw the center dot
    canvas.drawCircle(center, centerRadius, centerDotBrush);

    // Draw the outer dashes
    var outerCircleRadius = fullRadius, innerCircleRadius = fullRadius - 14;
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
