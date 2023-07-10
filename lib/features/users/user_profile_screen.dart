import 'package:flutter/material.dart';

import '../../constants/sizes.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            backgroundColor: Colors.teal,
            elevation: 1,
            collapsedHeight: 80,
            expandedHeight: 200,
            flexibleSpace: FlexibleSpaceBar(
              stretchModes: const [
                StretchMode.blurBackground,
                StretchMode.zoomBackground,
              ],
              background: Image.asset(
                'assets/images/placeholder.jpeg',
                fit: BoxFit.cover,
              ),
              title: const Text('Hello!'),
            ),
          ),
          SliverFixedExtentList(
            delegate: SliverChildBuilderDelegate(
              childCount: 10,
              (context, index) => Container(
                color: Colors.amber[100 * (index % 9)],
                child: Align(
                  alignment: Alignment.center,
                  child: Text('Item $index'),
                ),
              ),
            ),
            itemExtent: 50,
          ),
          const SliverToBoxAdapter(
            child: CircleAvatar(),
          ),
          SliverPersistentHeader(
            delegate: CustomDelegate(),
            pinned: true,
          ),
          SliverGrid(
            delegate: SliverChildBuilderDelegate(
              childCount: 30,
              (context, index) => Container(
                color: Colors.blue[100 * (index % 9)],
                child: Align(
                  alignment: Alignment.center,
                  child: Text('Item $index'),
                ),
              ),
            ),
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 100,
              mainAxisSpacing: Sizes.size20,
              crossAxisSpacing: Sizes.size20,
              childAspectRatio: 1,
            ),
          )
        ],
      ),
    );
  }
}

class CustomDelegate extends SliverPersistentHeaderDelegate {
  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      color: Colors.indigo,
      child: const FractionallySizedBox(
        heightFactor: 1,
        child: Center(
          child: Text(
            'Title!',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  @override
  double get maxExtent => 150;

  @override
  double get minExtent => 80;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
