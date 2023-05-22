import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tictok_clone/constants/gaps.dart';
import 'package:tictok_clone/constants/sizes.dart';

final tabs = [
  "Top",
  "Users",
  "Videos",
  "Sounds",
  "LIVE",
  "Shopping",
  "Brands",
];

class DiscoverScreen extends StatelessWidget {
  const DiscoverScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        appBar: AppBar(
          elevation: 1,
          title: const Text('Discover'),
          centerTitle: true,
          bottom: TabBar(
            splashFactory: NoSplash.splashFactory,
            padding: const EdgeInsets.symmetric(horizontal: Sizes.size16),
            isScrollable: true,
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey.shade500,
            indicatorColor: Colors.black,
            labelStyle: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: Sizes.size16,
            ),
            tabs: [
              for (var tab in tabs)
                Tab(
                  text: tab,
                )
            ],
          ),
        ),
        body: TabBarView(
          children: [
            GridView.builder(
              padding: const EdgeInsets.symmetric(
                horizontal: Sizes.size6,
                vertical: Sizes.size6,
              ),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: Sizes.size10,
                mainAxisSpacing: Sizes.size10,
                childAspectRatio: 9 / 20,
              ),
              itemCount: 10,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    AspectRatio(
                      aspectRatio: 9 / 16,
                      child: FadeInImage.assetNetwork(
                        placeholder: 'assets/images/placeholder.jpeg',
                        placeholderFit: BoxFit.cover,
                        image:
                            "https://images.pexels.com/photos/674010/pexels-photo-674010.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500",
                        fit: BoxFit.cover,
                      ),
                    ),
                    Gaps.v10,
                    const Text(
                      "This is a very long caption for my tiktok that im upload just now currently,",
                      style: TextStyle(
                        fontSize: Sizes.size16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Gaps.v5,
                    DefaultTextStyle(
                      style: TextStyle(
                        color: Colors.grey.shade500,
                        fontWeight: FontWeight.w600,
                      ),
                      child: Row(
                        children: [
                          const CircleAvatar(
                            radius: 12,
                            backgroundImage: NetworkImage(
                                'https://avatars.githubusercontent.com/u/25660275?v=4'),
                          ),
                          Gaps.h4,
                          const Expanded(
                            child: Text(
                              'My avatar is going to be very long',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Gaps.h4,
                          FaIcon(
                            FontAwesomeIcons.heart,
                            size: Sizes.size14,
                            color: Colors.grey.shade500,
                          ),
                          Gaps.h2,
                          Text(
                            '2.5M',
                            style: TextStyle(
                              color: Colors.grey.shade500,
                              fontWeight: FontWeight.w600,
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                );
              },
            ),
            for (var tab in tabs.skip(1)) ...{
              Center(
                child: Text(tab),
              )
            }
          ],
        ),
      ),
    );
  }
}
