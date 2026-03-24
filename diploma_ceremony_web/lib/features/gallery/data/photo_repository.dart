import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final photoRepositoryProvider = Provider<PhotoRepository>((ref) {
  return PhotoRepository(
    firestore: FirebaseFirestore.instance,
    storage: FirebaseStorage.instance,
  );
});

class PhotoItem {
  const PhotoItem({
    required this.id,
    required this.url,
    required this.examClass,
    required this.uploadedBy,
    required this.createdAt,
  });

  final String id;
  final String url;
  final String examClass;
  final String uploadedBy;
  final DateTime createdAt;
}

class PhotoRepository {
  PhotoRepository({
    required FirebaseFirestore firestore,
    required FirebaseStorage storage,
  })  : _firestore = firestore,
        _storage = storage;

  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;

  Stream<List<PhotoItem>> photosForClass(String examClass) {
    return _firestore
        .collection('photos')
        .where('examClass', isEqualTo: examClass)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(
                (doc) => PhotoItem(
                  id: doc.id,
                  url: doc['url'] as String,
                  examClass: doc['examClass'] as String,
                  uploadedBy: doc['uploadedBy'] as String,
                  createdAt: (doc['createdAt'] as Timestamp).toDate(),
                ),
              )
              .toList(),
        );
  }

  Future<void> uploadPhoto({
    required String uid,
    required String examClass,
    required Uint8List fileBytes,
    required String fileName,
  }) async {
    final path = 'photos/$examClass/$uid/$fileName';
    final ref = _storage.ref(path);
    await ref.putData(fileBytes, SettableMetadata(contentType: 'image/jpeg'));
    final url = await ref.getDownloadURL();
    await _firestore.collection('photos').add({
      'url': url,
      'path': path,
      'examClass': examClass,
      'uploadedBy': uid,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }
}
