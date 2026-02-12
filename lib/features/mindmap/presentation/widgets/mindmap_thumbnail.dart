import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thinknode/features/mindmap/domain/models/edge_model.dart';
import 'package:thinknode/features/mindmap/domain/models/node_model.dart';
import 'package:thinknode/features/mindmap/presentation/providers/mindmap_providers.dart';

/// A small thumbnail preview of a mindmap, showing nodes and edges
/// scaled to fit the available space.
class MindmapThumbnail extends ConsumerWidget {
  final String mindmapId;

  const MindmapThumbnail({super.key, required this.mindmapId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nodesAsync = ref.watch(nodesProvider(mindmapId));
    final edgesAsync = ref.watch(edgesProvider(mindmapId));
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final nodes = nodesAsync.value ?? [];
    final edges = edgesAsync.value ?? [];

    if (nodes.isEmpty) {
      // Empty state: show a subtle placeholder
      return Container(
        decoration: BoxDecoration(
          color: isDark
              ? theme.colorScheme.surfaceContainerHighest
              : theme.colorScheme.surfaceContainerLow,
        ),
        child: Center(
          child: Icon(
            Icons.hub_outlined,
            size: 32,
            color: theme.colorScheme.primary.withValues(alpha: 0.2),
          ),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: isDark
            ? theme.colorScheme.surfaceContainerHighest
            : theme.colorScheme.surfaceContainerLow,
      ),
      child: CustomPaint(
        painter: _ThumbnailPainter(
          nodes: nodes,
          edges: edges,
          isDark: isDark,
        ),
      ),
    );
  }
}

/// CustomPainter that renders a miniature version of the mindmap.
/// Automatically scales and centers all nodes to fit the canvas.
class _ThumbnailPainter extends CustomPainter {
  final List<NodeModel> nodes;
  final List<EdgeModel> edges;
  final bool isDark;

  late final Map<String, NodeModel> _nodeMap;

  _ThumbnailPainter({
    required this.nodes,
    required this.edges,
    required this.isDark,
  }) {
    _nodeMap = {for (final n in nodes) n.id: n};
  }

  @override
  void paint(Canvas canvas, Size size) {
    if (nodes.isEmpty) return;

    // Calculate the bounding box of all nodes
    double minX = double.infinity, minY = double.infinity;
    double maxX = double.negativeInfinity, maxY = double.negativeInfinity;

    for (final node in nodes) {
      minX = min(minX, node.x);
      minY = min(minY, node.y);
      maxX = max(maxX, node.x + node.width);
      maxY = max(maxY, node.y + node.height);
    }

    final contentWidth = maxX - minX;
    final contentHeight = maxY - minY;

    if (contentWidth <= 0 || contentHeight <= 0) return;

    // Add padding
    const padding = 12.0;
    final availableWidth = size.width - padding * 2;
    final availableHeight = size.height - padding * 2;

    // Scale to fit
    final scaleX = availableWidth / contentWidth;
    final scaleY = availableHeight / contentHeight;
    final scale = min(scaleX, scaleY).clamp(0.05, 1.5);

    // Center offset
    final scaledWidth = contentWidth * scale;
    final scaledHeight = contentHeight * scale;
    final offsetX = padding + (availableWidth - scaledWidth) / 2;
    final offsetY = padding + (availableHeight - scaledHeight) / 2;

    // Transform helper: convert node coordinates to canvas coordinates
    Offset transform(double x, double y) {
      return Offset(
        (x - minX) * scale + offsetX,
        (y - minY) * scale + offsetY,
      );
    }

    // Draw edges first (behind nodes)
    final edgePaint = Paint()
      ..strokeWidth = max(1.0, 1.5 * scale)
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    for (final edge in edges) {
      final source = _nodeMap[edge.sourceNodeId];
      final target = _nodeMap[edge.targetNodeId];
      if (source == null || target == null) continue;

      final start = transform(
        source.x + source.width / 2,
        source.y + source.height / 2,
      );
      final end = transform(
        target.x + target.width / 2,
        target.y + target.height / 2,
      );

      edgePaint.color = Color(edge.color).withValues(alpha: 0.5);

      if (edge.style == EdgeStyle.curved) {
        final midX = (start.dx + end.dx) / 2;
        final midY = (start.dy + end.dy) / 2;
        final dx = end.dx - start.dx;
        final dy = end.dy - start.dy;
        final ctrl = Offset(midX - dy * 0.15, midY + dx * 0.15);

        final path = Path()
          ..moveTo(start.dx, start.dy)
          ..quadraticBezierTo(ctrl.dx, ctrl.dy, end.dx, end.dy);
        canvas.drawPath(path, edgePaint);
      } else {
        canvas.drawLine(start, end, edgePaint);
      }
    }

    // Draw nodes
    for (final node in nodes) {
      final topLeft = transform(node.x, node.y);
      final nodeWidth = node.width * scale;
      final nodeHeight = node.height * scale;
      final nodeColor = Color(node.color);

      final rect = Rect.fromLTWH(topLeft.dx, topLeft.dy, nodeWidth, nodeHeight);

      final fillPaint = Paint()
        ..color = nodeColor.withValues(alpha: 0.85)
        ..style = PaintingStyle.fill;

      final shadowPaint = Paint()
        ..color = nodeColor.withValues(alpha: 0.2)
        ..style = PaintingStyle.fill
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);

      // Shadow
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          rect.shift(const Offset(1, 1)),
          Radius.circular(4 * scale),
        ),
        shadowPaint,
      );

      // Node shape
      switch (node.shape) {
        case NodeShape.circle:
          canvas.drawOval(rect, fillPaint);
          break;
        case NodeShape.rectangle:
          canvas.drawRRect(
            RRect.fromRectAndRadius(rect, Radius.circular(2 * scale)),
            fillPaint,
          );
          break;
        case NodeShape.roundedRectangle:
          canvas.drawRRect(
            RRect.fromRectAndRadius(rect, Radius.circular(6 * scale)),
            fillPaint,
          );
          break;
      }

      // Draw text label if node is large enough
      if (nodeWidth > 20 && nodeHeight > 12) {
        final textColor =
            nodeColor.computeLuminance() > 0.5 ? Colors.black87 : Colors.white;
        final textSpan = TextSpan(
          text: node.text,
          style: TextStyle(
            color: textColor.withValues(alpha: 0.9),
            fontSize: max(6.0, 9.0 * scale),
            fontWeight: FontWeight.w500,
          ),
        );
        final tp = TextPainter(
          text: textSpan,
          textDirection: TextDirection.ltr,
          maxLines: 2,
          ellipsis: '…',
        );
        tp.layout(maxWidth: nodeWidth - 4);
        tp.paint(
          canvas,
          Offset(
            topLeft.dx + (nodeWidth - tp.width) / 2,
            topLeft.dy + (nodeHeight - tp.height) / 2,
          ),
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant _ThumbnailPainter oldDelegate) {
    return oldDelegate.nodes != nodes ||
        oldDelegate.edges != edges ||
        oldDelegate.isDark != isDark;
  }
}

