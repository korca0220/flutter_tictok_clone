import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/user_profile_model.dart';

final usersProvider = AsyncNotifierProvider(
  () => UsersViewModel(),
);

class UsersViewModel extends AsyncNotifier<UserProfileModel> {
  @override
  FutureOr<UserProfileModel> build() {
    return UserProfileModel.empty();
  }

  Future<void> createAccount(UserCredential userCredential) async {
    if (userCredential.user == null) {
      throw Exception('Account not created');
    }
    state = AsyncValue.data(
      UserProfileModel(
        uid: userCredential.user!.uid,
        email: userCredential.user!.email ?? 'anon@anon.com',
        name: userCredential.user!.displayName ?? 'Anon',
        bio: 'undefined',
        link: 'undefined',
      ),
    );
  }
}
