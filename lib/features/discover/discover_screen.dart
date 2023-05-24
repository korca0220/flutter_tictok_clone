import 'package:flutter/cupertino.dart';
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

class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({super.key});

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen>
    with SingleTickerProviderStateMixin {
  final _textEditingController = TextEditingController();
  late TabController _tabController;

  void _onSearchChanged(String value) {}

  void _onSearchSubmitted(String value) {}

  void _onTapClear() {
    _textEditingController.clear();
  }

  @override
  void initState() {
    super.initState();

    _tabController = TabController(
      length: tabs.length,
      vsync: this,
    );
    _tabController.addListener(_tabEvent);
    _textEditingController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    _tabController.removeListener(_tabEvent);
    _tabController.dispose();
    super.dispose();
  }

  _tabEvent() {
    if (_tabController.indexIsChanging ||
        _tabController.animation!.value.round() == _tabController.index) {
      FocusScope.of(context).unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          elevation: 1,
          title: Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: Sizes.size44,
                  child: TextField(
                    controller: _textEditingController,
                    onChanged: _onSearchChanged,
                    onSubmitted: _onSearchSubmitted,
                    cursorColor: Theme.of(context).primaryColor,
                    textAlignVertical: TextAlignVertical.center,
                    maxLines: 1,
                    style: const TextStyle(
                      fontSize: Sizes.size16,
                    ),
                    decoration: InputDecoration(
                      prefixIcon: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: Sizes.size10),
                        child: FaIcon(
                          FontAwesomeIcons.magnifyingGlass,
                          color: Colors.grey.shade700,
                          size: Sizes.size16,
                        ),
                      ),
                      prefixIconConstraints:
                          const BoxConstraints(minWidth: 0, minHeight: 0),
                      suffixIcon: Padding(
                        padding: const EdgeInsets.only(
                          right: Sizes.size10,
                        ),
                        child: _textEditingController.text.isNotEmpty
                            ? GestureDetector(
                                onTap: _onTapClear,
                                child: FaIcon(
                                  FontAwesomeIcons.solidCircleXmark,
                                  color: Colors.grey.shade400,
                                  size: Sizes.size20,
                                ),
                              )
                            : null,
                      ),
                      suffixIconConstraints:
                          const BoxConstraints(minWidth: 0, minHeight: 0),
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(Sizes.size12),
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade200,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ),
              ),
              Gaps.h10,
              const FaIcon(
                FontAwesomeIcons.sliders,
                size: Sizes.size20,
              )
            ],
          ),
          centerTitle: true,
          bottom: TabBar(
            controller: _tabController,
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
          controller: _tabController,
          children: [
            GridView.builder(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
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
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(Sizes.size4),
                      ),
                      child: AspectRatio(
                        aspectRatio: 9 / 16,
                        child: FadeInImage.assetNetwork(
                          placeholder: 'assets/images/placeholder.jpeg',
                          placeholderFit: BoxFit.cover,
                          image:
                              "https://images.pexels.com/photos/674010/pexels-photo-674010.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500",
                          fit: BoxFit.cover,
                        ),
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
