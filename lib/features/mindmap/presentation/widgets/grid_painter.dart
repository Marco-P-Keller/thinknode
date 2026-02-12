import 'package:flutter/material.dart';

/// CustomPainter that draws a dot grid on the canvas background
class GridPainter extends CustomPainter {
  final double gridSpacing;
  final Color dotColor;
  final double dotRadius;
  final Matrix4 transform;

  GridPainter({
    this.gridSpacing = 40.0,
    required this.dotColor,
    this.dotRadius = 1.5,
    required this.transform,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = dotColor
      ..style = PaintingStyle.fill;

    // Extract translation and scale from the transformation matrix
    final tx = transform.getTranslation().x;
    final ty = transform.getTranslation().y;
    final scale = transform.getMaxScaleOnAxis();

    final effectiveSpacing = gridSpacing * scale;

    // Only draw if spacing is large enough
    if (effectiveSpacing < 10) return;

    // Calculate the start offsets to align dots with the transform
    final startX = tx % effectiveSpacing;
    final startY = ty % effectiveSpacing;

    for (double x = startX; x < size.width; x += effectiveSpacing) {
      for (double y = startY; y < size.height; y += effectiveSpacing) {
        canvas.drawCircle(
          Offset(x, y),
          dotRadius * scale.clamp(0.5, 2.0),
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant GridPainter oldDelegate) {
    return oldDelegate.transform != transform ||
        oldDelegate.dotColor != dotColor ||
        oldDelegate.gridSpacing != gridSpacing;
  }
}

