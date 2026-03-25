import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final photoRepositoryProvider = Provider<PhotoRepository>((ref) {
  return PhotoRepository(
    firestore: FirebaseFirestore.instance,
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
  })  : _firestore = firestore,
        _uploadsEnabled = false;

  final FirebaseFirestore _firestore;
  final bool _uploadsEnabled;

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
    if (!_uploadsEnabled) {
      throw StateError(
        'Photo upload is disabled (Firebase Storage removed). '
        'Use externally hosted image URLs and write them into Firestore `photos/*` instead.',
      );
    }
  }
}
