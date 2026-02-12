import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thinknode/features/auth/data/auth_repository.dart';
import 'package:thinknode/features/mindmap/data/mindmap_repository.dart';
import 'package:thinknode/features/mindmap/domain/models/cursor_presence_model.dart';
import 'package:thinknode/features/mindmap/domain/models/edge_model.dart';
import 'package:thinknode/features/mindmap/domain/models/node_model.dart';
import 'package:thinknode/features/mindmap/presentation/providers/canvas_state_provider.dart';
import 'package:thinknode/features/mindmap/presentation/providers/mindmap_providers.dart';
import 'package:thinknode/features/mindmap/presentation/widgets/edge_editor_dialog.dart';
import 'package:thinknode/features/mindmap/presentation/widgets/edge_painter.dart';
import 'package:thinknode/features/mindmap/presentation/widgets/grid_painter.dart';
import 'package:thinknode/features/mindmap/presentation/widgets/node_editor_dialog.dart';
import 'package:thinknode/features/mindmap/presentation/widgets/node_widget.dart';

/// The main infinite canvas where the mindmap is rendered.
/// Uses InteractiveViewer for zoom/pan with CustomPainter for edges.
///
/// Performance: Node dragging and resizing use LOCAL state only.
/// Firestore is updated once on drag/resize END, not on every pixel.
class MindmapCanvas extends ConsumerStatefulWidget {
  final String mindmapId;
  final GlobalKey repaintBoundaryKey;

  const MindmapCanvas({
    super.key,
    required this.mindmapId,
    required this.repaintBoundaryKey,
  });

  @override
  ConsumerState<MindmapCanvas> createState() => _MindmapCanvasState();
}

class _MindmapCanvasState extends ConsumerState<MindmapCanvas> {
  final TransformationController _transformationController =
      TransformationController();

  // =========== LOCAL DRAG STATE (never touches Firestore during drag) ===========
  bool _isDraggingNode = false;

  /// Local position overrides during drag. Key = nodeId, Value = current Offset(x, y).
  /// Only the node being dragged has an entry here.
  final Map<String, Offset> _localNodePositions = {};

  /// Local size overrides during resize.
  final Map<String, Size> _localNodeSizes = {};

  // For tracking presence
  DateTime _lastPresenceUpdate = DateTime.now();

  // Debounce zoom updates
  double _lastReportedZoom = 1.0;

  @override
  void dispose() {
    _transformationController.dispose();
    // Note: ref should not be used after dispose. Presence cleanup is handled
    // by Firestore TTL or server-side logic.
    super.dispose();
  }

  // =========== PRESENCE (throttled to 1s) ===========

  void _updatePresence(Offset position) {
    final now = DateTime.now();
    if (now.difference(_lastPresenceUpdate).inMilliseconds < 1000) return;
    _lastPresenceUpdate = now;

    final user = ref.read(authStateProvider).value;
    if (user == null) return;

    ref.read(mindmapRepositoryProvider).updatePresence(
          mindmapId: widget.mindmapId,
          presence: CursorPresenceModel(
            userId: user.uid,
            displayName: user.displayName ?? user.email ?? 'Anonym',
            color: (user.uid.hashCode & 0x00FFFFFF) | 0xFF000000,
            x: position.dx,
            y: position.dy,
            lastSeen: now,
          ),
        );
  }

  // =========== CANVAS TAP ===========

  void _handleCanvasTap(TapDownDetails details) {
    final canvasState = ref.read(canvasStateProvider);

    if (canvasState.activeTool == EditorTool.addNode) {
      _addNodeAtPosition(details.localPosition);
    } else if (canvasState.activeTool == EditorTool.connect &&
        canvasState.connectingFromNodeId != null) {
      // Tapped on empty space while connecting → cancel connection
      ref.read(canvasStateProvider.notifier).endConnecting();
    } else {
      // Try to select an edge at this position
      final matrix = _transformationController.value.clone()..invert();
      final canvasPos = MatrixUtils.transformPoint(matrix, details.localPosition);
      final edges = ref.read(edgesProvider(widget.mindmapId)).value ?? [];
      final nodes = ref.read(nodesProvider(widget.mindmapId)).value ?? [];
      final nodeMap = {for (final n in nodes) n.id: n};

      final tappedEdge = _findEdgeAtPosition(canvasPos, edges, nodeMap);
      if (tappedEdge != null) {
        if (canvasState.selectedEdgeId == tappedEdge.id) {
          // Already selected → open editor
          _showEdgeEditor(tappedEdge);
        } else {
          ref.read(canvasStateProvider.notifier).selectEdge(tappedEdge.id);
        }
      } else {
        ref.read(canvasStateProvider.notifier).clearSelection();
      }
    }
  }

