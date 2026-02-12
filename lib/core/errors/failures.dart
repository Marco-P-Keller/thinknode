/// Base class for application failures
abstract class Failure {
  final String message;
  final String? code;

  const Failure({required this.message, this.code});

  @override
  String toString() => 'Failure(message: $message, code: $code)';
}

/// Authentication related failures
class AuthFailure extends Failure {
  const AuthFailure({required super.message, super.code});

  factory AuthFailure.fromCode(String code) {
    switch (code) {
      case 'invalid-email':
        return const AuthFailure(
          message: 'Die E-Mail-Adresse ist ungültig.',
          code: 'invalid-email',
        );
      case 'user-disabled':
        return const AuthFailure(
          message: 'Dieses Konto wurde deaktiviert.',
          code: 'user-disabled',
        );
      case 'user-not-found':
        return const AuthFailure(
          message: 'Kein Konto mit dieser E-Mail-Adresse gefunden.',
          code: 'user-not-found',
        );
      case 'wrong-password':
        return const AuthFailure(
          message: 'Das Passwort ist falsch.',
          code: 'wrong-password',
        );
      case 'email-already-in-use':
        return const AuthFailure(
          message: 'Diese E-Mail-Adresse wird bereits verwendet.',
          code: 'email-already-in-use',
        );
      case 'weak-password':
        return const AuthFailure(
          message: 'Das Passwort ist zu schwach.',
          code: 'weak-password',
        );
      case 'operation-not-allowed':
        return const AuthFailure(
          message: 'Diese Anmeldemethode ist nicht erlaubt.',
          code: 'operation-not-allowed',
        );
      case 'too-many-requests':
        return const AuthFailure(
          message: 'Zu viele Anfragen. Bitte versuchen Sie es später erneut.',
          code: 'too-many-requests',
        );
      case 'invalid-credential':
        return const AuthFailure(
          message: 'E-Mail oder Passwort ist falsch.',
          code: 'invalid-credential',
        );
      default:
        return AuthFailure(
          message: 'Ein Authentifizierungsfehler ist aufgetreten: $code',
          code: code,
        );
    }
  }
}

/// Firestore related failures
class FirestoreFailure extends Failure {
  const FirestoreFailure({required super.message, super.code});
}

/// Network related failures
class NetworkFailure extends Failure {
  const NetworkFailure({
    super.message = 'Keine Internetverbindung.',
    super.code,
  });
}

/// General/unknown failures
class UnknownFailure extends Failure {
  const UnknownFailure({
    super.message = 'Ein unbekannter Fehler ist aufgetreten.',
    super.code,
  });
}

