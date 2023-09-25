import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../view_models/timeline_view_model.dart';
import 'widgets/video_post.dart';

class VideosTimelineScreen extends ConsumerStatefulWidget {
  const VideosTimelineScreen({super.key});

  @override
  VideosTimelineScreenState createState() => VideosTimelineScreenState();
}

class VideosTimelineScreenState extends ConsumerState<VideosTimelineScreen> {
  final _pageController = PageController();
  final _scrollDuration = const Duration(milliseconds: 250);
  final _scrollCurve = Curves.linear;

  int _itemCount = 0;

  void _onPageChanged(int page) {
    _pageController.animateToPage(
      page,
      duration: _scrollDuration,
      curve: _scrollCurve,
    );
    if (page == _itemCount - 1) {
      ref.watch(timelineProvider.notifier).fetchNextPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ref.watch(timelineProvider).when(
          error: (error, stackTrace) => Center(
            child: Text(
              'Could not load videos $error',
              style: const TextStyle(color: Colors.white),
            ),
          ),
          loading: () => const Center(
            child: CircularProgressIndicator(),
          ),
          data: (videos) {
            _itemCount = videos.length;

            return RefreshIndicator(
              onRefresh: _onRefresh,
              displacement: 50,
              edgeOffset: 20,
              color: Theme.of(context).primaryColor,
              child: PageView.builder(
                controller: _pageController,
                scrollDirection: Axis.vertical,
                onPageChanged: _onPageChanged,
                itemCount: videos.length,
                itemBuilder: (context, index) {
                  final videoData = videos[index];
                  return VideoPost(
                    index: index,
                    videoData: videoData,
                  );
                },
              ),
            );
          },
        );
  }

  Future<void> _onRefresh() {
    return Future.delayed(const Duration(seconds: 3));
  }
}
