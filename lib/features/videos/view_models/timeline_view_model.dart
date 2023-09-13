import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repos/video_model.dart';
import '../repos/videos_repo.dart';

final timelineProvider =
    AsyncNotifierProvider<TimelineViewModel, List<VideoModel>>(
  () => TimelineViewModel(),
);

class TimelineViewModel extends AsyncNotifier<List<VideoModel>> {
  late final VideosRepository _repository;
  List<VideoModel> _list = [];

  @override
  FutureOr<List<VideoModel>> build() async {
    _repository = ref.read(videosRepo);
    final result = await _repository.fetchVideos();
    final newList = result.docs.map(
      (video) => VideoModel.fromJson(
        video.data(),
      ),
    );
    _list = newList.toList();
    return _list;
  }
}
