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

  Future<List<VideoModel>> _fetchVideos({int? lastItemCreatedAt}) async {
    final result = await _repository.fetchVideos(
      lastItemCreatedAt: lastItemCreatedAt,
    );
    final videos = result.docs.map(
      (video) => VideoModel.fromJson(
        video.data(),
      ),
    );
    return videos.toList();
  }

  @override
  FutureOr<List<VideoModel>> build() async {
    _repository = ref.read(videosRepo);

    _list = await _fetchVideos(lastItemCreatedAt: null);
    return _list;
  }

  fetchNextPage() async {
    final nextPages = await _fetchVideos(
      lastItemCreatedAt: _list.last.createdAt,
    );

    state = AsyncValue.data([..._list, ...nextPages]);
  }
}
