import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Available tools in the editor toolbar
enum EditorTool {
  select,
  addNode,
  connect,
  delete,
  pan,
}

/// State of the mindmap canvas/editor
class CanvasState {
  final EditorTool activeTool;
  final String? selectedNodeId;
  final String? selectedEdgeId;
  final String? connectingFromNodeId; // When creating an edge
  final Offset? dragStartPosition; // Temp position during edge creation
  final Offset? currentDragPosition;
  final bool showGrid;
  final bool isDarkMode;
  final double zoom;

  const CanvasState({
    this.activeTool = EditorTool.select,
    this.selectedNodeId,
    this.selectedEdgeId,
    this.connectingFromNodeId,
    this.dragStartPosition,
    this.currentDragPosition,
    this.showGrid = true,
    this.isDarkMode = false,
    this.zoom = 1.0,
  });

  CanvasState copyWith({
    EditorTool? activeTool,
    String? selectedNodeId,
    String? selectedEdgeId,
    String? connectingFromNodeId,
    Offset? dragStartPosition,
    Offset? currentDragPosition,
    bool? showGrid,
    bool? isDarkMode,
    double? zoom,
    bool clearSelectedNode = false,
    bool clearSelectedEdge = false,
    bool clearConnecting = false,
    bool clearDragPositions = false,
  }) {
    return CanvasState(
      activeTool: activeTool ?? this.activeTool,
      selectedNodeId:
          clearSelectedNode ? null : (selectedNodeId ?? this.selectedNodeId),
      selectedEdgeId:
          clearSelectedEdge ? null : (selectedEdgeId ?? this.selectedEdgeId),
      connectingFromNodeId: clearConnecting
          ? null
          : (connectingFromNodeId ?? this.connectingFromNodeId),
      dragStartPosition: clearDragPositions
          ? null
          : (dragStartPosition ?? this.dragStartPosition),
      currentDragPosition: clearDragPositions
          ? null
          : (currentDragPosition ?? this.currentDragPosition),
      showGrid: showGrid ?? this.showGrid,
      isDarkMode: isDarkMode ?? this.isDarkMode,
      zoom: zoom ?? this.zoom,
    );
  }
}

/// Notifier for canvas state management
class CanvasStateNotifier extends StateNotifier<CanvasState> {
  CanvasStateNotifier() : super(const CanvasState());

  void setTool(EditorTool tool) {
    state = state.copyWith(
      activeTool: tool,
      clearConnecting: true,
      clearDragPositions: true,
    );
  }

  void selectNode(String? nodeId) {
    state = state.copyWith(
      selectedNodeId: nodeId,
      clearSelectedEdge: true,
      clearSelectedNode: nodeId == null,
    );
  }

  void selectEdge(String? edgeId) {
    state = state.copyWith(
      selectedEdgeId: edgeId,
      clearSelectedNode: true,
      clearSelectedEdge: edgeId == null,
    );
  }

  void clearSelection() {
    state = state.copyWith(
      clearSelectedNode: true,
      clearSelectedEdge: true,
      clearConnecting: true,
      clearDragPositions: true,
    );
  }

  void startConnecting(String fromNodeId, Offset startPosition) {
    state = state.copyWith(
      connectingFromNodeId: fromNodeId,
      dragStartPosition: startPosition,
    );
  }

  void updateConnectingDrag(Offset position) {
    state = state.copyWith(currentDragPosition: position);
  }

  void endConnecting() {
    state = state.copyWith(
      clearConnecting: true,
      clearDragPositions: true,
    );
  }

  void toggleGrid() {
    state = state.copyWith(showGrid: !state.showGrid);
  }

  void toggleDarkMode() {
    state = state.copyWith(isDarkMode: !state.isDarkMode);
  }

  void setZoom(double zoom) {
    state = state.copyWith(zoom: zoom.clamp(0.1, 5.0));
  }
}

/// Provider for canvas state
final canvasStateProvider =
    StateNotifierProvider<CanvasStateNotifier, CanvasState>((ref) {
  return CanvasStateNotifier();
});

/// Provider for theme mode
final themeModeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.system);