  /// Find an edge near the given canvas position (within threshold)
  EdgeModel? _findEdgeAtPosition(
    Offset position,
    List<EdgeModel> edges,
    Map<String, NodeModel> nodeMap,
  ) {
    const threshold = 12.0;

    for (final edge in edges) {
      final source = nodeMap[edge.sourceNodeId];
      final target = nodeMap[edge.targetNodeId];
      if (source == null || target == null) continue;

      final start = Offset(
        source.x + source.width / 2,
        source.y + source.height / 2,
      );
      final end = Offset(
        target.x + target.width / 2,
        target.y + target.height / 2,
      );

      final dist = _distanceToLine(position, start, end);
      if (dist < threshold) return edge;
    }
    return null;
  }

  void _handleCanvasDoubleTap(
    TapDownDetails details,
    List<EdgeModel> edges,
    List<NodeModel> nodes,
  ) {
    final matrix = _transformationController.value.clone()..invert();
    final canvasPos = MatrixUtils.transformPoint(matrix, details.localPosition);
    final nodeMap = {for (final n in nodes) n.id: n};

    final tappedEdge = _findEdgeAtPosition(canvasPos, edges, nodeMap);
    if (tappedEdge != null) {
      _showEdgeEditor(tappedEdge);
    }
  }

  double _distanceToLine(Offset point, Offset lineStart, Offset lineEnd) {
    final dx = lineEnd.dx - lineStart.dx;
    final dy = lineEnd.dy - lineStart.dy;
    final lenSq = dx * dx + dy * dy;
    if (lenSq == 0) return (point - lineStart).distance;

    final t = ((point.dx - lineStart.dx) * dx + (point.dy - lineStart.dy) * dy) / lenSq;
    final clampedT = t.clamp(0.0, 1.0);
    final projection = Offset(
      lineStart.dx + clampedT * dx,
      lineStart.dy + clampedT * dy,
    );
    return (point - projection).distance;
  }

  Future<void> _addNodeAtPosition(Offset position) async {
    final user = ref.read(authStateProvider).value;
    if (user == null) return;

    final matrix = _transformationController.value.clone()..invert();
    final canvasPosition = MatrixUtils.transformPoint(matrix, position);

    final node = await ref.read(mindmapRepositoryProvider).createNode(
          mindmapId: widget.mindmapId,
          x: canvasPosition.dx - 80,
          y: canvasPosition.dy - 40,
          createdBy: user.uid,
        );

    ref.read(canvasStateProvider.notifier).setTool(EditorTool.select);
    ref.read(canvasStateProvider.notifier).selectNode(node.id);

    if (mounted) {
      _showQuickRenameDialog(node);
    }
  }

