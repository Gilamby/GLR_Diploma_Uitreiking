import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

  Future<void> signInWithAccessCode(String accessCode) async {
    final doc = await _firestore.collection('access_codes').doc(accessCode).get();
    if (!doc.exists) {
      throw StateError('Invalid access code');
    }
    final data = doc.data()!;
    final email = data['email'] as String;
    final password = data['password'] as String;
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
