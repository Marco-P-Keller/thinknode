import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:thinknode/core/constants/firestore_constants.dart';
import 'package:thinknode/core/errors/failures.dart';
import 'package:thinknode/features/mindmap/domain/models/mindmap_model.dart';
import 'package:thinknode/features/mindmap/domain/models/node_model.dart';
import 'package:thinknode/features/mindmap/domain/models/edge_model.dart';
import 'package:thinknode/features/mindmap/domain/models/cursor_presence_model.dart';
import 'package:thinknode/features/mindmap/domain/models/version_model.dart';

const _uuid = Uuid();

/// Provider for the MindmapRepository
final mindmapRepositoryProvider = Provider<MindmapRepository>((ref) {
  return MindmapRepository(firestore: FirebaseFirestore.instance);
});

/// Repository handling all Mindmap-related Firestore operations
class MindmapRepository {
  final FirebaseFirestore _firestore;

  MindmapRepository({required FirebaseFirestore firestore})
      : _firestore = firestore;

  // ==================== Collection References ====================

  CollectionReference<Map<String, dynamic>> get _mindmapsRef =>
      _firestore.collection(FirestoreConstants.mindmapsCollection);

  CollectionReference<Map<String, dynamic>> _nodesRef(String mindmapId) =>
      _mindmapsRef
          .doc(mindmapId)
          .collection(FirestoreConstants.nodesSubcollection);

  CollectionReference<Map<String, dynamic>> _edgesRef(String mindmapId) =>
      _mindmapsRef
          .doc(mindmapId)
          .collection(FirestoreConstants.edgesSubcollection);

  CollectionReference<Map<String, dynamic>> _presenceRef(String mindmapId) =>
      _mindmapsRef
          .doc(mindmapId)
          .collection(FirestoreConstants.presenceSubcollection);

  CollectionReference<Map<String, dynamic>> _versionsRef(String mindmapId) =>
      _mindmapsRef
          .doc(mindmapId)
          .collection(FirestoreConstants.versionsSubcollection);

  // ==================== Mindmap CRUD ====================

  /// Create a new mindmap
  Future<MindMapModel> createMindmap({
    required String title,
    required String ownerId,
    required String ownerName,
    String description = '',
    List<String> tags = const [],
    bool isTemplate = false,
  }) async {
    try {
      final id = _uuid.v4();
      final now = DateTime.now();
      final mindmap = MindMapModel(
        id: id,
        title: title,
        description: description,
        ownerId: ownerId,
        ownerName: ownerName,
        collaborators: {ownerId: 'owner'},
        tags: tags,
        isTemplate: isTemplate,
        createdAt: now,
        updatedAt: now,
      );

      await _mindmapsRef.doc(id).set(mindmap.toJson());
      return mindmap;
    } catch (e) {
      throw FirestoreFailure(message: 'Mindmap konnte nicht erstellt werden: $e');
    }
  }

