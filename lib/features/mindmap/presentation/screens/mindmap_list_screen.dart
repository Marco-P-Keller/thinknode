import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:thinknode/features/auth/data/auth_repository.dart';
import 'package:thinknode/features/auth/presentation/providers/auth_providers.dart';
import 'package:thinknode/features/mindmap/data/mindmap_repository.dart';
import 'package:thinknode/features/mindmap/domain/models/mindmap_model.dart';
import 'package:thinknode/features/mindmap/presentation/providers/canvas_state_provider.dart';
import 'package:thinknode/features/mindmap/presentation/providers/mindmap_providers.dart';
import 'package:thinknode/features/mindmap/presentation/widgets/mindmap_thumbnail.dart';

class MindmapListScreen extends ConsumerStatefulWidget {
  const MindmapListScreen({super.key});

  @override
  ConsumerState<MindmapListScreen> createState() => _MindmapListScreenState();
}

class _MindmapListScreenState extends ConsumerState<MindmapListScreen> {
  final _searchController = TextEditingController();
  bool _isSearching = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _createNewMindmap() async {
    final user = ref.read(authStateProvider).value;
    final userProfile = ref.read(currentUserProvider).value;
    if (user == null) return;

    final titleController = TextEditingController(text: 'Neue Mindmap');
    final tagsController = TextEditingController();

    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Neue Mindmap'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              autofocus: true,
              decoration: const InputDecoration(
                labelText: 'Titel',
                hintText: 'Mindmap Titel',
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: tagsController,
              decoration: const InputDecoration(
                labelText: 'Tags (kommagetrennt)',
                hintText: 'z.B. projekt, ideen, brainstorming',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Abbrechen'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, {
              'title': titleController.text.trim(),
              'tags': tagsController.text,
            }),
            child: const Text('Erstellen'),
          ),
        ],
      ),
    );

    if (result != null && result['title']!.toString().isNotEmpty) {
      final tags = (result['tags'] as String)
          .split(',')
          .map((t) => t.trim())
          .where((t) => t.isNotEmpty)
          .toList();

      final mindmap = await ref.read(mindmapRepositoryProvider).createMindmap(
            title: result['title'] as String,
            ownerId: user.uid,
            ownerName: userProfile?.displayName ?? user.email ?? 'Unbekannt',
            tags: tags,
          );

      if (mounted) {
        context.push('/editor/${mindmap.id}');
      }
    }
  }

  Future<void> _deleteMindmap(MindMapModel mindmap) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Mindmap löschen'),
        content: Text(
          'Möchtest du "${mindmap.title}" wirklich löschen? '
          'Diese Aktion kann nicht rückgängig gemacht werden.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Abbrechen'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Löschen'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await ref.read(mindmapRepositoryProvider).deleteMindmap(mindmap.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final mindmapsAsync = ref.watch(filteredMindmapsProvider);
    final userAsync = ref.watch(currentUserProvider);
    final theme = Theme.of(context);
    final themeMode = ref.watch(themeModeProvider);

    return Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'Mindmaps suchen...',
                  border: InputBorder.none,
                ),
                onChanged: (value) {
                  ref.read(mindmapSearchQueryProvider.notifier).state = value;
                },
              )
            : const Text('ThinkNode'),
        leading: _isSearching
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  setState(() => _isSearching = false);
                  _searchController.clear();
                  ref.read(mindmapSearchQueryProvider.notifier).state = '';
                },
              )
            : Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  Icons.hub_rounded,
                  color: theme.colorScheme.primary,
                ),
              ),
        actions: [
          if (!_isSearching)
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () => setState(() => _isSearching = true),
            ),
          IconButton(
            icon: Icon(
              themeMode == ThemeMode.dark
                  ? Icons.light_mode
                  : Icons.dark_mode,
            ),
            onPressed: () {
              ref.read(themeModeProvider.notifier).state =
                  themeMode == ThemeMode.dark
                      ? ThemeMode.light
                      : ThemeMode.dark;
            },
          ),
          // Profile button
          PopupMenuButton(
            icon: CircleAvatar(
              radius: 16,
              backgroundColor: theme.colorScheme.primaryContainer,
              child: Text(
                userAsync.value?.displayName.isNotEmpty == true
                    ? userAsync.value!.displayName[0].toUpperCase()
                    : '?',
                style: TextStyle(
                  color: theme.colorScheme.onPrimaryContainer,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'profile',
                child: ListTile(
                  leading: Icon(Icons.person_outline),
                  title: Text('Profil'),
                  dense: true,
                ),
              ),
              const PopupMenuItem(
                value: 'signout',
                child: ListTile(
                  leading: Icon(Icons.logout, color: Colors.red),
                  title: Text('Abmelden', style: TextStyle(color: Colors.red)),
                  dense: true,
                ),
              ),
            ],
            onSelected: (value) {
              if (value == 'profile') {
                context.push('/profile');
              } else if (value == 'signout') {
                ref.read(authNotifierProvider.notifier).signOut();
              }
            },
          ),
        ],
      ),
      body: mindmapsAsync.when(
        data: (mindmaps) {
          if (mindmaps.isEmpty) {
            return _buildEmptyState(theme);
          }
          return _buildMindmapGrid(mindmaps, theme);
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline,
                  size: 64, color: theme.colorScheme.error),
              const SizedBox(height: 16),
              Text('Fehler beim Laden: $error'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.invalidate(userMindmapsProvider),
                child: const Text('Erneut versuchen'),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _createNewMindmap,
        icon: const Icon(Icons.add),
        label: const Text('Neue Mindmap'),
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.hub_rounded,
            size: 100,
            color: theme.colorScheme.primary.withValues(alpha: 0.3),
          ),
          const SizedBox(height: 24),
          Text(
            'Keine Mindmaps vorhanden',
            style: theme.textTheme.headlineSmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Erstelle deine erste Mindmap!',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: _createNewMindmap,
            icon: const Icon(Icons.add),
            label: const Text('Erste Mindmap erstellen'),
          ),
        ],
      ),
    );
  }

  Widget _buildMindmapGrid(List<MindMapModel> mindmaps, ThemeData theme) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth > 900
            ? 4
            : constraints.maxWidth > 600
                ? 3
                : 2;

        return GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.85, // Taller cards for preview
          ),
          itemCount: mindmaps.length,
          itemBuilder: (context, index) =>
              _buildMindmapCard(mindmaps[index], theme),
        );
      },
    );
  }

  Widget _buildMindmapCard(MindMapModel mindmap, ThemeData theme) {
    final isOwner =
        ref.read(authStateProvider).value?.uid == mindmap.ownerId;
    final role = isOwner ? 'Owner' : (mindmap.collaborators[ref.read(authStateProvider).value?.uid] ?? 'viewer');

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => context.push('/editor/${mindmap.id}'),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ===== Mindmap Preview =====
            Expanded(
              flex: 3,
              child: Stack(
                children: [
                  // Thumbnail preview
                  Positioned.fill(
                    child: MindmapThumbnail(mindmapId: mindmap.id),
                  ),
                  // Gradient overlay at bottom for smooth transition
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    height: 20,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            theme.cardColor.withValues(alpha: 0.0),
                            theme.cardColor,
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ===== Info Section =====
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 4, 8, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      mindmap.title,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                    // Description
                    if (mindmap.description.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Text(
                          mindmap.description,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface
                                .withValues(alpha: 0.6),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),

                    const Spacer(),

                    // Tags row
                    if (mindmap.tags.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Wrap(
                          spacing: 4,
                          runSpacing: 2,
                          children: mindmap.tags.take(3).map((tag) {
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 1),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.primaryContainer
                                    .withValues(alpha: 0.5),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                tag,
                                style: TextStyle(
                                  fontSize: 9,
                                  color: theme.colorScheme.primary,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),

                    // Footer row
                    Row(
                      children: [
                        // Role badge
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: isOwner
                                ? theme.colorScheme.primary
                                    .withValues(alpha: 0.1)
                                : theme.colorScheme.secondary
                                    .withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            role,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: isOwner
                                  ? theme.colorScheme.primary
                                  : theme.colorScheme.secondary,
                            ),
                          ),
                        ),
                        const Spacer(),
                        if (mindmap.collaborators.length > 1) ...[
                          Icon(Icons.people_outline,
                              size: 14,
                              color: theme.colorScheme.onSurface
                                  .withValues(alpha: 0.5)),
                          const SizedBox(width: 2),
                          Text(
                            '${mindmap.collaborators.length}',
                            style: TextStyle(
                              fontSize: 11,
                              color: theme.colorScheme.onSurface
                                  .withValues(alpha: 0.5),
                            ),
                          ),
                          const SizedBox(width: 4),
                        ],
                        // Context menu
                        SizedBox(
                          width: 28,
                          height: 28,
                          child: PopupMenuButton(
                            padding: EdgeInsets.zero,
                            iconSize: 16,
                            icon: Icon(Icons.more_vert,
                                size: 16,
                                color: theme.colorScheme.onSurface
                                    .withValues(alpha: 0.5)),
                            itemBuilder: (context) => [
                              const PopupMenuItem(
                                value: 'edit',
                                child: ListTile(
                                  leading: Icon(Icons.edit),
                                  title: Text('Umbenennen'),
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
                              if (isOwner)
                                const PopupMenuItem(
                                  value: 'delete',
                                  child: ListTile(
                                    leading:
                                        Icon(Icons.delete, color: Colors.red),
                                    title: Text('Löschen',
                                        style: TextStyle(color: Colors.red)),
                                    dense: true,
                                  ),
                                ),
                            ],
                            onSelected: (value) async {
                              switch (value) {
                                case 'edit':
                                  _renameMindmap(mindmap);
                                  break;
                                case 'duplicate':
                                  _duplicateMindmap(mindmap);
                                  break;
                                case 'delete':
                                  _deleteMindmap(mindmap);
                                  break;
                              }
                            },
                          ),
                        ),
                      ],
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

  Future<void> _renameMindmap(MindMapModel mindmap) async {
    final controller = TextEditingController(text: mindmap.title);
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Umbenennen'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(labelText: 'Neuer Titel'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Abbrechen'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, controller.text.trim()),
            child: const Text('Speichern'),
          ),
        ],
      ),
    );

    if (result != null && result.isNotEmpty) {
      await ref
          .read(mindmapRepositoryProvider)
          .updateMindmap(mindmap.copyWith(title: result));
    }
  }

  Future<void> _duplicateMindmap(MindMapModel mindmap) async {
    final user = ref.read(authStateProvider).value;
    final userProfile = ref.read(currentUserProvider).value;
    if (user == null) return;

    await ref.read(mindmapRepositoryProvider).duplicateMindmap(
          sourceMindmapId: mindmap.id,
          newOwnerId: user.uid,
          newOwnerName: userProfile?.displayName ?? 'Unbekannt',
          newTitle: '${mindmap.title} (Kopie)',
        );
  }
}

