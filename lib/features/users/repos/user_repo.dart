import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/user_profile_model.dart';

final userRepo = Provider((ref) => UserRepository());

class UserRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // create profile
  Future<void> createProfile(UserProfileModel profile) async {
    _db.collection('users').doc(profile.uid).set(profile.toJson());
  }

  // get profile

  // update avatar

  // update bio
}