  /// Stream all mindmaps for a user (owned + shared)
  Stream<List<MindMapModel>> streamUserMindmaps(String userId) {
    // Query mindmaps where user is owner
    return _mindmapsRef
        .where('ownerId', isEqualTo: userId)
        .orderBy('updatedAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) =>
                MindMapModel.fromJson({...doc.data(), 'id': doc.id}))
            .toList());
  }

  /// Stream a single mindmap
  Stream<MindMapModel?> streamMindmap(String mindmapId) {
    return _mindmapsRef.doc(mindmapId).snapshots().map((doc) {
      if (!doc.exists) return null;
      return MindMapModel.fromJson({...doc.data()!, 'id': doc.id});
    });
  }

  /// Update mindmap metadata
  Future<void> updateMindmap(MindMapModel mindmap) async {
    try {
      await _mindmapsRef.doc(mindmap.id).update({
        'title': mindmap.title,
        'description': mindmap.description,
        'tags': mindmap.tags,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw FirestoreFailure(message: 'Mindmap konnte nicht aktualisiert werden: $e');
    }
  }

  /// Delete a mindmap and all subcollections
  Future<void> deleteMindmap(String mindmapId) async {
    try {
      final batch = _firestore.batch();

      // Delete all nodes
      final nodes = await _nodesRef(mindmapId).get();
      for (final doc in nodes.docs) {
        batch.delete(doc.reference);
      }

      // Delete all edges
      final edges = await _edgesRef(mindmapId).get();
      for (final doc in edges.docs) {
        batch.delete(doc.reference);
      }

      // Delete all presence
      final presence = await _presenceRef(mindmapId).get();
      for (final doc in presence.docs) {
        batch.delete(doc.reference);
      }

      // Delete all versions
      final versions = await _versionsRef(mindmapId).get();
      for (final doc in versions.docs) {
        batch.delete(doc.reference);
      }

      // Delete the mindmap document itself
      batch.delete(_mindmapsRef.doc(mindmapId));

      await batch.commit();
    } catch (e) {
      throw FirestoreFailure(message: 'Mindmap konnte nicht gelöscht werden: $e');
    }
  }

  // ==================== Sharing / Collaboration ====================

  /// Add a collaborator to a mindmap
  Future<void> addCollaborator({
    required String mindmapId,
    required String userId,
    required MindMapRole role,
  }) async {
    try {
      await _mindmapsRef.doc(mindmapId).update({
        'collaborators.$userId': role.name,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw FirestoreFailure(message: 'Mitarbeiter konnte nicht hinzugefügt werden: $e');
    }
  }

  /// Remove a collaborator
  Future<void> removeCollaborator({
    required String mindmapId,
    required String userId,
  }) async {
    try {
      await _mindmapsRef.doc(mindmapId).update({
        'collaborators.$userId': FieldValue.delete(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw FirestoreFailure(message: 'Mitarbeiter konnte nicht entfernt werden: $e');
    }
  }

  // ==================== Nodes CRUD ====================

  /// Stream all nodes for a mindmap
  Stream<List<NodeModel>> streamNodes(String mindmapId) {
    return _nodesRef(mindmapId).snapshots().map((snapshot) => snapshot.docs
        .map((doc) => NodeModel.fromJson({...doc.data(), 'id': doc.id}))
        .toList());
  }

  /// Create a new node
  Future<NodeModel> createNode({
    required String mindmapId,
    required double x,
    required double y,
    required String createdBy,
    String text = 'Neuer Knoten',
    int color = 0xFF4A6CF7,
    NodeShape shape = NodeShape.roundedRectangle,
  }) async {
    try {
      final id = _uuid.v4();
      final now = DateTime.now();
      final node = NodeModel(
        id: id,
        mindmapId: mindmapId,
        text: text,
        x: x,
        y: y,
        color: color,
        shape: shape,
        createdBy: createdBy,
        createdAt: now,
        updatedAt: now,
      );

      await _nodesRef(mindmapId).doc(id).set(node.toJson());
      await _touchMindmap(mindmapId);
      return node;
    } catch (e) {
      throw FirestoreFailure(message: 'Knoten konnte nicht erstellt werden: $e');
    }
  }

  /// Update a node
  Future<void> updateNode(NodeModel node) async {
    try {
      final data = node.toJson();
      data['updatedAt'] = FieldValue.serverTimestamp();
      await _nodesRef(node.mindmapId).doc(node.id).set(data);
      await _touchMindmap(node.mindmapId);
    } catch (e) {
      throw FirestoreFailure(message: 'Knoten konnte nicht aktualisiert werden: $e');
    }
  }

  /// Update node position (optimized - only updates x, y)
  Future<void> updateNodePosition({
    required String mindmapId,
    required String nodeId,
    required double x,
    required double y,
  }) async {
    try {
      await _nodesRef(mindmapId).doc(nodeId).update({
        'x': x,
        'y': y,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw FirestoreFailure(message: 'Position konnte nicht aktualisiert werden: $e');
    }
  }

  /// Update node size
  Future<void> updateNodeSize({
    required String mindmapId,
    required String nodeId,
    required double width,
    required double height,
  }) async {
    try {
      await _nodesRef(mindmapId).doc(nodeId).update({
        'width': width,
        'height': height,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw FirestoreFailure(message: 'Größe konnte nicht aktualisiert werden: $e');
    }
  }

  /// Delete a node and its connected edges
  Future<void> deleteNode({
    required String mindmapId,
    required String nodeId,
  }) async {
    try {
      final batch = _firestore.batch();

      // Delete the node
      batch.delete(_nodesRef(mindmapId).doc(nodeId));

      // Delete connected edges
      final sourceEdges = await _edgesRef(mindmapId)
          .where('sourceNodeId', isEqualTo: nodeId)
          .get();
      for (final doc in sourceEdges.docs) {
        batch.delete(doc.reference);
      }

      final targetEdges = await _edgesRef(mindmapId)
          .where('targetNodeId', isEqualTo: nodeId)
          .get();
      for (final doc in targetEdges.docs) {
        batch.delete(doc.reference);
      }

      await batch.commit();
      await _touchMindmap(mindmapId);
    } catch (e) {
      throw FirestoreFailure(message: 'Knoten konnte nicht gelöscht werden: $e');
    }
  }

  // ==================== Edges CRUD ====================

  /// Stream all edges for a mindmap
  Stream<List<EdgeModel>> streamEdges(String mindmapId) {
    return _edgesRef(mindmapId).snapshots().map((snapshot) => snapshot.docs
        .map((doc) => EdgeModel.fromJson({...doc.data(), 'id': doc.id}))
        .toList());
  }

  /// Create a new edge
  Future<EdgeModel> createEdge({
    required String mindmapId,
    required String sourceNodeId,
    required String targetNodeId,
    required String createdBy,
    String label = '',
    EdgeType type = EdgeType.simple,
    EdgeStyle style = EdgeStyle.curved,
    int color = 0xFF607D8B,
  }) async {
    try {
      final id = _uuid.v4();
      final now = DateTime.now();
      final edge = EdgeModel(
        id: id,
        mindmapId: mindmapId,
        sourceNodeId: sourceNodeId,
        targetNodeId: targetNodeId,
        label: label,
        type: type,
        style: style,
        color: color,
        createdBy: createdBy,
        createdAt: now,
        updatedAt: now,
      );

      await _edgesRef(mindmapId).doc(id).set(edge.toJson());
      await _touchMindmap(mindmapId);
      return edge;
    } catch (e) {
      throw FirestoreFailure(message: 'Verbindung konnte nicht erstellt werden: $e');
    }
  }

  /// Update an edge
  Future<void> updateEdge(EdgeModel edge) async {
    try {
      final data = edge.toJson();
      data['updatedAt'] = FieldValue.serverTimestamp();
      await _edgesRef(edge.mindmapId).doc(edge.id).set(data);
      await _touchMindmap(edge.mindmapId);
    } catch (e) {
      throw FirestoreFailure(message: 'Verbindung konnte nicht aktualisiert werden: $e');
    }
  }

  /// Delete an edge
  Future<void> deleteEdge({
    required String mindmapId,
    required String edgeId,
  }) async {
    try {
      await _edgesRef(mindmapId).doc(edgeId).delete();
      await _touchMindmap(mindmapId);
    } catch (e) {
      throw FirestoreFailure(message: 'Verbindung konnte nicht gelöscht werden: $e');
    }
  }

  // ==================== Cursor Presence ====================

  /// Update cursor presence for a user
  Future<void> updatePresence({
    required String mindmapId,
    required CursorPresenceModel presence,
  }) async {
    try {
      await _presenceRef(mindmapId)
          .doc(presence.userId)
          .set(presence.toJson());
    } catch (e) {
      // Silently fail for presence updates to avoid disruption
    }
  }

  /// Remove cursor presence (when user leaves)
  Future<void> removePresence({
    required String mindmapId,
    required String userId,
  }) async {
    try {
      await _presenceRef(mindmapId).doc(userId).delete();
    } catch (e) {
      // Silently fail
    }
  }

  /// Stream cursor presences
  Stream<List<CursorPresenceModel>> streamPresence(String mindmapId) {
    return _presenceRef(mindmapId).snapshots().map((snapshot) => snapshot.docs
        .map((doc) => CursorPresenceModel.fromJson(doc.data()))
        .toList());
  }

  // ==================== Versioning ====================

  /// Create a version snapshot
  Future<VersionModel> createVersion({
    required String mindmapId,
    required String description,
    required String createdBy,
    required String createdByName,
    required List<NodeModel> nodes,
    required List<EdgeModel> edges,
  }) async {
    try {
      final id = _uuid.v4();
      final version = VersionModel(
        id: id,
        mindmapId: mindmapId,
        description: description,
        nodes: nodes,
        edges: edges,
        createdBy: createdBy,
        createdByName: createdByName,
        createdAt: DateTime.now(),
      );

      await _versionsRef(mindmapId).doc(id).set(version.toJson());
      return version;
    } catch (e) {
      throw FirestoreFailure(
          message: 'Version konnte nicht erstellt werden: $e');
    }
  }

  /// Stream versions for a mindmap
  Stream<List<VersionModel>> streamVersions(String mindmapId) {
    return _versionsRef(mindmapId)
        .orderBy('createdAt', descending: true)
        .limit(50)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) =>
                VersionModel.fromJson({...doc.data(), 'id': doc.id}))
            .toList());
  }

  /// Restore a version
  Future<void> restoreVersion({
    required String mindmapId,
    required VersionModel version,
  }) async {
    try {
      final batch = _firestore.batch();

      // Delete current nodes
      final currentNodes = await _nodesRef(mindmapId).get();
      for (final doc in currentNodes.docs) {
        batch.delete(doc.reference);
      }

      // Delete current edges
      final currentEdges = await _edgesRef(mindmapId).get();
      for (final doc in currentEdges.docs) {
        batch.delete(doc.reference);
      }

      // Restore nodes from version
      for (final node in version.nodes) {
        batch.set(_nodesRef(mindmapId).doc(node.id), node.toJson());
      }

      // Restore edges from version
      for (final edge in version.edges) {
        batch.set(_edgesRef(mindmapId).doc(edge.id), edge.toJson());
      }

      await batch.commit();
      await _touchMindmap(mindmapId);
    } catch (e) {
      throw FirestoreFailure(
          message: 'Version konnte nicht wiederhergestellt werden: $e');
    }
  }

  // ==================== Search ====================

  /// Search mindmaps by title
  Stream<List<MindMapModel>> searchMindmaps({
    required String userId,
    required String query,
  }) {
    final lowerQuery = query.toLowerCase();
    return streamUserMindmaps(userId).map((mindmaps) => mindmaps
        .where((m) =>
            m.title.toLowerCase().contains(lowerQuery) ||
            m.description.toLowerCase().contains(lowerQuery) ||
            m.tags.any((t) => t.toLowerCase().contains(lowerQuery)))
        .toList());
  }

  // ==================== Templates ====================

  /// Get all template mindmaps
  Stream<List<MindMapModel>> streamTemplates() {
    return _mindmapsRef
        .where('isTemplate', isEqualTo: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) =>
                MindMapModel.fromJson({...doc.data(), 'id': doc.id}))
            .toList());
  }

  /// Duplicate a mindmap (used for templates)
  Future<MindMapModel> duplicateMindmap({
    required String sourceMindmapId,
    required String newOwnerId,
    required String newOwnerName,
    required String newTitle,
  }) async {
    try {
      // Create new mindmap
      final newMindmap = await createMindmap(
        title: newTitle,
        ownerId: newOwnerId,
        ownerName: newOwnerName,
      );

      // Copy nodes
      final nodes = await _nodesRef(sourceMindmapId).get();
      for (final doc in nodes.docs) {
        final nodeData = doc.data();
        nodeData['mindmapId'] = newMindmap.id;
        await _nodesRef(newMindmap.id).doc(doc.id).set(nodeData);
      }

      // Copy edges
      final edges = await _edgesRef(sourceMindmapId).get();
      for (final doc in edges.docs) {
        final edgeData = doc.data();
        edgeData['mindmapId'] = newMindmap.id;
        await _edgesRef(newMindmap.id).doc(doc.id).set(edgeData);
      }

      return newMindmap;
    } catch (e) {
      throw FirestoreFailure(
          message: 'Mindmap konnte nicht dupliziert werden: $e');
    }
  }

  // ==================== Helpers ====================

  /// Update the mindmap's updatedAt timestamp
  Future<void> _touchMindmap(String mindmapId) async {
    await _mindmapsRef.doc(mindmapId).update({
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }
}

