import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPost extends StatefulWidget {
  final Function onVideoFinished;
  const VideoPost({
    super.key,
    required this.onVideoFinished,
  });

  @override
  State<VideoPost> createState() => _VideoPostState();
}

class _VideoPostState extends State<VideoPost> {
  final _videoController =
      VideoPlayerController.asset('assets/videos/video.mp4');

  void _onVideoChange() {
    if (_videoController.value.isInitialized) {
      if (_videoController.value.duration == _videoController.value.position) {
        widget.onVideoFinished();
      }
    }
  }

  void _initVideoPlayer() async {
    await _videoController.initialize();
    _videoController.play();
    _videoController.addListener(_onVideoChange);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _initVideoPlayer();
  }

  @override
  void dispose() {
    _videoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: _videoController.value.isInitialized
              ? VideoPlayer(_videoController)
              : Container(
                  color: Colors.black,
                ),
        ),
      ],
    );
  }
}
