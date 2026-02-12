import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thinknode/features/mindmap/presentation/providers/canvas_state_provider.dart';

/// Floating toolbar for the mindmap editor with tool selection
class ToolbarWidget extends ConsumerWidget {
  final VoidCallback onAddNode;
  final VoidCallback onExportPng;
  final VoidCallback onExportPdf;
  final VoidCallback onSaveVersion;
  final VoidCallback onShowVersions;

  const ToolbarWidget({
    super.key,
    required this.onAddNode,
    required this.onExportPng,
    required this.onExportPdf,
    required this.onSaveVersion,
    required this.onShowVersions,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final canvasState = ref.watch(canvasStateProvider);
    final theme = Theme.of(context);

    return Positioned(
      left: 16,
      top: 16,
      child: SafeArea(
        child: Column(
          children: [
            // Main tool buttons
            Card(
              elevation: 4,
              shadowColor: Colors.black26,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildToolButton(
                      ref: ref,
                      icon: Icons.near_me,
                      tooltip: 'Auswählen',
                      tool: EditorTool.select,
                      isActive: canvasState.activeTool == EditorTool.select,
                    ),
                    _buildToolButton(
                      ref: ref,
                      icon: Icons.pan_tool_outlined,
                      tooltip: 'Verschieben',
                      tool: EditorTool.pan,
                      isActive: canvasState.activeTool == EditorTool.pan,
                    ),
                    _buildDivider(theme),
                    _buildToolButton(
                      ref: ref,
                      icon: Icons.add_box_outlined,
                      tooltip: 'Knoten hinzufügen',
                      tool: EditorTool.addNode,
                      isActive: canvasState.activeTool == EditorTool.addNode,
                    ),
                    _buildToolButton(
                      ref: ref,
                      icon: Icons.trending_flat,
                      tooltip: 'Verbinden',
                      tool: EditorTool.connect,
                      isActive: canvasState.activeTool == EditorTool.connect,
                    ),
                    _buildToolButton(
                      ref: ref,
                      icon: Icons.delete_outline,
                      tooltip: 'Löschen',
                      tool: EditorTool.delete,
                      isActive: canvasState.activeTool == EditorTool.delete,
                      isDestructive: true,
                    ),
                    _buildDivider(theme),
                    _buildIconButton(
                      icon: canvasState.showGrid
                          ? Icons.grid_on
                          : Icons.grid_off,
                      tooltip: 'Raster ein/aus',
                      onPressed: () =>
                          ref.read(canvasStateProvider.notifier).toggleGrid(),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),

            // Export & Version buttons
            Card(
              elevation: 4,
              shadowColor: Colors.black26,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildIconButton(
                      icon: Icons.image_outlined,
                      tooltip: 'Als PNG exportieren',
                      onPressed: onExportPng,
                    ),
                    _buildIconButton(
                      icon: Icons.picture_as_pdf_outlined,
                      tooltip: 'Als PDF exportieren',
                      onPressed: onExportPdf,
                    ),
                    _buildDivider(theme),
                    _buildIconButton(
                      icon: Icons.save_outlined,
                      tooltip: 'Version speichern',
                      onPressed: onSaveVersion,
                    ),
                    _buildIconButton(
                      icon: Icons.history,
                      tooltip: 'Versionen anzeigen',
                      onPressed: onShowVersions,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToolButton({
    required WidgetRef ref,
    required IconData icon,
    required String tooltip,
    required EditorTool tool,
    required bool isActive,
    bool isDestructive = false,
  }) {
    return Tooltip(
      message: tooltip,
      preferBelow: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Material(
          color: isActive
              ? (isDestructive ? Colors.red.withValues(alpha: 0.1) : Colors.blue.withValues(alpha: 0.1))
              : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          child: InkWell(
            onTap: () => ref.read(canvasStateProvider.notifier).setTool(tool),
            borderRadius: BorderRadius.circular(10),
            child: Container(
              width: 44,
              height: 44,
              alignment: Alignment.center,
              child: Icon(
                icon,
                size: 22,
                color: isActive
                    ? (isDestructive ? Colors.red : Colors.blue)
                    : null,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIconButton({
    required IconData icon,
    required String tooltip,
    required VoidCallback onPressed,
  }) {
    return Tooltip(
      message: tooltip,
      preferBelow: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          child: InkWell(
            onTap: onPressed,
            borderRadius: BorderRadius.circular(10),
            child: Container(
              width: 44,
              height: 44,
              alignment: Alignment.center,
              child: Icon(icon, size: 22),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDivider(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: SizedBox(
        width: 28,
        child: Divider(color: theme.dividerColor, height: 1),
      ),
    );
  }
}

