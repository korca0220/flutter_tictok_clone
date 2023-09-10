import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../authentication/repos/authentication_repo.dart';
import '../../users/view_models/user_view_model.dart';
import '../repos/video_model.dart';
import '../repos/videos_repo.dart';

final uploadVideoProvider = AsyncNotifierProvider<UploadVideoViewModel, void>(
  () => UploadVideoViewModel(),
);

class UploadVideoViewModel extends AsyncNotifier<void> {
  late final VideosRepository _repository;

  @override
  FutureOr<void> build() {
    _repository = ref.read(videosRepo);
  }

  Future<void> uploadVideo(File video, BuildContext context) async {
    final user = ref.read(authRepo).user;
    final userProfile = ref.read(usersProvider).value;
    if (userProfile != null) {
      state = const AsyncValue.loading();
      state = await AsyncValue.guard(() async {
        final task = await _repository.uploadVideoFile(
          video,
          user!.uid,
        );

        if (task.metadata != null) {
          await _repository.saveVideo(
            VideoModel(
              title: 'From Flutter',
              fileUrl: await task.ref.getDownloadURL(),
              description: 'Hello',
              thumbnailUrl: '',
              likes: 0,
              comments: 0,
              creatorUid: user.uid,
              creator: userProfile.name,
              createdAt: DateTime.now().millisecondsSinceEpoch,
            ),
          );
          context.pushReplacement('/home');
        }
      });
    }
  }
}
