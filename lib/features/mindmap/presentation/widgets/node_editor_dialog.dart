import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:thinknode/core/theme/app_theme.dart';
import 'package:thinknode/features/mindmap/domain/models/node_model.dart';
import 'package:thinknode/features/mindmap/presentation/widgets/rich_text_editor.dart';

/// Dialog for editing node properties (text, color, shape, bold, notes)
class NodeEditorDialog extends StatefulWidget {
  final NodeModel node;
  final Function(NodeModel updatedNode) onSave;

  const NodeEditorDialog({
    super.key,
    required this.node,
    required this.onSave,
  });

  @override
  State<NodeEditorDialog> createState() => _NodeEditorDialogState();
}

class _NodeEditorDialogState extends State<NodeEditorDialog>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  late final TextEditingController _notesController;
  late Color _selectedColor;
  late NodeShape _selectedShape;
  late List<TextSpanData> _textSpans;
  late double _fontSize;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _notesController = TextEditingController(text: widget.node.notes);
    _selectedColor = Color(widget.node.color);
    _selectedShape = widget.node.shape;
    _fontSize = widget.node.fontSize;
    
    // Initialize text spans
    if (widget.node.textSpans.isEmpty) {
      // Convert old text to spans
      _textSpans = [TextSpanData(text: widget.node.text, isBold: widget.node.isBold)];
    } else {
      _textSpans = List.from(widget.node.textSpans);
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _handleSave() {
    // Get plain text from spans
    final plainText = _textSpans.map((s) => s.text).join();
    final text = plainText.trim().isEmpty ? 'Neuer Knoten' : plainText.trim();
    
    // Update text spans if empty
    final finalSpans = _textSpans.isEmpty || plainText.trim().isEmpty
        ? [const TextSpanData(text: 'Neuer Knoten', isBold: false)]
        : _textSpans;
    
    // No need to calculate height here - NodeWidget will do it automatically
    final updated = widget.node.copyWith(
      text: text,
      textSpans: finalSpans,
      fontSize: _fontSize,
      notes: _notesController.text.trim(),
      color: _selectedColor.toARGB32(),
      shape: _selectedShape,
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
        constraints: const BoxConstraints(maxWidth: 500, maxHeight: 650),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 16, 0),
              child: Row(
                children: [
                  Text(
                    'Knoten bearbeiten',
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

            // Tabs
            TabBar(
              controller: _tabController,
              tabs: const [
                Tab(icon: Icon(Icons.text_fields), text: 'Text'),
                Tab(icon: Icon(Icons.palette), text: 'Farbe'),
                Tab(icon: Icon(Icons.shape_line), text: 'Form'),
              ],
            ),

            // Tab content
            Flexible(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // Text Tab with Rich Text Editor
                  SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Rich text editor
                        RichTextEditor(
                          initialSpans: _textSpans,
                          fontSize: _fontSize,
                          onChanged: (spans) {
                            setState(() => _textSpans = spans);
                          },
                          onFontSizeChanged: (size) {
                            setState(() => _fontSize = size);
                          },
                        ),
                        const SizedBox(height: 24),

                        // Notes
                        TextFormField(
                          controller: _notesController,
                          maxLines: null,
                          minLines: 2,
                          keyboardType: TextInputType.multiline,
                          decoration: const InputDecoration(
                            labelText: 'Notizen (optional)',
                            hintText: 'Zusätzliche Notizen...',
                            alignLabelWithHint: true,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Color Tab
                  SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        // Quick color palette
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: AppTheme.nodeColors.map((color) {
                            final isSelected =
                                color.toARGB32() == _selectedColor.toARGB32();
                            return GestureDetector(
                              onTap: () =>
                                  setState(() => _selectedColor = color),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  color: color,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: isSelected
                                        ? Colors.white
                                        : Colors.transparent,
                                    width: 3,
                                  ),
                                  boxShadow: isSelected
                                      ? [
                                          BoxShadow(
                                            color:
                                                color.withValues(alpha: 0.5),
                                            blurRadius: 8,
                                            spreadRadius: 2,
                                          )
                                        ]
                                      : null,
                                ),
                                child: isSelected
                                    ? const Icon(Icons.check,
                                        color: Colors.white, size: 24)
                                    : null,
                              ),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 24),
                        // Custom color picker
                        SizedBox(
                          height: 200,
                          child: HueRingPicker(
                            pickerColor: _selectedColor,
                            onColorChanged: (color) =>
                                setState(() => _selectedColor = color),
                            enableAlpha: false,
                            displayThumbColor: true,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Shape Tab
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        _buildShapeOption(
                          NodeShape.roundedRectangle,
                          'Abgerundetes Rechteck',
                          Icons.rounded_corner,
                        ),
                        const SizedBox(height: 12),
                        _buildShapeOption(
                          NodeShape.rectangle,
                          'Rechteck',
                          Icons.rectangle_outlined,
                        ),
                        const SizedBox(height: 12),
                        _buildShapeOption(
                          NodeShape.circle,
                          'Kreis',
                          Icons.circle_outlined,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Actions
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
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

  Widget _buildShapeOption(NodeShape shape, String label, IconData icon) {
    final isSelected = _selectedShape == shape;
    final theme = Theme.of(context);

    return InkWell(
      onTap: () => setState(() => _selectedShape = shape),
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? theme.colorScheme.primary
                : theme.dividerColor,
            width: isSelected ? 2 : 1,
          ),
          color: isSelected
              ? theme.colorScheme.primary.withValues(alpha: 0.08)
              : null,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected
                  ? theme.colorScheme.primary
                  : theme.iconTheme.color,
            ),
            const SizedBox(width: 16),
            Text(
              label,
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                color: isSelected ? theme.colorScheme.primary : null,
              ),
            ),
            const Spacer(),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: theme.colorScheme.primary,
              ),
          ],
        ),
      ),
    );
  }
}
