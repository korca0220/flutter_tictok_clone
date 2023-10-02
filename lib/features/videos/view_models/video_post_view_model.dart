import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../authentication/repos/authentication_repo.dart';
import '../repos/videos_repo.dart';

final videoPostProvider =
    AsyncNotifierProvider.family<VideoPostVideModel, void, String>(
  () => VideoPostVideModel(),
);

class VideoPostVideModel extends FamilyAsyncNotifier<void, String> {
  late final VideosRepository _repository;
  late final _videoId;

  @override
  FutureOr<void> build(String arg) {
    _videoId = arg;
    _repository = ref.read(videosRepo);
  }

  Future<void> likeVideo() async {
    final user = ref.read(authRepo).user;

    await _repository.likeVideo(_videoId, user!.uid);
  }
}
