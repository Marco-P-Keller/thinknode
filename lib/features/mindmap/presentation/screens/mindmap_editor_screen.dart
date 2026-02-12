import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:thinknode/features/auth/data/auth_repository.dart';
import 'package:thinknode/features/auth/presentation/providers/auth_providers.dart';
import 'package:thinknode/features/mindmap/data/mindmap_repository.dart';
import 'package:thinknode/features/mindmap/domain/models/version_model.dart';
import 'package:thinknode/features/mindmap/presentation/providers/canvas_state_provider.dart';
import 'package:thinknode/features/mindmap/presentation/providers/mindmap_providers.dart';
import 'package:thinknode/features/mindmap/presentation/widgets/mindmap_canvas.dart';
import 'package:thinknode/features/mindmap/presentation/widgets/share_dialog.dart';
import 'package:thinknode/features/mindmap/presentation/widgets/toolbar_widget.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

/// Main editor screen for a single mindmap
class MindmapEditorScreen extends ConsumerStatefulWidget {
  final String mindmapId;

  const MindmapEditorScreen({super.key, required this.mindmapId});

  @override
  ConsumerState<MindmapEditorScreen> createState() =>
      _MindmapEditorScreenState();
}

class _MindmapEditorScreenState extends ConsumerState<MindmapEditorScreen> {
  final GlobalKey _repaintBoundaryKey = GlobalKey();

  // ==================== Export Functions ====================

