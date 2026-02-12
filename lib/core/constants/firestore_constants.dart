/// Firestore collection and document path constants
class FirestoreConstants {
  FirestoreConstants._();

  // Collections
  static const String usersCollection = 'users';
  static const String mindmapsCollection = 'mindmaps';

  // Subcollections
  static const String nodesSubcollection = 'nodes';
  static const String edgesSubcollection = 'edges';
  static const String presenceSubcollection = 'presence';
  static const String versionsSubcollection = 'versions';

  // Fields
  static const String ownerId = 'ownerId';
  static const String collaborators = 'collaborators';
  static const String updatedAt = 'updatedAt';
  static const String createdAt = 'createdAt';
  static const String email = 'email';
  static const String lastSeen = 'lastSeen';
  static const String tags = 'tags';
}

