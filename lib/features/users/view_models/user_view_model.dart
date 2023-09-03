import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/user_profile_model.dart';
import '../repos/user_repo.dart';

final usersProvider = AsyncNotifierProvider<UsersViewModel, UserProfileModel>(
  () => UsersViewModel(),
);

class UsersViewModel extends AsyncNotifier<UserProfileModel> {
  late final UserRepository _repository;

  @override
  FutureOr<UserProfileModel> build() {
    _repository = ref.read(userRepo);
    return UserProfileModel.empty();
  }

  Future<void> createProfile(UserCredential userCredential) async {
    if (userCredential.user == null) {
      throw Exception('Account not created');
    }
    state = const AsyncValue.loading();
    final profile = UserProfileModel(
      uid: userCredential.user!.uid,
      email: userCredential.user!.email ?? 'anon@anon.com',
      name: userCredential.user!.displayName ?? 'Anon',
      bio: 'undefined',
      link: 'undefined',
    );
    await _repository.createProfile(profile);
    state = AsyncValue.data(profile);
  }
}
