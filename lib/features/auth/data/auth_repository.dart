import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thinknode/core/constants/firestore_constants.dart';
import 'package:thinknode/core/errors/failures.dart';
import 'package:thinknode/features/auth/domain/models/user_model.dart';

/// Provider for the AuthRepository
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(
    firebaseAuth: FirebaseAuth.instance,
    firestore: FirebaseFirestore.instance,
  );
});

/// Provider that streams the Firebase Auth state
final authStateProvider = StreamProvider<User?>((ref) {
  return ref.watch(authRepositoryProvider).authStateChanges;
});

/// Repository handling all authentication and user-related operations
class AuthRepository {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  AuthRepository({
    required FirebaseAuth firebaseAuth,
    required FirebaseFirestore firestore,
  })  : _firebaseAuth = firebaseAuth,
        _firestore = firestore;

  /// Stream of auth state changes
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  /// Current user (nullable)
  User? get currentUser => _firebaseAuth.currentUser;

  /// Reference to users collection
  CollectionReference<Map<String, dynamic>> get _usersRef =>
      _firestore.collection(FirestoreConstants.usersCollection);

  /// Register a new user with email and password
  Future<UserModel> register({
    required String email,
    required String password,
    required String displayName,
  }) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await credential.user?.updateDisplayName(displayName);

      final user = UserModel.newUser(
        id: credential.user!.uid,
        email: email,
        displayName: displayName,
      );

      // Save user profile to Firestore
      await _usersRef.doc(user.id).set(user.toJson());

      return user;
    } on FirebaseAuthException catch (e) {
      throw AuthFailure.fromCode(e.code);
    } catch (e) {
      throw AuthFailure(message: e.toString());
    }
  }

  /// Sign in with email and password
  Future<UserModel> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Fetch user profile from Firestore
      final doc = await _usersRef.doc(credential.user!.uid).get();
      if (doc.exists) {
        return UserModel.fromJson({...doc.data()!, 'id': doc.id});
      }

      // If user doc doesn't exist, create one
      final user = UserModel.newUser(
        id: credential.user!.uid,
        email: email,
        displayName: credential.user?.displayName ?? email.split('@').first,
      );
      await _usersRef.doc(user.id).set(user.toJson());
      return user;
    } on FirebaseAuthException catch (e) {
      throw AuthFailure.fromCode(e.code);
    } catch (e) {
      throw AuthFailure(message: e.toString());
    }
  }

  /// Send password reset email
  Future<void> resetPassword({required String email}) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw AuthFailure.fromCode(e.code);
    } catch (e) {
      throw AuthFailure(message: e.toString());
    }
  }

  /// Sign out
  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      throw AuthFailure(message: e.toString());
    }
  }

  /// Get user profile from Firestore
  Future<UserModel?> getUserProfile(String userId) async {
    try {
      final doc = await _usersRef.doc(userId).get();
      if (!doc.exists) return null;
      return UserModel.fromJson({...doc.data()!, 'id': doc.id});
    } catch (e) {
      throw FirestoreFailure(message: 'Benutzerprofil konnte nicht geladen werden: $e');
    }
  }

  /// Stream user profile
  Stream<UserModel?> streamUserProfile(String userId) {
    return _usersRef.doc(userId).snapshots().map((doc) {
      if (!doc.exists) return null;
      return UserModel.fromJson({...doc.data()!, 'id': doc.id});
    });
  }

  /// Update user profile
  Future<void> updateUserProfile(UserModel user) async {
    try {
      await _usersRef.doc(user.id).update({
        'displayName': user.displayName,
        'photoUrl': user.photoUrl,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw FirestoreFailure(message: 'Profil konnte nicht aktualisiert werden: $e');
    }
  }

  /// Search users by email (for sharing)
  Future<List<UserModel>> searchUsersByEmail(String email) async {
    try {
      final query = await _usersRef
          .where('email', isEqualTo: email)
          .limit(5)
          .get();

      return query.docs
          .map((doc) => UserModel.fromJson({...doc.data(), 'id': doc.id}))
          .toList();
    } catch (e) {
      throw FirestoreFailure(message: 'Benutzersuche fehlgeschlagen: $e');
    }
  }
}

