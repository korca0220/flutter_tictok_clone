import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPreviewScreen extends StatefulWidget {
  const VideoPreviewScreen({
    super.key,
    required this.video,
  });

  final XFile video;

  @override
  State<VideoPreviewScreen> createState() => _VideoPreviewScreenState();
}

class _VideoPreviewScreenState extends State<VideoPreviewScreen> {
  late final VideoPlayerController videoPlayerController;
  @override
  void initState() {
    super.initState();
    initVideo();
  }

  initVideo() async {
    videoPlayerController = VideoPlayerController.file(File(widget.video.path));

    await videoPlayerController.initialize();
    await videoPlayerController.setLooping(true);
    await videoPlayerController.play();
    setState(() {});
  }

  @override
  void dispose() {
    videoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Preview Video'),
      ),
      body: videoPlayerController.value.isInitialized
          ? VideoPlayer(videoPlayerController)
          : null,
    );
  }
}
