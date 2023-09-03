import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/user_profile_model.dart';

final userRepo = Provider((ref) => UserRepository());

class UserRepository {
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // create profile
  Future<void> createProfile(UserProfileModel profile) async {
    _db.collection('users').doc(profile.uid).set(profile.toJson());
  }

  // get profile
  Future<Map<String, dynamic>?> getProfile(String uid) async {
    final doc = await _db.collection('users').doc(uid).get();
    return doc.data();
  }

  // update avatar
  Future<void> uploadAvatar(File file, String fileName) async {
    final fileRef = _firebaseStorage.ref().child('avatars/$fileName');
    await fileRef.putFile(file);
  }

  // update bio
}
