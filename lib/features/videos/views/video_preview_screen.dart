import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gal/gal.dart';
import 'package:video_player/video_player.dart';

import '../view_models/upload_video_view_model.dart';

class VideoPreviewScreen extends ConsumerStatefulWidget {
  const VideoPreviewScreen({
    super.key,
    required this.video,
    this.isPicked = false,
  });

  final bool isPicked;
  final XFile video;

  @override
  VideoPreviewScreenState createState() => VideoPreviewScreenState();
}

class VideoPreviewScreenState extends ConsumerState<VideoPreviewScreen> {
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
    await videoPlayerController.setVolume(0);
    // await videoPlayerController.play();
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

  void _onUploadPressed() {
    ref.read(uploadVideoProvider.notifier).uploadVideo(
          File(widget.video.path),
          context,
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Preview Video'),
        actions: [
          if (widget.isPicked == false)
            IconButton(
              onPressed: ref.watch(uploadVideoProvider).isLoading
                  ? () {}
                  : _onUploadPressed,
              icon: ref.watch(uploadVideoProvider).isLoading
                  ? const CircularProgressIndicator()
                  : FaIcon(
                      savedVideo
                          ? FontAwesomeIcons.check
                          : FontAwesomeIcons.download,
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
