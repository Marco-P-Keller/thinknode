import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thinknode/features/auth/data/auth_repository.dart';
import 'package:thinknode/features/auth/domain/models/user_model.dart';

/// Provider for the current user profile (from Firestore)
final currentUserProvider = StreamProvider<UserModel?>((ref) {
  final authState = ref.watch(authStateProvider);
  return authState.when(
    data: (user) {
      if (user == null) return Stream.value(null);
      return ref.watch(authRepositoryProvider).streamUserProfile(user.uid);
    },
    loading: () => Stream.value(null),
    error: (_, __) => Stream.value(null),
  );
});

/// Auth action state for tracking loading/error in auth forms
enum AuthStatus { idle, loading, success, error }

class AuthState {
  final AuthStatus status;
  final String? errorMessage;

  const AuthState({this.status = AuthStatus.idle, this.errorMessage});

  AuthState copyWith({AuthStatus? status, String? errorMessage}) {
    return AuthState(
      status: status ?? this.status,
      errorMessage: errorMessage,
    );
  }
}

/// Notifier for handling auth actions (login, register, etc.)
class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _authRepository;

  AuthNotifier(this._authRepository) : super(const AuthState());

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    state = const AuthState(status: AuthStatus.loading);
    try {
      await _authRepository.signIn(email: email, password: password);
      state = const AuthState(status: AuthStatus.success);
    } catch (e) {
      state = AuthState(
        status: AuthStatus.error,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> register({
    required String email,
    required String password,
    required String displayName,
  }) async {
    state = const AuthState(status: AuthStatus.loading);
    try {
      await _authRepository.register(
        email: email,
        password: password,
        displayName: displayName,
      );
      state = const AuthState(status: AuthStatus.success);
    } catch (e) {
      state = AuthState(
        status: AuthStatus.error,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> resetPassword({required String email}) async {
    state = const AuthState(status: AuthStatus.loading);
    try {
      await _authRepository.resetPassword(email: email);
      state = const AuthState(status: AuthStatus.success);
    } catch (e) {
      state = AuthState(
        status: AuthStatus.error,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> signOut() async {
    await _authRepository.signOut();
    state = const AuthState();
  }

  void resetState() {
    state = const AuthState();
  }
}

/// Provider for the AuthNotifier
final authNotifierProvider =
    StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref.watch(authRepositoryProvider));
});

