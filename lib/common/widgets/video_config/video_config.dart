import 'package:flutter/material.dart';

class VideoConfig extends InheritedWidget {
  const VideoConfig({super.key, required super.child});

  final bool autoMute = false;

  static VideoConfig of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<VideoConfig>()!;

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    // 리빌드 할지 말지
    return true;
  }
}
