import 'package:flutter/material.dart';
import 'package:tictok_clone/features/videos/widgets/video_post.dart';

class VideosTimelineScreen extends StatefulWidget {
  const VideosTimelineScreen({super.key});

  @override
  State<VideosTimelineScreen> createState() => _VideosTimelineScreenState();
}

class _VideosTimelineScreenState extends State<VideosTimelineScreen> {
  final _pageController = PageController();
  final _scrollDuration = const Duration(milliseconds: 250);
  final _scrollCurve = Curves.linear;

  int _itemCount = 4;

  void _onPageChanged(int page) {
    _pageController.animateToPage(page,
        duration: _scrollDuration, curve: _scrollCurve);
    if (page == _itemCount - 1) {
      _itemCount = _itemCount + 4;
      setState(() {});
    }
  }

  void _onVideoFinished() {
    _pageController.nextPage(
      duration: _scrollDuration,
      curve: _scrollCurve,
    );
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: _pageController,
      scrollDirection: Axis.vertical,
      onPageChanged: _onPageChanged,
      itemCount: _itemCount,
      itemBuilder: (context, index) => VideoPost(
        onVideoFinished: _onVideoFinished,
        index: index,
      ),
    );
  }
}
