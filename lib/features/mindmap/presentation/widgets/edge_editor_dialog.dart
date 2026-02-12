import 'package:flutter/material.dart';
import 'package:thinknode/features/mindmap/domain/models/edge_model.dart';

/// Dialog for editing edge properties (label, type, style, arrow mode, color)
class EdgeEditorDialog extends StatefulWidget {
  final EdgeModel edge;
  final Function(EdgeModel updatedEdge) onSave;
  final VoidCallback onDelete;

  const EdgeEditorDialog({
    super.key,
    required this.edge,
    required this.onSave,
    required this.onDelete,
  });

  @override
  State<EdgeEditorDialog> createState() => _EdgeEditorDialogState();
}

class _EdgeEditorDialogState extends State<EdgeEditorDialog> {
  late final TextEditingController _labelController;
  late EdgeType _selectedType;
  late EdgeStyle _selectedStyle;
  late ArrowMode _selectedArrowMode;

  @override
  void initState() {
    super.initState();
    _labelController = TextEditingController(text: widget.edge.label);
    _selectedType = widget.edge.type;
    _selectedStyle = widget.edge.style;
    _selectedArrowMode = widget.edge.arrowMode;
  }

  @override
  void dispose() {
    _labelController.dispose();
    super.dispose();
  }

  void _handleSave() {
    final updated = widget.edge.copyWith(
      label: _labelController.text.trim(),
      type: _selectedType,
      style: _selectedStyle,
      arrowMode: _selectedArrowMode,
      updatedAt: DateTime.now(),
    );
    widget.onSave(updated);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dialog(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 450, maxHeight: 580),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 16, 0),
              child: Row(
                children: [
                  Text(
                    'Verbindung bearbeiten',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Label field
                    TextFormField(
                      controller: _labelController,
                      decoration: const InputDecoration(
                        labelText: 'Beschriftung',
                        hintText: 'Text für die Verbindung...',
                        prefixIcon: Icon(Icons.label_outline),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Arrow Mode
                    Text(
                      'Pfeilrichtung',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildArrowModeSelector(theme),
                    const SizedBox(height: 24),

                    // Line Type
                    Text(
                      'Linientyp',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildLineTypeSelector(theme),
                    const SizedBox(height: 24),

                    // Line Style
                    Text(
                      'Linienstil',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildLineStyleSelector(theme),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),

            // Actions
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // Delete button
                  TextButton.icon(
                    onPressed: () {
                      widget.onDelete();
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                    label: const Text(
                      'Löschen',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Abbrechen'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: _handleSave,
                    child: const Text('Speichern'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildArrowModeSelector(ThemeData theme) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        _buildOptionChip(
          label: 'Vorwärts →',
          icon: Icons.arrow_forward,
          isSelected: _selectedArrowMode == ArrowMode.forward,
          onTap: () => setState(() => _selectedArrowMode = ArrowMode.forward),
          theme: theme,
        ),
        _buildOptionChip(
          label: '← Rückwärts',
          icon: Icons.arrow_back,
          isSelected: _selectedArrowMode == ArrowMode.backward,
          onTap: () => setState(() => _selectedArrowMode = ArrowMode.backward),
          theme: theme,
        ),
        _buildOptionChip(
          label: '↔ Beide',
          icon: Icons.swap_horiz,
          isSelected: _selectedArrowMode == ArrowMode.both,
          onTap: () => setState(() => _selectedArrowMode = ArrowMode.both),
          theme: theme,
        ),
        _buildOptionChip(
          label: 'Keine',
          icon: Icons.remove,
          isSelected: _selectedArrowMode == ArrowMode.none,
          onTap: () => setState(() => _selectedArrowMode = ArrowMode.none),
          theme: theme,
        ),
      ],
    );
  }

  Widget _buildLineTypeSelector(ThemeData theme) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        _buildOptionChip(
          label: 'Einfach',
          icon: Icons.horizontal_rule,
          isSelected: _selectedType == EdgeType.simple,
          onTap: () => setState(() => _selectedType = EdgeType.simple),
          theme: theme,
        ),
        _buildOptionChip(
          label: 'Doppelt',
          icon: Icons.drag_handle,
          isSelected: _selectedType == EdgeType.double,
          onTap: () => setState(() => _selectedType = EdgeType.double),
          theme: theme,
        ),
        _buildOptionChip(
          label: 'Gestrichelt',
          icon: Icons.more_horiz,
          isSelected: _selectedType == EdgeType.dashed,
          onTap: () => setState(() => _selectedType = EdgeType.dashed),
          theme: theme,
        ),
      ],
    );
  }

  Widget _buildLineStyleSelector(ThemeData theme) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        _buildOptionChip(
          label: 'Gerade',
          icon: Icons.show_chart,
          isSelected: _selectedStyle == EdgeStyle.straight,
          onTap: () => setState(() => _selectedStyle = EdgeStyle.straight),
          theme: theme,
        ),
        _buildOptionChip(
          label: 'Gebogen',
          icon: Icons.timeline,
          isSelected: _selectedStyle == EdgeStyle.curved,
          onTap: () => setState(() => _selectedStyle = EdgeStyle.curved),
          theme: theme,
        ),
      ],
    );
  }

  Widget _buildOptionChip({
    required String label,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
    required ThemeData theme,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: isSelected
              ? theme.colorScheme.primary.withValues(alpha: 0.12)
              : theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
          border: Border.all(
            color: isSelected
                ? theme.colorScheme.primary
                : theme.dividerColor,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 18,
              color: isSelected
                  ? theme.colorScheme.primary
                  : theme.iconTheme.color,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                color: isSelected ? theme.colorScheme.primary : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