  /// Capture the canvas as a PNG image
  Future<Uint8List?> _captureCanvasImage() async {
    try {
      final boundary = _repaintBoundaryKey.currentContext?.findRenderObject()
          as RenderRepaintBoundary?;
      if (boundary == null) return null;

      final image = await boundary.toImage(pixelRatio: 2.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      return byteData?.buffer.asUint8List();
    } catch (e) {
      debugPrint('Error capturing canvas: $e');
      return null;
    }
  }

  Future<void> _exportAsPng() async {
    final imageBytes = await _captureCanvasImage();
    if (imageBytes == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Export fehlgeschlagen')),
        );
      }
      return;
    }

    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File(
          '${directory.path}/thinknode_${widget.mindmapId}_${DateTime.now().millisecondsSinceEpoch}.png');
      await file.writeAsBytes(imageBytes);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('PNG gespeichert: ${file.path}')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Fehler beim Speichern: $e')),
        );
      }
    }
  }

  Future<void> _exportAsPdf() async {
    // Show page size selection dialog
    final pageSize = await _showPageSizeDialog();
    if (pageSize == null) return; // User canceled
    
    final imageBytes = await _captureCanvasImage();
    if (imageBytes == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Export fehlgeschlagen')),
        );
      }
      return;
    }

    try {
      final pdf = pw.Document();
      final pdfImage = pw.MemoryImage(imageBytes);

      pdf.addPage(
        pw.Page(
          pageFormat: pageSize.landscape,
          build: (pw.Context context) {
            return pw.Center(
              child: pw.Image(pdfImage, fit: pw.BoxFit.contain),
            );
          },
        ),
      );

      await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdf.save(),
        name: 'ThinkNode_Mindmap_${DateTime.now().millisecondsSinceEpoch}',
      );
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('PDF erfolgreich exportiert!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('PDF Export fehlgeschlagen: $e')),
        );
      }
    }
  }

  Future<PdfPageFormat?> _showPageSizeDialog() async {
    final pageSizes = {
      'A2': const PdfPageFormat(
        42.0 * PdfPageFormat.cm,
        59.4 * PdfPageFormat.cm,
        marginAll: 2.0 * PdfPageFormat.cm,
      ),
      'A3': PdfPageFormat.a3,
      'A4': PdfPageFormat.a4,
      'A5': PdfPageFormat.a5,
      'Letter': PdfPageFormat.letter,
      'Legal': PdfPageFormat.legal,
    };

    return showDialog<PdfPageFormat>(
      context: context,
      builder: (context) {
        final theme = Theme.of(context);
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.picture_as_pdf, color: theme.colorScheme.primary),
              const SizedBox(width: 12),
              const Text('PDF Seitengröße wählen'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Wähle die gewünschte Seitengröße für den PDF-Export:',
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 16),
              ...pageSizes.entries.map((entry) {
                final size = entry.value;
                final widthCm = (size.width / PdfPageFormat.cm).toStringAsFixed(1);
                final heightCm = (size.height / PdfPageFormat.cm).toStringAsFixed(1);
                
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    dense: true,
                    leading: Icon(
                      Icons.crop_portrait,
                      color: theme.colorScheme.primary,
                    ),
                    title: Text(
                      entry.key,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text(
                      '$widthCm × $heightCm cm (Querformat)',
                      style: const TextStyle(fontSize: 12),
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => Navigator.pop(context, size),
                  ),
                );
              }),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Abbrechen'),
            ),
          ],
        );
      },
    );
  }

  // ==================== Version Functions ====================

  Future<void> _saveVersion() async {
    final user = ref.read(authStateProvider).value;
    final userProfile = ref.read(currentUserProvider).value;
    final nodes = ref.read(nodesProvider(widget.mindmapId)).value ?? [];
    final edges = ref.read(edgesProvider(widget.mindmapId)).value ?? [];

    if (user == null) return;

    final descController = TextEditingController();
    final description = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Version speichern'),
        content: TextField(
          controller: descController,
          autofocus: true,
          decoration: const InputDecoration(
            labelText: 'Beschreibung',
            hintText: 'z.B. "Initiale Struktur erstellt"',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Abbrechen'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, descController.text.trim()),
            child: const Text('Speichern'),
          ),
        ],
      ),
    );

    if (description == null) return;

    await ref.read(mindmapRepositoryProvider).createVersion(
          mindmapId: widget.mindmapId,
          description:
              description.isEmpty ? 'Version ${DateTime.now()}' : description,
          createdBy: user.uid,
          createdByName: userProfile?.displayName ?? 'Unbekannt',
          nodes: nodes,
          edges: edges,
        );

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Version gespeichert!')),
      );
    }
  }

  void _showVersionsSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.5,
        maxChildSize: 0.9,
        minChildSize: 0.3,
        expand: false,
        builder: (context, scrollController) {
          return Consumer(
            builder: (context, ref, _) {
              final versionsAsync =
                  ref.watch(versionsProvider(widget.mindmapId));

              return Column(
                children: [
                  // Handle bar
                  Container(
                    margin: const EdgeInsets.only(top: 12),
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade400,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      'Versionen',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                  Expanded(
                    child: versionsAsync.when(
                      data: (versions) {
                        if (versions.isEmpty) {
                          return const Center(
                            child: Text('Keine Versionen gespeichert'),
                          );
                        }
                        return ListView.builder(
                          controller: scrollController,
                          itemCount: versions.length,
                          itemBuilder: (context, index) {
                            final version = versions[index];
                            return _buildVersionTile(version);
                          },
                        );
                      },
                      loading: () =>
                          const Center(child: CircularProgressIndicator()),
                      error: (e, _) => Center(child: Text('Fehler: $e')),
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildVersionTile(VersionModel version) {
    return ListTile(
      leading: const CircleAvatar(child: Icon(Icons.history)),
      title: Text(version.description),
      subtitle: Text(
        '${version.createdByName} • '
        '${version.createdAt.day}.${version.createdAt.month}.${version.createdAt.year} '
        '${version.createdAt.hour}:${version.createdAt.minute.toString().padLeft(2, '0')} • '
        '${version.nodes.length} Knoten, ${version.edges.length} Verbindungen',
      ),
      trailing: IconButton(
        icon: const Icon(Icons.restore),
        tooltip: 'Wiederherstellen',
        onPressed: () => _restoreVersion(version),
      ),
    );
  }

  Future<void> _restoreVersion(VersionModel version) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Version wiederherstellen'),
        content: Text(
          'Möchtest du "${version.description}" wiederherstellen? '
          'Alle aktuellen Änderungen gehen verloren.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Abbrechen'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Wiederherstellen'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await ref.read(mindmapRepositoryProvider).restoreVersion(
            mindmapId: widget.mindmapId,
            version: version,
          );
      if (mounted) {
        Navigator.pop(context); // Close bottom sheet
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Version wiederhergestellt!')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final mindmapAsync = ref.watch(mindmapProvider(widget.mindmapId));
    final canvasState = ref.watch(canvasStateProvider);
    final theme = Theme.of(context);

    return Scaffold(
      body: mindmapAsync.when(
        data: (mindmap) {
          if (mindmap == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64),
                  const SizedBox(height: 16),
                  const Text('Mindmap nicht gefunden'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.go('/'),
                    child: const Text('Zurück'),
                  ),
                ],
              ),
            );
          }

          return Stack(
            children: [
              // Main canvas
              MindmapCanvas(
                mindmapId: widget.mindmapId,
                repaintBoundaryKey: _repaintBoundaryKey,
              ),

              // Top bar
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: SafeArea(
                  child: Container(
                    margin: const EdgeInsets.fromLTRB(72, 8, 8, 0),
                    child: Card(
                      elevation: 4,
                      shadowColor: Colors.black26,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        child: Row(
                          children: [
                            // Back button
                            IconButton(
                              icon: const Icon(Icons.arrow_back),
                              onPressed: () => context.go('/'),
                              tooltip: 'Zurück',
                            ),
                            const SizedBox(width: 8),
                            // Title
                            Expanded(
                              child: Text(
                                mindmap.title,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            // Zoom indicator
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.surfaceContainerHighest,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                '${(canvasState.zoom * 100).toInt()}%',
                                style: const TextStyle(fontSize: 12),
                              ),
                            ),
                            const SizedBox(width: 8),
                            // Online indicators
                            Consumer(
                              builder: (context, ref, _) {
                                final presenceAsync = ref.watch(
                                    presenceProvider(widget.mindmapId));
                                final count =
                                    presenceAsync.value?.length ?? 0;
                                if (count <= 1) return const SizedBox();
                                return Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.green.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        width: 8,
                                        height: 8,
                                        decoration: const BoxDecoration(
                                          color: Colors.green,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        '$count online',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.green,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                            const SizedBox(width: 8),
                            // Share button
                            IconButton(
                              icon: const Icon(Icons.share),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) =>
                                      ShareDialog(mindmap: mindmap),
                                );
                              },
                              tooltip: 'Teilen',
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // Toolbar
              ToolbarWidget(
                onAddNode: () {
                  ref
                      .read(canvasStateProvider.notifier)
                      .setTool(EditorTool.addNode);
                },
                onExportPng: _exportAsPng,
                onExportPdf: _exportAsPdf,
                onSaveVersion: _saveVersion,
                onShowVersions: _showVersionsSheet,
              ),

              // Bottom info bar showing selected element info
              if (canvasState.selectedNodeId != null ||
                  canvasState.selectedEdgeId != null)
                Positioned(
                  bottom: 16,
                  left: 16,
                  right: 16,
                  child: SafeArea(
                    child: Card(
                      elevation: 4,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        child: Row(
                          children: [
                            Icon(
                              canvasState.selectedNodeId != null
                                  ? Icons.crop_square
                                  : Icons.trending_flat,
                              color: theme.colorScheme.primary,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              canvasState.selectedNodeId != null
                                  ? 'Knoten ausgewählt'
                                  : 'Verbindung ausgewählt',
                              style: const TextStyle(fontWeight: FontWeight.w500),
                            ),
                            const Spacer(),
                            if (canvasState.selectedEdgeId != null)
                              IconButton(
                                icon: const Icon(Icons.delete_outline,
                                    color: Colors.red),
                                onPressed: () async {
                                  await ref
                                      .read(mindmapRepositoryProvider)
                                      .deleteEdge(
                                        mindmapId: widget.mindmapId,
                                        edgeId: canvasState.selectedEdgeId!,
                                      );
                                  ref
                                      .read(canvasStateProvider.notifier)
                                      .clearSelection();
                                },
                                tooltip: 'Verbindung löschen',
                              ),
                            IconButton(
                              icon: const Icon(Icons.close),
                              onPressed: () => ref
                                  .read(canvasStateProvider.notifier)
                                  .clearSelection(),
                              tooltip: 'Auswahl aufheben',
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline,
                  size: 64, color: theme.colorScheme.error),
              const SizedBox(height: 16),
              Text('Fehler: $error'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => context.go('/'),
                child: const Text('Zurück'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

