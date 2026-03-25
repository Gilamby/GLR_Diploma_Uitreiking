import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/app_user.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(
    auth: FirebaseAuth.instance,
    firestore: FirebaseFirestore.instance,
  );
});

final authStateChangesProvider = StreamProvider<User?>((ref) {
  return ref.watch(authRepositoryProvider).authStateChanges();
});

final currentAppUserProvider = StreamProvider<AppUser?>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return repository.currentAppUser();
});

class AuthRepository {
  AuthRepository({
    required FirebaseAuth auth,
    required FirebaseFirestore firestore,
  })  : _auth = auth,
        _firestore = firestore;

  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  /// Stream / ceremony gate: code must match [STREAM_ACCESS_CODE] in `.env`.
  /// Firebase still needs a real session for Firestore rules — use one shared
  /// viewer account via [EVENT_VIEWER_EMAIL] / [EVENT_VIEWER_PASSWORD] in `.env`.
  Future<void> signInWithAccessCode(String accessCode) async {
    final expected = dotenv.env['STREAM_ACCESS_CODE']?.trim() ?? '';
    if (expected.isEmpty) {
      throw StateError('STREAM_ACCESS_CODE is not set in .env');
    }
    if (accessCode.trim() != expected) {
      throw StateError('Invalid access code');
    }
    final email = dotenv.env['EVENT_VIEWER_EMAIL']?.trim() ?? '';
    final password = dotenv.env['EVENT_VIEWER_PASSWORD'] ?? '';
    if (email.isEmpty || password.isEmpty) {
      throw StateError('EVENT_VIEWER_EMAIL / EVENT_VIEWER_PASSWORD missing in .env');
    }
    await _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<void> signOut() => _auth.signOut();

  Stream<User?> authStateChanges() => _auth.authStateChanges();

  Stream<AppUser?> currentAppUser() {
    return _auth.authStateChanges().asyncMap((user) async {
      if (user == null) return null;
      final profileDoc = await _firestore.collection('users').doc(user.uid).get();
      if (!profileDoc.exists) return null;
      final data = profileDoc.data()!;
      final roleRaw = data['role'] as String? ?? 'student';
      return AppUser(
        uid: user.uid,
        role: UserRole.values.firstWhere(
          (value) => value.name == roleRaw,
          orElse: () => UserRole.student,
        ),
        examClass: data['examClass'] as String? ?? '',
      );
    });
  }
}
