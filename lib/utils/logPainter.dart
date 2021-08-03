import 'package:flutter/material.dart';

class LogPainter extends CustomPainter {
  Color _color = Colors.red;
  LogPainter(this._color);
  @override
  void paint(Canvas canvas, Size size) {
    // Define a paint object
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..strokeWidth = 1.0
      ..color = _color;

    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(0, 0, 5, 5), Radius.circular(5)),
      paint,
    );
  }

  @override
  bool shouldRepaint(LogPainter oldDelegate) => false;
}
