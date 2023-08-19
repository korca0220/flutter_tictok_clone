import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../constants/gaps.dart';
import '../../constants/sizes.dart';

class ChatDetailScreen extends StatefulWidget {
  static const String routeName = 'chatDetail';
  static const String routeURL = ':chatId';
  const ChatDetailScreen({
    super.key,
    required this.chatId,
  });

  final String chatId;

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  @override
  Widget build(BuildContext context) {
    print(widget.chatId);
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: ListTile(
          contentPadding: EdgeInsets.zero,
          horizontalTitleGap: Sizes.size8,
          leading: const CircleAvatar(
            foregroundImage: NetworkImage(
              'https://avatars.githubusercontent.com/u/25660275?v=4',
            ),
            radius: Sizes.size24,
            child: Text('Ju'),
          ),
          title: Text(
            'Ju(${widget.chatId})',
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          subtitle: const Text('Active now'),
          trailing: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              FaIcon(
                FontAwesomeIcons.flag,
                color: Colors.black,
                size: Sizes.size20,
              ),
              Gaps.h32,
              FaIcon(
                FontAwesomeIcons.ellipsis,
                color: Colors.black,
                size: Sizes.size20,
              ),
              Gaps.h32,
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          ListView.separated(
            padding: const EdgeInsets.symmetric(
              vertical: Sizes.size20,
              horizontal: Sizes.size14,
            ),
            itemBuilder: (context, index) {
              final isMine = index % 2 == 0;
              return Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment:
                    isMine ? MainAxisAlignment.end : MainAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(Sizes.size14),
                    decoration: BoxDecoration(
                      color:
                          isMine ? Colors.blue : Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(Sizes.size20),
                        topRight: const Radius.circular(Sizes.size20),
                        bottomLeft: Radius.circular(
                          isMine ? Sizes.size20 : Sizes.size5,
                        ),
                        bottomRight: Radius.circular(
                          isMine ? Sizes.size5 : Sizes.size20,
                        ),
                      ),
                    ),
                    child: const Text(
                      'this is a message',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: Sizes.size16,
                      ),
                    ),
                  ),
                ],
              );
            },
            separatorBuilder: (context, index) => Gaps.v10,
            itemCount: 10,
          ),
          Positioned(
            bottom: 0,
            width: MediaQuery.of(context).size.width,
            child: BottomAppBar(
              color: Colors.grey.shade50,
              padding: const EdgeInsets.symmetric(
                horizontal: Sizes.size20,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      minLines: null,
                      maxLines: null,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: 'Send a message...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(Sizes.size12),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: Sizes.size20,
                        ),
                        suffixIcon: const Padding(
                          padding: EdgeInsets.only(
                            right: Sizes.size14,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              FaIcon(
                                FontAwesomeIcons.faceSmile,
                                color: Colors.black,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  CircleAvatar(
                    backgroundColor: Colors.grey.shade300,
                    child: const FaIcon(
                      FontAwesomeIcons.paperPlane,
                      color: Colors.white,
                      size: Sizes.size20,
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
