import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/data/auth_repository.dart';
import '../../features/auth/presentation/login_screen.dart';
import '../../features/gallery/presentation/photo_gallery_screen.dart';
import '../../features/home/presentation/home_screen.dart';
import '../../features/livestream/presentation/livestream_screen.dart';

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
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/photos',
        builder: (context, state) => const PhotoGalleryScreen(),
      ),
      GoRoute(
        path: '/livestream',
        builder: (context, state) => const LivestreamScreen(),
      ),
    ],
  );
});

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
