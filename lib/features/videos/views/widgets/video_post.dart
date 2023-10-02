import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../../../constants/gaps.dart';
import '../../../../constants/sizes.dart';
import '../../repos/video_model.dart';
import '../../view_models/playback_config_view_model.dart';
import '../../view_models/video_post_view_model.dart';
import 'video_button.dart';
import 'video_comments.dart';

class VideoPost extends ConsumerStatefulWidget {
  const VideoPost({
    super.key,
    required this.index,
    required this.videoData,
  });

  final int index;
  final VideoModel videoData;

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
  bool _isLiked = false;
  int _isLikeCount = 0;

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

  void _initLikedVideo() async {
    _isLiked = await ref
        .read(videoPostProvider(widget.videoData.id).notifier)
        .isLikeVideo();

    _isLikeCount = widget.videoData.likes;
  }

  @override
  void initState() {
    super.initState();
    _initVideoPlayer();
    _initLikedVideo();

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

  void _onLikeTap() {
    ref.read(videoPostProvider(widget.videoData.id).notifier).likeVideo();

    if (_isLiked) {
      _isLikeCount--;
    } else {
      _isLikeCount++;
    }
    _isLiked = !_isLiked;

    setState(() {});
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
                : Image.network(
                    widget.videoData.thumbnailUrl,
                    fit: BoxFit.cover,
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
                Text(
                  '@${widget.videoData.creator}',
                  style: const TextStyle(
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
                        widget.videoData.description,
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
                CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  foregroundImage: NetworkImage(
                    'https://firebasestorage.googleapis.com/v0/b/tik-tok-junewoo.appspot.com/o/avatars%2F${widget.videoData.creatorUid}?alt=media&token=b15373e4-a8b7-4a0d-8f8a-0e2d907cbd63',
                  ),
                  child: Text(widget.videoData.creator),
                ),
                Gaps.v24,
                VideoButton(
                  icon: FontAwesomeIcons.solidHeart,
                  text: _isLikeCount.toString(),
                  color: _isLiked ? Colors.red : Colors.white,
                  onTap: _onLikeTap,
                ),
                Gaps.v24,
                GestureDetector(
                  onTap: () => _onCommentTap(context),
                  child: const VideoButton(
                    icon: FontAwesomeIcons.solidComment,
                    text: '3.9M',
                    color: Colors.white,
                  ),
                ),
                Gaps.v24,
                const VideoButton(
                  icon: FontAwesomeIcons.share,
                  text: 'Share',
                  color: Colors.white,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
