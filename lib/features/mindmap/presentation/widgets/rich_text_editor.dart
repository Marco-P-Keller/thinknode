import 'package:flutter/material.dart';
import 'package:thinknode/features/mindmap/domain/models/node_model.dart';

/// A rich text editor with formatting toolbar
class RichTextEditor extends StatefulWidget {
  final List<TextSpanData> initialSpans;
  final double fontSize;
  final Function(List<TextSpanData> spans) onChanged;
  final Function(double fontSize) onFontSizeChanged;

  const RichTextEditor({
    super.key,
    required this.initialSpans,
    required this.fontSize,
    required this.onChanged,
    required this.onFontSizeChanged,
  });

  @override
  State<RichTextEditor> createState() => _RichTextEditorState();
}

class _RichTextEditorState extends State<RichTextEditor> {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  late List<TextSpanData> _spans;
  int _selectionStart = 0;
  int _selectionEnd = 0;

  @override
  void initState() {
    super.initState();
    _spans = List.from(widget.initialSpans);
    if (_spans.isEmpty) {
      _spans = [const TextSpanData(text: '', isBold: false)];
    }
    _controller = TextEditingController(text: _getPlainText());
    _focusNode = FocusNode();
    
    _controller.addListener(_handleTextChange);
    
    // Auto-focus and select all
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
      _controller.selection = TextSelection(
        baseOffset: 0,
        extentOffset: _controller.text.length,
      );
    });
  }

  @override
  void dispose() {
    _controller.removeListener(_handleTextChange);
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  String _getPlainText() {
    return _spans.map((span) => span.text).join();
  }

  void _handleTextChange() {
    final newSelection = _controller.selection;
    _selectionStart = newSelection.start;
    _selectionEnd = newSelection.end;
    
    // Rebuild spans based on new text
    final newText = _controller.text;
    final oldText = _getPlainText();
    
    if (newText != oldText) {
      // Text changed, rebuild spans preserving formatting where possible
      _rebuildSpans(newText, oldText);
    }
  }

  void _rebuildSpans(String newText, String oldText) {
    if (newText.isEmpty) {
      setState(() {
        _spans = [const TextSpanData(text: '', isBold: false)];
      });
      widget.onChanged(_spans);
      return;
    }

    final oldLength = oldText.length;
    final newLength = newText.length;

    if (newLength > oldLength) {
      // Text added - insert at cursor position
      final insertPos = _selectionStart - (newLength - oldLength);
      final addedText = newText.substring(insertPos, _selectionStart);
      
      setState(() {
        _spans = _insertTextAtPosition(_spans, addedText, insertPos);
      });
    } else if (newLength < oldLength) {
      // Text removed
      final deleteStart = _selectionStart;
      final deleteCount = oldLength - newLength;
      
      setState(() {
        _spans = _deleteTextAtPosition(_spans, deleteStart, deleteCount);
      });
    }

    widget.onChanged(_spans);
  }

  List<TextSpanData> _insertTextAtPosition(
    List<TextSpanData> spans,
    String text,
    int position,
  ) {
    if (spans.isEmpty) {
      return [TextSpanData(text: text, isBold: false)];
    }

    final newSpans = <TextSpanData>[];
    int currentPos = 0;

    for (final span in spans) {
      final spanStart = currentPos;
      final spanEnd = currentPos + span.text.length;

      if (position >= spanStart && position <= spanEnd) {
        // Insert in this span
        final beforeText = span.text.substring(0, position - spanStart);
        final afterText = span.text.substring(position - spanStart);

        if (beforeText.isNotEmpty) {
          newSpans.add(span.copyWith(text: beforeText));
        }
        newSpans.add(span.copyWith(text: text));
        if (afterText.isNotEmpty) {
          newSpans.add(span.copyWith(text: afterText));
        }
      } else {
        newSpans.add(span);
      }

      currentPos = spanEnd;
    }

    // Merge adjacent spans with same formatting
    return _mergeAdjacentSpans(newSpans);
  }

  List<TextSpanData> _deleteTextAtPosition(
    List<TextSpanData> spans,
    int position,
    int count,
  ) {
    final newSpans = <TextSpanData>[];
    int currentPos = 0;

    for (final span in spans) {
      final spanStart = currentPos;
      final spanEnd = currentPos + span.text.length;

      if (spanEnd <= position || spanStart >= position + count) {
        // Span is outside deletion range
        newSpans.add(span);
      } else {
        // Span overlaps with deletion range
        final deleteStart = (position - spanStart).clamp(0, span.text.length);
        final deleteEnd =
            ((position + count) - spanStart).clamp(0, span.text.length);

        final beforeText = span.text.substring(0, deleteStart);
        final afterText = span.text.substring(deleteEnd);

        if (beforeText.isNotEmpty) {
          newSpans.add(span.copyWith(text: beforeText));
        }
        if (afterText.isNotEmpty) {
          newSpans.add(span.copyWith(text: afterText));
        }
      }

      currentPos = spanEnd;
    }

    return newSpans.isEmpty
        ? [const TextSpanData(text: '', isBold: false)]
        : _mergeAdjacentSpans(newSpans);
  }

  List<TextSpanData> _mergeAdjacentSpans(List<TextSpanData> spans) {
    if (spans.isEmpty) return spans;

    final merged = <TextSpanData>[];
    TextSpanData? current;

    for (final span in spans) {
      if (current == null) {
        current = span;
      } else if (current.isBold == span.isBold) {
        // Merge with current
        current = current.copyWith(text: current.text + span.text);
      } else {
        // Different formatting, add current and start new
        merged.add(current);
        current = span;
      }
    }

    if (current != null) {
      merged.add(current);
    }

    return merged;
  }

  void _toggleBold() {
    if (_selectionStart == _selectionEnd || _selectionStart < 0) {
      // No selection - show hint
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Markiere Text, um ihn fett zu machen'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }
    
    // Find which spans are affected and toggle their bold status
    int currentPos = 0;
    final newSpans = <TextSpanData>[];
    
    // Determine if selection is currently bold (check first span in selection)
    bool currentlyBold = false;
    for (final span in _spans) {
      final spanEnd = currentPos + span.text.length;
      if (currentPos < _selectionEnd && spanEnd > _selectionStart) {
        currentlyBold = span.isBold;
        break;
      }
      currentPos = spanEnd;
    }
    
    // Toggle to opposite of current state
    final targetBold = !currentlyBold;
    currentPos = 0;

    for (final span in _spans) {
      final spanStart = currentPos;
      final spanEnd = currentPos + span.text.length;

      if (spanEnd <= _selectionStart || spanStart >= _selectionEnd) {
        // Span is completely outside selection
        newSpans.add(span);
      } else if (spanStart >= _selectionStart && spanEnd <= _selectionEnd) {
        // Span is completely inside selection - apply target bold
        newSpans.add(span.copyWith(isBold: targetBold));
      } else {
        // Span is partially in selection - split it
        if (spanStart < _selectionStart) {
          // Part before selection keeps original formatting
          final beforeText = span.text.substring(0, _selectionStart - spanStart);
          if (beforeText.isNotEmpty) {
            newSpans.add(span.copyWith(text: beforeText));
          }
        }

        // Part in selection gets target bold
        final selStart = (_selectionStart - spanStart).clamp(0, span.text.length);
        final selEnd = (_selectionEnd - spanStart).clamp(0, span.text.length);
        if (selEnd > selStart) {
          final selectedPart = span.text.substring(selStart, selEnd);
          if (selectedPart.isNotEmpty) {
            newSpans.add(span.copyWith(
              text: selectedPart,
              isBold: targetBold,
            ));
          }
        }

        // Part after selection keeps original formatting
        if (spanEnd > _selectionEnd) {
          final afterText = span.text.substring(_selectionEnd - spanStart);
          if (afterText.isNotEmpty) {
            newSpans.add(span.copyWith(text: afterText));
          }
        }
      }

      currentPos = spanEnd;
    }

    setState(() {
      _spans = _mergeAdjacentSpans(newSpans);
      widget.onChanged(_spans);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Info hint
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: theme.colorScheme.primary.withValues(alpha: 0.3),
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.info_outline,
                size: 16,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Text markieren → Fett-Button für einzelne Wörter',
                  style: TextStyle(
                    fontSize: 12,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        
        // Formatting toolbar
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: theme.dividerColor,
            ),
          ),
          child: Row(
            children: [
              // Bold button
              Container(
                decoration: BoxDecoration(
                  color: _isSelectionBold()
                      ? theme.colorScheme.primary.withValues(alpha: 0.15)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: IconButton(
                  icon: const Icon(Icons.format_bold),
                  onPressed: _toggleBold,
                  tooltip: 'Fett (Strg+B)',
                  color: _isSelectionBold()
                      ? theme.colorScheme.primary
                      : theme.iconTheme.color,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                width: 1,
                height: 32,
                color: theme.dividerColor,
              ),
              const SizedBox(width: 12),
              // Font size dropdown
              Icon(Icons.format_size,
                  size: 18, color: theme.iconTheme.color),
              const SizedBox(width: 8),
              DropdownButton<double>(
                value: widget.fontSize,
                underline: const SizedBox(),
                borderRadius: BorderRadius.circular(8),
                items: const [
                  DropdownMenuItem(value: 12.0, child: Text('Klein (12)')),
                  DropdownMenuItem(value: 15.0, child: Text('Normal (15)')),
                  DropdownMenuItem(value: 18.0, child: Text('Groß (18)')),
                  DropdownMenuItem(value: 22.0, child: Text('Sehr groß (22)')),
                  DropdownMenuItem(value: 28.0, child: Text('Riesig (28)')),
                ],
                onChanged: (value) {
                  if (value != null) {
                    widget.onFontSizeChanged(value);
                  }
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        
        // Rich text display (for preview)
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(color: theme.dividerColor),
            borderRadius: BorderRadius.circular(8),
            color: theme.colorScheme.surface,
          ),
          child: _spans.isEmpty || (_spans.length == 1 && _spans.first.text.isEmpty)
              ? Text(
                  'Vorschau erscheint hier...',
                  style: TextStyle(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                    fontSize: widget.fontSize,
                  ),
                )
              : RichText(
                  text: TextSpan(
                    style: TextStyle(
                      color: theme.colorScheme.onSurface,
                      fontSize: widget.fontSize,
                      height: 1.4,
                      letterSpacing: 0.2,
                    ),
                    children: _spans.map((span) {
                      return TextSpan(
                        text: span.text,
                        style: TextStyle(
                          fontWeight: span.isBold ? FontWeight.w700 : FontWeight.w500,
                        ),
                      );
                    }).toList(),
                  ),
                ),
        ),
        const SizedBox(height: 12),
        
        // Text input
        TextField(
          controller: _controller,
          focusNode: _focusNode,
          maxLines: null,
          minLines: 3,
          keyboardType: TextInputType.multiline,
          decoration: const InputDecoration(
            labelText: 'Text bearbeiten',
            hintText: 'Text eingeben und markieren für Formatierung...',
            alignLabelWithHint: true,
            border: OutlineInputBorder(),
          ),
        ),
      ],
    );
  }

  bool _isSelectionBold() {
    if (_selectionStart == _selectionEnd) return false;
    
    int currentPos = 0;
    for (final span in _spans) {
      final spanEnd = currentPos + span.text.length;
      if (currentPos < _selectionEnd && spanEnd > _selectionStart) {
        return span.isBold;
      }
      currentPos = spanEnd;
    }
    return false;
  }
}