  Future<void> _showQuickRenameDialog(NodeModel node) async {
    final controller = TextEditingController(text: node.text);
    controller.selection = TextSelection(
      baseOffset: 0,
      extentOffset: controller.text.length,
    );

    final newName = await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Knoten benennen'),
        content: TextField(
          controller: controller,
          autofocus: true,
          maxLines: null,
          minLines: 1,
          keyboardType: TextInputType.multiline,
          decoration: const InputDecoration(
            hintText: 'Name eingeben...\n(Enter für neue Zeile)',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Abbrechen'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, controller.text.trim()),
            child: const Text('OK'),
          ),
        ],
      ),
    );

    if (newName != null && newName.isNotEmpty && newName != node.text) {
      await ref
          .read(mindmapRepositoryProvider)
          .updateNode(node.copyWith(text: newName));
    }
  }

  // =========== NODE DRAG (LOCAL STATE ONLY, Firestore on end) ===========

  void _handleNodeDragStart(NodeModel node) {
    setState(() {
      _isDraggingNode = true;
      _localNodePositions[node.id] = Offset(node.x, node.y);
    });
    ref.read(canvasStateProvider.notifier).selectNode(node.id);
  }

  void _handleNodeDrag(String nodeId, Offset delta) {
    final scale = _transformationController.value.getMaxScaleOnAxis();
    final scaledDelta = delta / scale;

    setState(() {
      final current = _localNodePositions[nodeId];
      if (current != null) {
        _localNodePositions[nodeId] =
            Offset(current.dx + scaledDelta.dx, current.dy + scaledDelta.dy);
      }
    });
  }

  Future<void> _handleNodeDragEnd(String nodeId) async {
    final finalPos = _localNodePositions[nodeId];
    setState(() {
      _isDraggingNode = false;
      _localNodePositions.remove(nodeId);
    });

    if (finalPos != null) {
      // Single Firestore write at the end
      await ref.read(mindmapRepositoryProvider).updateNodePosition(
            mindmapId: widget.mindmapId,
            nodeId: nodeId,
            x: finalPos.dx,
            y: finalPos.dy,
          );
    }
  }

  // =========== NODE RESIZE (LOCAL STATE ONLY, Firestore on end) ===========

  void _handleNodeResizeStart(NodeModel node) {
    setState(() {
      _localNodeSizes[node.id] = Size(node.width, node.height);
    });
  }

  void _handleNodeResize(String nodeId, Offset delta) {
    final scale = _transformationController.value.getMaxScaleOnAxis();
    final scaledDelta = delta / scale;

    setState(() {
      final current = _localNodeSizes[nodeId];
      if (current != null) {
        _localNodeSizes[nodeId] = Size(
          (current.width + scaledDelta.dx).clamp(80.0, 500.0),
          (current.height + scaledDelta.dy).clamp(40.0, 400.0),
        );
      }
    });
  }

  Future<void> _handleNodeResizeEnd(String nodeId) async {
    final finalSize = _localNodeSizes[nodeId];
    setState(() {
      _localNodeSizes.remove(nodeId);
    });

    if (finalSize != null) {
      await ref.read(mindmapRepositoryProvider).updateNodeSize(
            mindmapId: widget.mindmapId,
            nodeId: nodeId,
            width: finalSize.width,
            height: finalSize.height,
          );
    }
  }

  // =========== CONNECTIONS ===========

  /// Whether we are currently in a drag-to-connect operation.
  bool get _isConnecting =>
      ref.read(canvasStateProvider).connectingFromNodeId != null;

  void _handleStartConnect(String nodeId, Offset position) {
    setState(() => _isDraggingNode = true); // Block InteractiveViewer panning
    ref.read(canvasStateProvider.notifier).startConnecting(nodeId, position);
  }

  /// Called by the Listener on every pointer move. If we're connecting,
  /// transform the screen position to canvas coordinates and update the
  /// temporary drag line.
  void _handlePointerMoveForConnect(PointerMoveEvent event) {
    if (!_isConnecting) return;
    final matrix = _transformationController.value.clone()..invert();
    final canvasPos =
        MatrixUtils.transformPoint(matrix, event.localPosition);
    ref.read(canvasStateProvider.notifier).updateConnectingDrag(canvasPos);
  }

  /// Called by the Listener when the pointer is released. If we're connecting,
  /// check whether the pointer is over a target node and create the edge.
  void _handlePointerUpForConnect(PointerUpEvent event) {
    if (!_isConnecting) return;
    final matrix = _transformationController.value.clone()..invert();
    final canvasPos =
        MatrixUtils.transformPoint(matrix, event.localPosition);
    final nodes = ref.read(nodesProvider(widget.mindmapId)).value ?? [];
    final sourceId = ref.read(canvasStateProvider).connectingFromNodeId;

    final targetNode = _findNodeAtPosition(canvasPos, nodes);

    setState(() => _isDraggingNode = false); // Re-enable panning

    if (targetNode != null && targetNode.id != sourceId) {
      _handleEndConnect(targetNode.id);
    } else {
      ref.read(canvasStateProvider.notifier).endConnecting();
    }
  }

  /// Find a node whose bounding rect contains [position] (canvas coords).
  NodeModel? _findNodeAtPosition(Offset position, List<NodeModel> nodes) {
    for (final node in nodes) {
      final rect = Rect.fromLTWH(node.x, node.y, node.width, node.height);
      // Use a slightly larger hit area for easier targeting
      final expanded = rect.inflate(8);
      if (expanded.contains(position)) return node;
    }
    return null;
  }

  Future<void> _handleEndConnect(String targetNodeId) async {
    final canvasState = ref.read(canvasStateProvider);
    final sourceNodeId = canvasState.connectingFromNodeId;

    if (sourceNodeId == null || sourceNodeId == targetNodeId) {
      ref.read(canvasStateProvider.notifier).endConnecting();
      return;
    }

    final user = ref.read(authStateProvider).value;
    if (user == null) return;

    final edge = await ref.read(mindmapRepositoryProvider).createEdge(
          mindmapId: widget.mindmapId,
          sourceNodeId: sourceNodeId,
          targetNodeId: targetNodeId,
          createdBy: user.uid,
        );

    ref.read(canvasStateProvider.notifier).endConnecting();

    // Show edge editor immediately after creation
    if (mounted) {
      _showEdgeEditor(edge);
    }
  }

  void _showEdgeEditor(EdgeModel edge) {
    showDialog(
      context: context,
      builder: (context) => EdgeEditorDialog(
        edge: edge,
        onSave: (updatedEdge) {
          ref.read(mindmapRepositoryProvider).updateEdge(updatedEdge);
        },
        onDelete: () {
          ref.read(mindmapRepositoryProvider).deleteEdge(
                mindmapId: widget.mindmapId,
                edgeId: edge.id,
              );
          ref.read(canvasStateProvider.notifier).clearSelection();
        },
      ),
    );
  }

  // =========== NODE ACTIONS ===========

  Future<void> _handleDeleteNode(String nodeId) async {
    await ref.read(mindmapRepositoryProvider).deleteNode(
          mindmapId: widget.mindmapId,
          nodeId: nodeId,
        );
  }

  void _showNodeEditor(NodeModel node) {
    showDialog(
      context: context,
      builder: (context) => NodeEditorDialog(
        node: node,
        onSave: (updatedNode) {
          ref.read(mindmapRepositoryProvider).updateNode(updatedNode);
        },
      ),
    );
  }

  void _showNodeContextMenu(NodeModel node) {
    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;

    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(
        node.x + node.width,
        node.y,
        overlay.size.width - node.x,
        overlay.size.height - node.y,
      ),
      items: [
        const PopupMenuItem(
          value: 'edit',
          child: ListTile(
            leading: Icon(Icons.edit),
            title: Text('Bearbeiten'),
            dense: true,
          ),
        ),
        const PopupMenuItem(
          value: 'duplicate',
          child: ListTile(
            leading: Icon(Icons.copy),
            title: Text('Duplizieren'),
            dense: true,
          ),
        ),
        const PopupMenuItem(
          value: 'delete',
          child: ListTile(
            leading: Icon(Icons.delete, color: Colors.red),
            title: Text('Löschen', style: TextStyle(color: Colors.red)),
            dense: true,
          ),
        ),
      ],
    ).then((value) {
      switch (value) {
        case 'edit':
          _showNodeEditor(node);
          break;
        case 'duplicate':
          _duplicateNode(node);
          break;
        case 'delete':
          _handleDeleteNode(node.id);
          break;
      }
    });
  }

  Future<void> _duplicateNode(NodeModel node) async {
    final user = ref.read(authStateProvider).value;
    if (user == null) return;

    await ref.read(mindmapRepositoryProvider).createNode(
          mindmapId: widget.mindmapId,
          x: node.x + 40,
          y: node.y + 40,
          createdBy: user.uid,
          text: '${node.text} (Kopie)',
          color: node.color,
          shape: node.shape,
        );
  }

  /// Apply local overrides to a node (for drag/resize in progress)
  NodeModel _applyLocalOverrides(NodeModel node) {
    NodeModel result = node;
    final localPos = _localNodePositions[node.id];
    if (localPos != null) {
      result = result.copyWith(x: localPos.dx, y: localPos.dy);
    }
    final localSize = _localNodeSizes[node.id];
    if (localSize != null) {
      result = result.copyWith(width: localSize.width, height: localSize.height);
    }
    return result;
  }

  // =========== BUILD ===========

  @override
  Widget build(BuildContext context) {
    final nodesAsync = ref.watch(nodesProvider(widget.mindmapId));
    final edgesAsync = ref.watch(edgesProvider(widget.mindmapId));
    final presenceAsync = ref.watch(presenceProvider(widget.mindmapId));
    final canvasState = ref.watch(canvasStateProvider);
    final theme = Theme.of(context);
    final currentUser = ref.watch(authStateProvider).value;

    // Apply local position/size overrides for smooth dragging
    final nodes = (nodesAsync.value ?? [])
        .map(_applyLocalOverrides)
        .toList(growable: false);
    final edges = edgesAsync.value ?? [];
    final presences = (presenceAsync.value ?? [])
        .where((p) => p.userId != currentUser?.uid)
        .toList(growable: false);

    return RepaintBoundary(
      key: widget.repaintBoundaryKey,
      child: Listener(
        onPointerHover: (event) => _updatePresence(event.localPosition),
        // Raw pointer tracking for drag-to-connect (bypasses gesture arena)
        onPointerMove: _handlePointerMoveForConnect,
        onPointerUp: _handlePointerUpForConnect,
        child: GestureDetector(
          onTapDown: _handleCanvasTap,
          onDoubleTapDown: (details) => _handleCanvasDoubleTap(details, edges, nodes),
          child: InteractiveViewer(
            transformationController: _transformationController,
            constrained: false,
            boundaryMargin: const EdgeInsets.all(double.infinity),
            minScale: 0.1,
            maxScale: 5.0,
            panEnabled: !_isDraggingNode &&
                (canvasState.activeTool == EditorTool.pan ||
                    canvasState.activeTool == EditorTool.select),
            scaleEnabled: !_isDraggingNode,
            onInteractionUpdate: (_) {
              // Only update state if zoom actually changed significantly
              final newZoom =
                  _transformationController.value.getMaxScaleOnAxis();
              if ((newZoom - _lastReportedZoom).abs() > 0.01) {
                _lastReportedZoom = newZoom;
                ref.read(canvasStateProvider.notifier).setZoom(newZoom);
              }
            },
            child: SizedBox(
              width: 10000,
              height: 10000,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  // Grid background
                  if (canvasState.showGrid)
                    Positioned.fill(
                      child: RepaintBoundary(
                        child: CustomPaint(
                          painter: GridPainter(
                            dotColor: theme.brightness == Brightness.dark
                                ? Colors.white24
                                : Colors.black12,
                            transform: _transformationController.value,
                          ),
                        ),
                      ),
                    ),

                  // Edges layer
                  Positioned.fill(
                    child: RepaintBoundary(
                      child: CustomPaint(
                        painter: EdgePainter(
                          edges: edges,
                          nodes: nodes,
                          selectedEdgeId: canvasState.selectedEdgeId,
                          connectingFromNodeId:
                              canvasState.connectingFromNodeId,
                          dragStart: canvasState.dragStartPosition,
                          dragEnd: canvasState.currentDragPosition,
                        ),
                      ),
                    ),
                  ),

                  // Nodes layer
                  for (final node in nodes)
                    NodeWidget(
                      key: ValueKey(node.id),
                      node: node,
                      isSelected: canvasState.selectedNodeId == node.id,
                      onTap: () => ref
                          .read(canvasStateProvider.notifier)
                          .selectNode(node.id),
                      onDoubleTap: () => _showNodeEditor(node),
                      onLongPress: () => _showNodeContextMenu(node),
                      onDragStart: () => _handleNodeDragStart(node),
                      onDrag: (delta) => _handleNodeDrag(node.id, delta),
                      onDragEnd: () => _handleNodeDragEnd(node.id),
                      onResizeStart: () => _handleNodeResizeStart(node),
                      onResize: (delta) => _handleNodeResize(node.id, delta),
                      onResizeEnd: () => _handleNodeResizeEnd(node.id),
                      onStartConnect: _handleStartConnect,
                      onEndConnect: _handleEndConnect,
                      onDelete: () => _handleDeleteNode(node.id),
                    ),

                  // Selected edge edit button
                  if (canvasState.selectedEdgeId != null)
                    ..._buildEdgeEditButton(
                        canvasState.selectedEdgeId!, edges, nodes),

                  // Cursor presence from other users
                  for (final presence in presences)
                    Positioned(
                      left: presence.x - 8,
                      top: presence.y - 8,
                      child: _buildCursorPresence(presence),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildEdgeEditButton(
      String edgeId, List<EdgeModel> edges, List<NodeModel> nodes) {
    final edge = edges.where((e) => e.id == edgeId).firstOrNull;
    if (edge == null) return [];

    final nodeMap = {for (final n in nodes) n.id: n};
    final source = nodeMap[edge.sourceNodeId];
    final target = nodeMap[edge.targetNodeId];
    if (source == null || target == null) return [];

    final midX = (source.x + source.width / 2 + target.x + target.width / 2) / 2;
    final midY = (source.y + source.height / 2 + target.y + target.height / 2) / 2;

    return [
      Positioned(
        left: midX - 20,
        top: midY - 36,
        child: GestureDetector(
          onTap: () => _showEdgeEditor(edge),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.edit,
                  size: 14,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
                const SizedBox(width: 4),
                Text(
                  'Bearbeiten',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ];
  }

  Widget _buildCursorPresence(CursorPresenceModel presence) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          Icons.near_me,
          color: Color(presence.color),
          size: 20,
        ),
        Container(
          margin: const EdgeInsets.only(left: 12),
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: Color(presence.color),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            presence.displayName,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
