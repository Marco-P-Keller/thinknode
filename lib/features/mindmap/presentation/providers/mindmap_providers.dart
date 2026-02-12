import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thinknode/features/auth/data/auth_repository.dart';
import 'package:thinknode/features/mindmap/data/mindmap_repository.dart';
import 'package:thinknode/features/mindmap/domain/models/mindmap_model.dart';
import 'package:thinknode/features/mindmap/domain/models/node_model.dart';
import 'package:thinknode/features/mindmap/domain/models/edge_model.dart';
import 'package:thinknode/features/mindmap/domain/models/cursor_presence_model.dart';
import 'package:thinknode/features/mindmap/domain/models/version_model.dart';

/// Stream of all mindmaps for the current user
final userMindmapsProvider = StreamProvider<List<MindMapModel>>((ref) {
  final authState = ref.watch(authStateProvider);
  return authState.when(
    data: (user) {
      if (user == null) return Stream.value([]);
      return ref.watch(mindmapRepositoryProvider).streamUserMindmaps(user.uid);
    },
    loading: () => Stream.value([]),
    error: (_, __) => Stream.value([]),
  );
});

/// Stream of a single mindmap by ID
final mindmapProvider =
    StreamProvider.family<MindMapModel?, String>((ref, mindmapId) {
  return ref.watch(mindmapRepositoryProvider).streamMindmap(mindmapId);
});

/// Stream of nodes for a mindmap
final nodesProvider =
    StreamProvider.family<List<NodeModel>, String>((ref, mindmapId) {
  return ref.watch(mindmapRepositoryProvider).streamNodes(mindmapId);
});

/// Stream of edges for a mindmap
final edgesProvider =
    StreamProvider.family<List<EdgeModel>, String>((ref, mindmapId) {
  return ref.watch(mindmapRepositoryProvider).streamEdges(mindmapId);
});

/// Stream of cursor presence for a mindmap
final presenceProvider =
    StreamProvider.family<List<CursorPresenceModel>, String>((ref, mindmapId) {
  return ref.watch(mindmapRepositoryProvider).streamPresence(mindmapId);
});

/// Stream of versions for a mindmap
final versionsProvider =
    StreamProvider.family<List<VersionModel>, String>((ref, mindmapId) {
  return ref.watch(mindmapRepositoryProvider).streamVersions(mindmapId);
});

/// Search mindmaps provider
final mindmapSearchQueryProvider = StateProvider<String>((ref) => '');

final filteredMindmapsProvider = Provider<AsyncValue<List<MindMapModel>>>((ref) {
  final query = ref.watch(mindmapSearchQueryProvider);
  final mindmaps = ref.watch(userMindmapsProvider);

  if (query.isEmpty) return mindmaps;

  return mindmaps.whenData((list) {
    final lower = query.toLowerCase();
    return list
        .where((m) =>
            m.title.toLowerCase().contains(lower) ||
            m.description.toLowerCase().contains(lower) ||
            m.tags.any((t) => t.toLowerCase().contains(lower)))
        .toList();
  });
});

/// Template mindmaps provider
final templatesProvider = StreamProvider<List<MindMapModel>>((ref) {
  return ref.watch(mindmapRepositoryProvider).streamTemplates();
});

