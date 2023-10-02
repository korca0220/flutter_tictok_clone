import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../authentication/repos/authentication_repo.dart';
import '../repos/videos_repo.dart';

final videoPostProvider =
    AsyncNotifierProvider.family<VideoPostVideModel, void, String>(
  () => VideoPostVideModel(),
);

class VideoPostVideModel extends FamilyAsyncNotifier<void, String> {
  late final VideosRepository _repository;
  late final String _videoId;
  late final User? _user;

  @override
  FutureOr<void> build(String arg) {
    _videoId = arg;
    _user = ref.read(authRepo).user;
    _repository = ref.read(videosRepo);
  }

  Future<void> likeVideo() async {
    await _repository.likeVideo(_videoId, _user!.uid);
  }

  Future<bool> isLikeVideo() async {
    return await _repository.isLiked(_videoId, _user!.uid);
  }
}
