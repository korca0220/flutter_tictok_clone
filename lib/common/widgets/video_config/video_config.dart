import 'package:flutter/material.dart';

class VideoConfigData extends InheritedWidget {
  const VideoConfigData({
    super.key,
    required this.autoMute,
    required this.toggleMuted,
    required super.child,
  });
  final bool autoMute;
  final VoidCallback toggleMuted;

  static VideoConfigData of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<VideoConfigData>()!;

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    // 리빌드 할지 말지
    return true;
  }
}

class VideoConfig extends StatefulWidget {
  const VideoConfig({super.key, required this.child});
  final Widget child;

  @override
  State<VideoConfig> createState() => _VideoConfigState();
}

class _VideoConfigState extends State<VideoConfig> {
  bool autoMute = false;

  void toggleMuted() {
    setState(() {
      autoMute = !autoMute;
    });
  }

  @override
  Widget build(BuildContext context) {
    return VideoConfigData(
      toggleMuted: toggleMuted,
      autoMute: autoMute,
      child: widget.child,
    );
  }
}
