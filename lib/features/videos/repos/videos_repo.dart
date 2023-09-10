import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final videosRepo = Provider((ref) => VideosRepository());

class VideosRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  uploadVideoFile(File video, String uid) async {
    final fileRef = _firebaseStorage.ref().child(
          '/videos/$uid/${DateTime.now().millisecondsSinceEpoch.toString()}',
        );
    return fileRef.putFile(video);
  }
}
