import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/data/auth_repository.dart';
import '../../features/auth/domain/app_user.dart';
import '../../features/auth/presentation/login_screen.dart';
import '../../features/gallery/presentation/photo_gallery_screen.dart';
import '../../features/gallery/presentation/photo_upload_screen.dart';
import '../../features/home/presentation/home_screen.dart';
import '../../features/livestream/presentation/livestream_screen.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/login',
    refreshListenable: GoRouterRefreshStream(
      ref.watch(authStateChangesProvider.stream),
    ),
    redirect: (context, state) {
      final authSnapshot = ref.read(authStateChangesProvider);
      final appUserSnapshot = ref.read(currentAppUserProvider);
      final isLoggedIn = authSnapshot.asData?.value != null;
      final onLogin = state.matchedLocation == '/login';

      if (!isLoggedIn && !onLogin) return '/login';
      if (isLoggedIn && onLogin) return '/home';

      final appUser = appUserSnapshot.asData?.value;
      final onUpload = state.matchedLocation == '/photos/upload';
      if (onUpload && appUser != null && !appUser.canUpload) return '/photos';

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
        path: '/photos/upload',
        builder: (context, state) => const PhotoUploadScreen(),
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
