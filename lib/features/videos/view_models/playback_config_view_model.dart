import 'package:flutter/material.dart';

import '../models/playback_config_model.dart';
import '../repos/playback_config_repo.dart';

class PlaybackConfigViewModel extends ChangeNotifier {
  PlaybackConfigViewModel(this._repository);
  final PlaybackConfigRepository _repository;

  late final PlaybackConfigModel _model = PlaybackConfigModel(
    muted: _repository.getMuted(),
    autoplay: _repository.getAutoplay(),
  );

  bool get muted => _model.muted;
  bool get autoPlay => _model.autoplay;

  void setMuted(bool value) {
    _repository.setMuted(value);
    _model.muted = value;
    notifyListeners();
  }

  void setAutoplay(bool value) {
    _repository.setAutoplay(value);
    _model.autoplay = value;
    notifyListeners();
  }
}
