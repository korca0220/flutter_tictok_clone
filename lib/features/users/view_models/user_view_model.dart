import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../authentication/repos/authentication_repo.dart';
import '../models/user_profile_model.dart';
import '../repos/user_repo.dart';

final usersProvider = AsyncNotifierProvider<UsersViewModel, UserProfileModel>(
  () => UsersViewModel(),
);

class UsersViewModel extends AsyncNotifier<UserProfileModel> {
  late final UserRepository _userRepository;
  late final AuthenticationRepository _authenticationRepository;

  @override
  FutureOr<UserProfileModel> build() async {
    _userRepository = ref.read(userRepo);
    _authenticationRepository = ref.read(authRepo);

    if (_authenticationRepository.isLoggedIn) {
      final profile = await _userRepository.getProfile(
        _authenticationRepository.user!.uid,
      );
      if (profile != null) {
        return UserProfileModel.fromJson(profile);
      }
    }
    return UserProfileModel.empty();
  }

  Future<void> createProfile(UserCredential userCredential, String name) async {
    if (userCredential.user == null) {
      throw Exception('Account not created');
    }
    state = const AsyncValue.loading();
    final profile = UserProfileModel(
      uid: userCredential.user!.uid,
      email: userCredential.user!.email ?? 'anon@anon.com',
      name: userCredential.user!.displayName ?? name,
      bio: 'undefined',
      link: 'undefined',
      hasAvatar: false,
    );
    await _userRepository.createProfile(profile);
    state = AsyncValue.data(profile);
  }

  Future<void> onAvatarUpload() async {
    if (state.value == null) return;
    state = AsyncValue.data(
      state.value!.copyWith(
        hasAvatar: true,
      ),
    );
    await _userRepository.updateUser(
      state.value!.uid,
      {
        'hasAvatar': true,
      },
    );
  }
}
