import 'dart:math';
import 'package:flutter/material.dart';
import 'package:thinknode/features/mindmap/domain/models/edge_model.dart';
import 'package:thinknode/features/mindmap/domain/models/node_model.dart';

/// CustomPainter that draws all edges between nodes on the canvas
class EdgePainter extends CustomPainter {
  final List<EdgeModel> edges;
  final List<NodeModel> nodes;
  final String? selectedEdgeId;
  final String? connectingFromNodeId;
  final Offset? dragStart;
  final Offset? dragEnd;

  // Pre-built node map for O(1) lookups
  late final Map<String, NodeModel> _nodeMap;

  EdgePainter({
    required this.edges,
    required this.nodes,
    this.selectedEdgeId,
    this.connectingFromNodeId,
    this.dragStart,
    this.dragEnd,
  }) {
    _nodeMap = {for (final n in nodes) n.id: n};
  }

  @override
  void paint(Canvas canvas, Size size) {
    // Draw existing edges
    for (final edge in edges) {
      final sourceNode = _nodeMap[edge.sourceNodeId];
      final targetNode = _nodeMap[edge.targetNodeId];
      if (sourceNode == null || targetNode == null) continue;

      final sourceCenter = Offset(
        sourceNode.x + sourceNode.width / 2,
        sourceNode.y + sourceNode.height / 2,
      );
      final targetCenter = Offset(
        targetNode.x + targetNode.width / 2,
        targetNode.y + targetNode.height / 2,
      );

      final isSelected = edge.id == selectedEdgeId;
      _drawEdge(
        canvas,
        sourceCenter,
        targetCenter,
        Color(edge.color),
        edge.type,
        edge.style,
        edge.arrowMode,
        isSelected,
        edge.label,
      );
    }

    // Draw temporary edge during connection creation (highlighted)
    if (connectingFromNodeId != null && dragStart != null && dragEnd != null) {
      // Draw glow effect
      final glowPaint = Paint()
        ..color = Colors.blue.withValues(alpha: 0.3)
        ..strokeWidth = 8.0
        ..style = PaintingStyle.stroke
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
      canvas.drawLine(dragStart!, dragEnd!, glowPaint);
      
      // Draw main line
      _drawEdge(
        canvas,
        dragStart!,
        dragEnd!,
        Colors.blue.withValues(alpha: 0.9),
        EdgeType.dashed,
        EdgeStyle.straight,
        ArrowMode.forward,
        false,
        'Ziehen zum Verbinden',
      );
    }
  }

  void _drawEdge(
    Canvas canvas,
    Offset start,
    Offset end,
    Color color,
    EdgeType type,
    EdgeStyle style,
    ArrowMode arrowMode,
    bool isSelected,
    String label,
  ) {
    final paint = Paint()
      ..color =
          isSelected ? color.withValues(alpha: 1.0) : color.withValues(alpha: 0.8)
      ..strokeWidth = isSelected ? 3.0 : 2.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // Set dash pattern for dashed edges
    if (type == EdgeType.dashed) {
      paint.strokeWidth = isSelected ? 2.5 : 1.5;
    }

    Path path;

    if (style == EdgeStyle.curved) {
      // Draw a curved bezier path
      final midX = (start.dx + end.dx) / 2;
      final midY = (start.dy + end.dy) / 2;
      final dx = end.dx - start.dx;
      final dy = end.dy - start.dy;
      // Control point offset perpendicular to the line
      final controlOffset = Offset(-dy * 0.2, dx * 0.2);
      final controlPoint =
          Offset(midX + controlOffset.dx, midY + controlOffset.dy);

      path = Path()
        ..moveTo(start.dx, start.dy)
        ..quadraticBezierTo(
            controlPoint.dx, controlPoint.dy, end.dx, end.dy);
    } else {
      path = Path()
        ..moveTo(start.dx, start.dy)
        ..lineTo(end.dx, end.dy);
    }

    if (type == EdgeType.dashed) {
      _drawDashedPath(canvas, path, paint);
    } else {
      canvas.drawPath(path, paint);
    }

    // Draw double line
    if (type == EdgeType.double) {
      final offsetPaint = Paint()
        ..color = paint.color
        ..strokeWidth = paint.strokeWidth
        ..style = PaintingStyle.stroke;

      final dx = end.dx - start.dx;
      final dy = end.dy - start.dy;
      final len = sqrt(dx * dx + dy * dy);
      if (len > 0) {
        final perpX = -dy / len * 4;
        final perpY = dx / len * 4;

        final path2 = Path()
          ..moveTo(start.dx + perpX, start.dy + perpY)
          ..lineTo(end.dx + perpX, end.dy + perpY);
        canvas.drawPath(path2, offsetPaint);

        final path3 = Path()
          ..moveTo(start.dx - perpX, start.dy - perpY)
          ..lineTo(end.dx - perpX, end.dy - perpY);
        canvas.drawPath(path3, offsetPaint);
      }
    }

    // Draw arrows based on arrowMode
    final arrowColor = paint.color;
    if (arrowMode == ArrowMode.forward || arrowMode == ArrowMode.both) {
      _drawArrow(canvas, start, end, arrowColor, isSelected);
    }
    if (arrowMode == ArrowMode.backward || arrowMode == ArrowMode.both) {
      _drawArrow(canvas, end, start, arrowColor, isSelected);
    }

    // Draw label
    if (label.isNotEmpty) {
      _drawLabel(canvas, start, end, label, paint.color);
    }

    // Draw selection indicator
    if (isSelected) {
      final selectPaint = Paint()
        ..color = color.withValues(alpha: 0.3)
        ..strokeWidth = 8.0
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;
      canvas.drawPath(path, selectPaint);
    }
  }

