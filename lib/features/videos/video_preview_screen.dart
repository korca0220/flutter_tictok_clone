import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gal/gal.dart';
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
  bool savedVideo = false;

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

  Future<void> saveToGallery() async {
    if (savedVideo) return;

    await Gal.putVideo(widget.video.path, album: 'TikTok Clone!');

    savedVideo = true;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Preview Video'),
        actions: [
          IconButton(
            onPressed: saveToGallery,
            icon: FaIcon(
              savedVideo ? FontAwesomeIcons.check : FontAwesomeIcons.download,
            ),
          ),
        ],
      ),
      body: videoPlayerController.value.isInitialized
          ? VideoPlayer(videoPlayerController)
          : null,
    );
  }
}
