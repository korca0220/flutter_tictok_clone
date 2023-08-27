import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../../../constants/gaps.dart';
import '../../../../constants/sizes.dart';
import '../../view_models/playback_config_view_model.dart';
import 'video_button.dart';
import 'video_comments.dart';

class VideoPost extends ConsumerStatefulWidget {
  final int index;
  const VideoPost({
    super.key,
    required this.index,
  });

  @override
  VideoPostState createState() => VideoPostState();
}

class VideoPostState extends ConsumerState<VideoPost>
    with SingleTickerProviderStateMixin {
  final _videoController =
      VideoPlayerController.asset('assets/videos/video.mp4');
  final _animationDuration = const Duration(milliseconds: 200);

  late AnimationController _animationController;

  bool _isPaused = false;
  bool _isMoreText = false;
  late bool _isMuted = ref.read(playbackConfigProvider).muted;

  void _onVisibilityChanged(VisibilityInfo info) {
    if (!mounted) return;
    if (info.visibleFraction == 1 &&
        !_videoController.value.isPlaying &&
        !_isPaused) {
      final autoplay = ref.read(playbackConfigProvider).autoplay;

      if (autoplay) _videoController.play();
    }
    if (_videoController.value.isPlaying && info.visibleFraction == 0) {
      _onTogglePause();
    }
  }

  void _initVideoPlayer() async {
    await _videoController.initialize();
    await _videoController.setLooping(true);
    setState(() {});
  }

  void _onTogglePause() {
    if (_videoController.value.isPlaying) {
      _videoController.pause();
      _animationController.reverse();
    } else {
      _videoController.play();
      _animationController.forward();
    }
    setState(() {
      _isPaused = !_isPaused;
    });
  }

  @override
  void initState() {
    super.initState();
    _initVideoPlayer();

    _animationController = AnimationController(
      vsync: this,
      lowerBound: 1.0,
      upperBound: 1.5,
      value: 1.5,
      duration: _animationDuration,
    );
  }

  @override
  void dispose() {
    _videoController.dispose();

    super.dispose();
  }

  void _onTapMoreText() {
    if (_isMoreText) {
    } else {}
    _isMoreText = !_isMoreText;
    setState(() {});
  }

  void _onCommentTap(BuildContext context) async {
    if (_videoController.value.isPlaying) {
      _onTogglePause();
    }
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const VideoComments(),
    );
    _onTogglePause();
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key('${widget.index}'),
      onVisibilityChanged: _onVisibilityChanged,
      child: Stack(
        children: [
          Positioned.fill(
            child: _videoController.value.isInitialized
                ? VideoPlayer(_videoController)
                : Container(
                    color: Colors.black,
                  ),
          ),
          Positioned.fill(
            child: GestureDetector(
              onTap: _onTogglePause,
            ),
          ),
          Positioned.fill(
            child: IgnorePointer(
              child: Center(
                child: AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _animationController.value,
                      child: child,
                    );
                  },
                  child: AnimatedOpacity(
                    duration: _animationDuration,
                    opacity: _isPaused ? 1 : 0,
                    child: const FaIcon(
                      FontAwesomeIcons.play,
                      color: Colors.white,
                      size: Sizes.size52,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: 20,
            top: 20,
            child: IconButton(
              onPressed: () {
                _isMuted = !_isMuted;
                setState(() {});
              },
              icon: FaIcon(
                _isMuted
                    ? FontAwesomeIcons.volumeOff
                    : FontAwesomeIcons.volumeHigh,
                color: Colors.white,
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            left: 10,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '@Junewoo',
                  style: TextStyle(
                    fontSize: Sizes.size20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Gaps.v10,
                Row(
                  children: [
                    SizedBox(
                      width: 200,
                      child: Text(
                        'This is my house in Korea lalalalalalal',
                        maxLines: _isMoreText ? null : 1,
                        style: const TextStyle(
                          fontSize: Sizes.size16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    !_isMoreText
                        ? GestureDetector(
                            onTap: _onTapMoreText,
                            child: const Text(
                              '...See more',
                              style: TextStyle(
                                fontSize: Sizes.size16,
                                color: Colors.white,
                              ),
                            ),
                          )
                        : const SizedBox.shrink()
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 20,
            right: 10,
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  foregroundImage: NetworkImage(
                    'https://avatars.githubusercontent.com/u/25660275?v=4',
                  ),
                  child: Text('준우'),
                ),
                Gaps.v24,
                const VideoButton(
                  icon: FontAwesomeIcons.solidHeart,
                  text: '2.9M',
                ),
                Gaps.v24,
                GestureDetector(
                  onTap: () => _onCommentTap(context),
                  child: const VideoButton(
                    icon: FontAwesomeIcons.solidComment,
                    text: '3.9M',
                  ),
                ),
                Gaps.v24,
                const VideoButton(
                  icon: FontAwesomeIcons.share,
                  text: 'Share',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
