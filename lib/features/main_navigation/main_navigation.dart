import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../constants/gaps.dart';
import '../../constants/sizes.dart';
import '../../utils.dart';
import '../discover/discover_screen.dart';
import '../inbox/inbox_screen.dart';
import '../users/user_profile_screen.dart';
import '../videos/videos_timeline_screen.dart';
import 'widgets/nav_tab.dart';
import 'widgets/post_video_button.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 4;

  void _onTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _onPostVideoButtonTap() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: const Text('Record Video'),
          ),
        ),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = isDarkMode(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Offstage(
            offstage: _currentIndex != 0,
            child: const VideosTimelineScreen(),
          ),
          Offstage(
            offstage: _currentIndex != 1,
            child: const DiscoverScreen(),
          ),
          Offstage(
            offstage: _currentIndex != 3,
            child: const InboxScreen(),
          ),
          Offstage(
            offstage: _currentIndex != 4,
            child: const UserProfileScreen(),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: _currentIndex == 0 || isDark ? Colors.black : Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(Sizes.size12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              NavTab(
                icon: FontAwesomeIcons.house,
                selectedIcon: FontAwesomeIcons.house,
                text: 'Home',
                isSelected: _currentIndex == 0,
                onTap: () => _onTap(0),
                selectedIndex: _currentIndex,
              ),
              NavTab(
                icon: FontAwesomeIcons.compass,
                selectedIcon: FontAwesomeIcons.solidCompass,
                text: 'Discover',
                isSelected: _currentIndex == 1,
                onTap: () => _onTap(1),
                selectedIndex: _currentIndex,
              ),
              Gaps.h24,
              GestureDetector(
                onTap: _onPostVideoButtonTap,
                child: PostVideoButton(
                  inverted: _currentIndex != 0,
                ),
              ),
              Gaps.h24,
              NavTab(
                icon: FontAwesomeIcons.message,
                selectedIcon: FontAwesomeIcons.solidMessage,
                text: 'Inbox',
                isSelected: _currentIndex == 3,
                onTap: () => _onTap(3),
                selectedIndex: _currentIndex,
              ),
              NavTab(
                icon: FontAwesomeIcons.user,
                selectedIcon: FontAwesomeIcons.solidUser,
                text: 'Profile',
                isSelected: _currentIndex == 4,
                onTap: () => _onTap(4),
                selectedIndex: _currentIndex,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
