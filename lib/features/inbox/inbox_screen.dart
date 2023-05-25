import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tictok_clone/constants/sizes.dart';
import 'package:tictok_clone/features/inbox/activity_screen.dart';

class InboxScreen extends StatelessWidget {
  const InboxScreen({super.key});

  void _onActivityTap(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => const ActivityScreen(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inbox'),
        centerTitle: true,
        elevation: 1,
        actions: [
          IconButton(
            onPressed: _onDmPressed,
            icon: const FaIcon(FontAwesomeIcons.paperPlane),
          )
        ],
      ),
      body: ListView(
        children: [
          ListTile(
            onTap: () => _onActivityTap(context),
            title: const Text(
              'Activity',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: Sizes.size18,
              ),
            ),
            trailing: const FaIcon(
              FontAwesomeIcons.chevronRight,
              size: Sizes.size16,
              color: Colors.black,
            ),
          ),
          Container(
            height: Sizes.size1,
            color: Colors.grey.shade200,
          ),
          ListTile(
            leading: Container(
              width: Sizes.size40,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blue,
              ),
              child: const Center(
                child: FaIcon(
                  FontAwesomeIcons.users,
                  size: Sizes.size18,
                  color: Colors.white,
                ),
              ),
            ),
            title: const Text(
              'New followers',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: Sizes.size18,
              ),
            ),
            subtitle: const Text('Messages from followers will appear here'),
            trailing: const FaIcon(
              FontAwesomeIcons.chevronRight,
              size: Sizes.size16,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  void _onDmPressed() {}
}
