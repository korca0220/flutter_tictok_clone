import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../utils.dart';
import '../../authentication/repos/authentication_repo.dart';
import '../repos/user_repo.dart';
import 'user_view_model.dart';

final userAvatarProvider = AsyncNotifierProvider<UserAvatarViewModel, void>(
  () => UserAvatarViewModel(),
);

class UserAvatarViewModel extends AsyncNotifier<void> {
  late final UserRepository _repository;

  @override
  FutureOr<void> build() {
    _repository = ref.read(userRepo);
  }

  Future<void> uploadAvatar(BuildContext context, File file) async {
    state = const AsyncValue.loading();
    final fileName = ref.read(authRepo).user!.uid;
    state = await AsyncValue.guard(() async {
      await _repository.uploadAvatar(
        file,
        fileName,
      );
      await ref.read(usersProvider.notifier).onAvatarUpload();
    });
    if (state.hasError) {
      showFirebaseErrorSnack(context, state.error);
    }
  }
}