  void _drawArrow(
      Canvas canvas, Offset from, Offset to, Color color, bool isSelected) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final dx = to.dx - from.dx;
    final dy = to.dy - from.dy;
    final angle = atan2(dy, dx);
    final arrowLength = isSelected ? 14.0 : 12.0;
    final arrowWidth = isSelected ? 8.0 : 6.0;

    final arrowPath = Path()
      ..moveTo(to.dx, to.dy)
      ..lineTo(
        to.dx - arrowLength * cos(angle - arrowWidth / arrowLength),
        to.dy - arrowLength * sin(angle - arrowWidth / arrowLength),
      )
      ..lineTo(
        to.dx - arrowLength * cos(angle + arrowWidth / arrowLength),
        to.dy - arrowLength * sin(angle + arrowWidth / arrowLength),
      )
      ..close();

    canvas.drawPath(arrowPath, paint);
  }

  void _drawLabel(
      Canvas canvas, Offset start, Offset end, String label, Color color) {
    final midX = (start.dx + end.dx) / 2;
    final midY = (start.dy + end.dy) / 2;

    // Draw background for label
    final textSpan = TextSpan(
      text: label,
      style: TextStyle(
        color: color,
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
    );

    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();

    // White background behind label
    final bgRect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(midX, midY - 10),
        width: textPainter.width + 12,
        height: textPainter.height + 6,
      ),
      const Radius.circular(4),
    );
    canvas.drawRRect(
      bgRect,
      Paint()..color = Colors.white.withValues(alpha: 0.9),
    );
    canvas.drawRRect(
      bgRect,
      Paint()
        ..color = color.withValues(alpha: 0.3)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1,
    );

    textPainter.paint(
      canvas,
      Offset(midX - textPainter.width / 2,
          midY - textPainter.height / 2 - 10),
    );
  }

  void _drawDashedPath(Canvas canvas, Path path, Paint paint) {
    const dashWidth = 8.0;
    const dashSpace = 5.0;

    final pathMetrics = path.computeMetrics();
    for (final metric in pathMetrics) {
      double distance = 0;
      while (distance < metric.length) {
        final end = (distance + dashWidth).clamp(0.0, metric.length);
        final extractPath = metric.extractPath(distance, end);
        canvas.drawPath(extractPath, paint);
        distance += dashWidth + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(covariant EdgePainter oldDelegate) {
    return oldDelegate.edges != edges ||
        oldDelegate.nodes != nodes ||
        oldDelegate.selectedEdgeId != selectedEdgeId ||
        oldDelegate.connectingFromNodeId != connectingFromNodeId ||
        oldDelegate.dragEnd != dragEnd;
  }
}
