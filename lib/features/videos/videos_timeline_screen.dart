import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class VideosTimelineScreen extends StatefulWidget {
  const VideosTimelineScreen({super.key});

  @override
  State<VideosTimelineScreen> createState() => _VideosTimelineScreenState();
}

class _VideosTimelineScreenState extends State<VideosTimelineScreen> {
  int _itemCount = 4;
  List<Color> colors = [
    Colors.blue,
    Colors.red,
    Colors.yellow,
    Colors.teal,
  ];

  void _onPageChanged(int page) {
    if (page == _itemCount - 1) {
      _itemCount = _itemCount + 4;
      colors.addAll([
        Colors.blue,
        Colors.red,
        Colors.yellow,
        Colors.teal,
      ]);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      scrollDirection: Axis.vertical,
      onPageChanged: _onPageChanged,
      itemCount: colors.length,
      itemBuilder: (context, index) => Container(
        color: colors[index],
        child: Center(
          child: Text(
            'Screen $index',
            style: const TextStyle(
              fontSize: 64,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
