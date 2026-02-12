import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thinknode/features/mindmap/domain/models/node_model.dart';
import 'package:thinknode/features/mindmap/presentation/providers/canvas_state_provider.dart';

/// Widget that renders a single node on the mindmap canvas.
/// Handles selection, dragging, resizing, and connection point display.
///
/// Dragging uses local state in the parent (MindmapCanvas) for smooth 60fps
/// movement. Firestore is only written to on drag END.
class NodeWidget extends ConsumerStatefulWidget {
  final NodeModel node;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onDoubleTap;
  final VoidCallback onLongPress;
  final VoidCallback onDragStart;
  final Function(Offset delta) onDrag;
  final VoidCallback onDragEnd;
  final VoidCallback onResizeStart;
  final Function(Offset delta) onResize;
  final VoidCallback onResizeEnd;
  final Function(String nodeId, Offset position) onStartConnect;
  final Function(String nodeId) onEndConnect;
  final VoidCallback onDelete;

  const NodeWidget({
    super.key,
    required this.node,
    required this.isSelected,
    required this.onTap,
    required this.onDoubleTap,
    required this.onLongPress,
    required this.onDragStart,
    required this.onDrag,
    required this.onDragEnd,
    required this.onResizeStart,
    required this.onResize,
    required this.onResizeEnd,
    required this.onStartConnect,
    required this.onEndConnect,
    required this.onDelete,
  });

  @override
  ConsumerState<NodeWidget> createState() => _NodeWidgetState();
}

class _NodeWidgetState extends ConsumerState<NodeWidget> {
  bool _isHovered = false;

  /// Calculate the required height for the node based on text content
  double _calculateRequiredHeight() {
    final textColor = _getTextColor(Color(widget.node.color));
    
    // Calculate text height
    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );

    if (widget.node.textSpans.isNotEmpty) {
      textPainter.text = TextSpan(
        style: TextStyle(
          color: textColor,
          fontSize: widget.node.fontSize,
          height: 1.4,
          letterSpacing: 0.2,
        ),
        children: widget.node.textSpans.map((span) {
          return TextSpan(
            text: span.text,
            style: TextStyle(
              fontWeight: span.isBold ? FontWeight.w700 : FontWeight.w500,
            ),
          );
        }).toList(),
      );
    } else {
      // Fallback to plain text
      textPainter.text = TextSpan(
        text: widget.node.text,
        style: TextStyle(
          color: textColor,
          fontSize: widget.node.fontSize,
          height: 1.4,
          fontWeight: widget.node.isBold ? FontWeight.w700 : FontWeight.w500,
          letterSpacing: 0.2,
        ),
      );
    }

    // Layout with max width (minus horizontal padding)
    textPainter.layout(maxWidth: widget.node.width - 32);

    // Calculate total height: vertical padding + text height + notes icon
    final textHeight = textPainter.height;
    final notesHeight = widget.node.notes.isNotEmpty ? 22.0 : 0.0;
    final totalHeight = 28.0 + textHeight + notesHeight; // 28 = vertical padding

