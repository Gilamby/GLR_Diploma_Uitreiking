import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/data/auth_repository.dart';
import '../../features/auth/presentation/login_screen.dart';
import '../../features/gallery/presentation/photo_gallery_screen.dart';
import '../../features/gallery/presentation/photo_details_screen.dart';
import '../../features/home/presentation/home_screen.dart';
import '../../features/livestream/presentation/livestream_screen.dart';
import '../../features/yearbook/presentation/yearbook_details_screen.dart';
import '../../features/yearbook/presentation/yearbook_screen.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/login',
    refreshListenable: GoRouterRefreshStream(
      ref.read(authRepositoryProvider).authStateChanges(),
    ),
    redirect: (context, state) {
      final authSnapshot = ref.read(authStateChangesProvider);
      final isLoggedIn = authSnapshot.asData?.value != null;
      final onLogin = state.matchedLocation == '/login';

      if (!isLoggedIn && !onLogin) return '/login';
      if (isLoggedIn && onLogin) return '/home';

      // Photo uploads are disabled (Firebase Storage removed).
      if (state.matchedLocation == '/photos/upload') return '/photos';

      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        pageBuilder: (context, state) => _fadeSlidePage(
          key: state.pageKey,
          child: const LoginScreen(),
        ),
      ),
      GoRoute(
        path: '/home',
        pageBuilder: (context, state) => _fadeSlidePage(
          key: state.pageKey,
          child: const HomeScreen(),
        ),
      ),
      GoRoute(
        path: '/photos',
        pageBuilder: (context, state) => _fadeSlidePage(
          key: state.pageKey,
          child: const PhotoGalleryScreen(),
        ),
      ),
      GoRoute(
        path: '/photos/details/:id',
        pageBuilder: (context, state) => _fadeSlidePage(
          key: state.pageKey,
          child: PhotoDetailsScreen(
            photoId: state.pathParameters['id'] ?? '',
          ),
        ),
      ),
      GoRoute(
        path: '/livestream',
        pageBuilder: (context, state) => _fadeSlidePage(
          key: state.pageKey,
          child: const LivestreamScreen(),
        ),
      ),
      GoRoute(
        path: '/jaarboek',
        pageBuilder: (context, state) => _fadeSlidePage(
          key: state.pageKey,
          child: const YearbookScreen(),
        ),
      ),
      GoRoute(
        path: '/jaarboek/details/:id',
        pageBuilder: (context, state) => _fadeSlidePage(
          key: state.pageKey,
          child: YearbookDetailsScreen(
            studentId: state.pathParameters['id'] ?? '',
          ),
        ),
      ),
    ],
  );
});

Page<void> _fadeSlidePage({
  required LocalKey key,
  required Widget child,
}) {
  return CustomTransitionPage<void>(
    key: key,
    transitionDuration: const Duration(milliseconds: 220),
    reverseTransitionDuration: const Duration(milliseconds: 180),
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final fade = CurvedAnimation(parent: animation, curve: Curves.easeOutCubic);
      final slide = Tween<Offset>(
        begin: const Offset(0, 0.02),
        end: Offset.zero,
      ).chain(CurveTween(curve: Curves.easeOutCubic)).animate(animation);

      return FadeTransition(
        opacity: fade,
        child: SlideTransition(position: slide, child: child),
      );
    },
  );
}

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    _subscription = stream.asBroadcastStream().listen(
          (_) => notifyListeners(),
        );
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
