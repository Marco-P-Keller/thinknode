import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:thinknode/features/auth/data/auth_repository.dart';
import 'package:thinknode/features/auth/presentation/screens/forgot_password_screen.dart';
import 'package:thinknode/features/auth/presentation/screens/login_screen.dart';
import 'package:thinknode/features/auth/presentation/screens/profile_screen.dart';
import 'package:thinknode/features/auth/presentation/screens/register_screen.dart';
import 'package:thinknode/features/mindmap/presentation/screens/mindmap_editor_screen.dart';
import 'package:thinknode/features/mindmap/presentation/screens/mindmap_list_screen.dart';

/// GoRouter configuration with auth-guarded routes
final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);

  return GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: false,
    redirect: (context, state) {
      final isLoggedIn = authState.value != null;
      final isAuthRoute = state.matchedLocation == '/login' ||
          state.matchedLocation == '/register' ||
          state.matchedLocation == '/forgot-password';

      // If not logged in and not on an auth route -> redirect to login
      if (!isLoggedIn && !isAuthRoute) {
        return '/login';
      }

      // If logged in and on an auth route -> redirect to home
      if (isLoggedIn && isAuthRoute) {
        return '/';
      }

      return null; // No redirect
    },
    routes: [
      // ==================== Auth Routes ====================
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        name: 'register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/forgot-password',
        name: 'forgotPassword',
        builder: (context, state) => const ForgotPasswordScreen(),
      ),

      // ==================== Protected Routes ====================
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => const MindmapListScreen(),
      ),
      GoRoute(
        path: '/profile',
        name: 'profile',
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: '/editor/:mindmapId',
        name: 'editor',
        builder: (context, state) {
          final mindmapId = state.pathParameters['mindmapId']!;
          return MindmapEditorScreen(mindmapId: mindmapId);
        },
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text('Seite nicht gefunden: ${state.uri}'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.go('/'),
              child: const Text('Zurück zur Startseite'),
            ),
          ],
        ),
      ),
    ),
  );
});