    // Clamp to reasonable min/max
    return totalHeight.clamp(80.0, 600.0);
  }

  @override
  Widget build(BuildContext context) {
    final nodeColor = Color(widget.node.color);
    final canvasState = ref.watch(canvasStateProvider);
    final isConnectMode = canvasState.activeTool == EditorTool.connect;
    final isDeleteMode = canvasState.activeTool == EditorTool.delete;
    final isConnectSource =
        canvasState.connectingFromNodeId == widget.node.id;

    // Calculate actual required height
    final actualHeight = _calculateRequiredHeight();

    return Positioned(
      left: widget.node.x,
      top: widget.node.y,
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: isDeleteMode
              ? widget.onDelete
              : isConnectMode
                  ? () {
                      // In connect mode: tap to complete connection
                      final cs = ref.read(canvasStateProvider);
                      if (cs.connectingFromNodeId != null) {
                        widget.onEndConnect(widget.node.id);
                      }
                    }
                  : widget.onTap,
          onDoubleTap: isConnectMode ? null : widget.onDoubleTap,
          onLongPress: isConnectMode ? null : widget.onLongPress,
          // In connect mode: drag starts a connection from this node
          // In other modes: drag moves the node
          onPanStart: isDeleteMode
              ? null
              : isConnectMode
                  ? (_) {
                      widget.onStartConnect(
                        widget.node.id,
                        Offset(
                          widget.node.x + widget.node.width / 2,
                          widget.node.y + actualHeight / 2,
                        ),
                      );
                    }
                  : (_) => widget.onDragStart(),
          onPanUpdate: isDeleteMode
              ? null
              : isConnectMode
                  ? null // Tracking handled by Listener in canvas
                  : (details) => widget.onDrag(details.delta),
          onPanEnd: isDeleteMode
              ? null
              : isConnectMode
                  ? null // End handled by Listener in canvas
                  : (_) => widget.onDragEnd(),
          child: SizedBox(
            width: widget.node.width,
            height: actualHeight,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                // Main node shape
                Positioned.fill(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 100),
                    decoration: _buildDecoration(nodeColor),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 14.0,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Flexible(
                              child: _buildRichText(nodeColor),
                            ),
                            if (widget.node.notes.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(top: 6),
                                child: Icon(
                                  Icons.sticky_note_2_outlined,
                                  size: 16,
                                  color: _getTextColor(nodeColor)
                                      .withValues(alpha: 0.7),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                // Selection border
                if (widget.isSelected)
                  Positioned.fill(
                    child: IgnorePointer(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: _getBorderRadius(),
                          border: Border.all(
                            color: Colors.blue,
                            width: 2.5,
                          ),
                        ),
                      ),
                    ),
                  ),

                // Connection points (visible on hover, when selected, or in connect mode)
                if ((_isHovered || isConnectMode || widget.isSelected) && !isDeleteMode) ...[
                  _buildConnectionPoint(
                    Offset(widget.node.width / 2, 0),
                  ),
                  _buildConnectionPoint(
                    Offset(widget.node.width / 2, actualHeight),
                  ),
                  _buildConnectionPoint(
                    Offset(0, actualHeight / 2),
                  ),
                  _buildConnectionPoint(
                    Offset(widget.node.width, actualHeight / 2),
                  ),
                ],

                // Resize handle (bottom-right, only when selected)
                if (widget.isSelected)
                  Positioned(
                    right: -6,
                    bottom: -6,
                    child: GestureDetector(
                      onPanStart: (_) => widget.onResizeStart(),
                      onPanUpdate: (details) =>
                          widget.onResize(details.delta),
                      onPanEnd: (_) => widget.onResizeEnd(),
                      child: Container(
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(3),
                          border:
                              Border.all(color: Colors.white, width: 1.5),
                        ),
                        child: const Icon(
                          Icons.drag_handle,
                          size: 10,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),

                // Connect source indicator (pulsing green border)
                if (isConnectSource)
                  Positioned.fill(
                    child: IgnorePointer(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: _getBorderRadius(),
                          border: Border.all(
                            color: Colors.green,
                            width: 3,
                          ),
                        ),
                        child: Align(
                          alignment: Alignment.topRight,
                          child: Container(
                            margin: const EdgeInsets.all(4),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              'Von',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                // Connect target hint on hover
                if (isConnectMode &&
                    !isConnectSource &&
                    canvasState.connectingFromNodeId != null &&
                    _isHovered)
                  Positioned.fill(
                    child: IgnorePointer(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: _getBorderRadius(),
                          color: Colors.green.withValues(alpha: 0.2),
                          border: Border.all(color: Colors.green, width: 2),
                        ),
                        child: const Center(
                          child: Text(
                            'Verbinden',
                            style: TextStyle(
                              color: Colors.green,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                // Delete mode indicator
                if (isDeleteMode && _isHovered)
                  Positioned.fill(
                    child: IgnorePointer(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: _getBorderRadius(),
                          color: Colors.red.withValues(alpha: 0.3),
                          border: Border.all(color: Colors.red, width: 2),
                        ),
                        child: const Center(
                          child:
                              Icon(Icons.delete, color: Colors.red, size: 28),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildConnectionPoint(Offset localPosition) {
    return Positioned(
      left: localPosition.dx - 10,
      top: localPosition.dy - 10,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          final canvasState = ref.read(canvasStateProvider);
          if (canvasState.connectingFromNodeId != null) {
            // Complete the connection
            widget.onEndConnect(widget.node.id);
          } else {
            // Start a connection from this node
            final globalPos = Offset(
              widget.node.x + localPosition.dx,
              widget.node.y + localPosition.dy,
            );
            widget.onStartConnect(widget.node.id, globalPos);
          }
        },
        // Drag from connection point starts a connection (works in ANY tool mode)
        onPanStart: (_) {
          final globalPos = Offset(
            widget.node.x + localPosition.dx,
            widget.node.y + localPosition.dy,
          );
          widget.onStartConnect(widget.node.id, globalPos);
        },
        child: Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: Colors.blue.withValues(alpha: 0.8),
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2),
            boxShadow: [
              BoxShadow(
                color: Colors.blue.withValues(alpha: 0.3),
                blurRadius: 4,
                spreadRadius: 1,
              ),
            ],
          ),
          child: const Icon(
            Icons.add,
            size: 12,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  BoxDecoration _buildDecoration(Color nodeColor) {
    return BoxDecoration(
      // Subtle gradient for depth
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          nodeColor,
          Color.alphaBlend(
            Colors.black.withValues(alpha: 0.05),
            nodeColor,
          ),
        ],
      ),
      borderRadius: _getBorderRadius(),
      shape: widget.node.shape == NodeShape.circle
          ? BoxShape.circle
          : BoxShape.rectangle,
      // Professional multi-layer shadow
      boxShadow: [
        // Primary shadow
        BoxShadow(
          color: Colors.black.withValues(alpha: widget.isSelected ? 0.2 : 0.12),
          blurRadius: widget.isSelected ? 16 : 8,
          spreadRadius: 0,
          offset: Offset(0, widget.isSelected ? 6 : 3),
        ),
        // Ambient shadow
        BoxShadow(
          color: nodeColor.withValues(alpha: widget.isSelected ? 0.25 : 0.15),
          blurRadius: widget.isSelected ? 24 : 12,
          spreadRadius: widget.isSelected ? -2 : -1,
          offset: Offset(0, widget.isSelected ? 8 : 4),
        ),
        // Highlight for 3D effect
        BoxShadow(
          color: Colors.white.withValues(alpha: 0.3),
          blurRadius: 1,
          spreadRadius: 0,
          offset: const Offset(0, -1),
        ),
      ],
      // Subtle border for definition
      border: Border.all(
        color: Color.alphaBlend(
          Colors.white.withValues(alpha: 0.2),
          nodeColor,
        ),
        width: 1,
      ),
    );
  }

  BorderRadius? _getBorderRadius() {
    if (widget.node.shape == NodeShape.circle) return null;
    if (widget.node.shape == NodeShape.roundedRectangle) {
      return BorderRadius.circular(16);
    }
    return BorderRadius.circular(4);
  }

  Color _getTextColor(Color bgColor) {
    return bgColor.computeLuminance() > 0.5 ? Colors.black87 : Colors.white;
  }

  Widget _buildRichText(Color nodeColor) {
    final textColor = _getTextColor(nodeColor);
    
    // Use rich text if spans are available, otherwise fallback to plain text
    if (widget.node.textSpans.isNotEmpty) {
      return RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          style: TextStyle(
            color: textColor,
            fontSize: widget.node.fontSize,
            height: 1.4,
            letterSpacing: 0.2,
            shadows: [
              Shadow(
                color: Colors.black.withValues(alpha: 0.1),
                offset: const Offset(0, 1),
                blurRadius: 2,
              ),
            ],
          ),
          children: widget.node.textSpans.map((span) {
            return TextSpan(
              text: span.text,
              style: TextStyle(
                fontWeight: span.isBold ? FontWeight.w700 : FontWeight.w500,
              ),
            );
          }).toList(),
        ),
      );
    }
    
    // Fallback to plain text for backwards compatibility
    return Text(
      widget.node.text,
      textAlign: TextAlign.center,
      style: TextStyle(
        color: textColor,
        fontSize: widget.node.fontSize,
        height: 1.4,
        fontWeight: widget.node.isBold
            ? FontWeight.w700
            : FontWeight.w500,
        letterSpacing: 0.2,
        shadows: [
          Shadow(
            color: Colors.black.withValues(alpha: 0.1),
            offset: const Offset(0, 1),
            blurRadius: 2,
          ),
        ],
      ),
    );
  }
}
