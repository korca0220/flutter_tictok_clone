import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/playback_config_model.dart';
import '../repos/playback_config_repo.dart';

final playbackConfigProvider =
    NotifierProvider<PlaybackConfigViewModel, PlaybackConfigModel>(
  () => throw UnimplementedError(),
);

class PlaybackConfigViewModel extends Notifier<PlaybackConfigModel> {
  PlaybackConfigViewModel(this._repository);
  final PlaybackConfigRepository _repository;

  bool get muted => state.muted;
  bool get autoPlay => state.autoplay;

  void setMuted(bool value) {
    _repository.setMuted(value);
    state = PlaybackConfigModel(
      muted: value,
      autoplay: state.autoplay,
    );
  }

  void setAutoplay(bool value) {
    _repository.setAutoplay(value);
    state = PlaybackConfigModel(
      muted: state.muted,
      autoplay: value,
    );
  }

  @override
  PlaybackConfigModel build() {
    return PlaybackConfigModel(
      muted: _repository.getMuted(),
      autoplay: _repository.getAutoplay(),
    );
  }
}
