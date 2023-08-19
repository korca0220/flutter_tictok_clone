// ignore_for_file: avoid_print

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../common/widgets/video_config/video_config.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notifications = false;

  _onNotificationsChanged(bool? newValue) {
    if (newValue != null) {
      setState(() {
        _notifications = !_notifications;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          SwitchListTile.adaptive(
            value: _notifications,
            onChanged: _onNotificationsChanged,
            title: const Text('Enable notifications'),
          ),
          AnimatedBuilder(
            animation: videoConfig,
            builder: (context, child) {
              return SwitchListTile.adaptive(
                value: videoConfig.autoMute,
                onChanged: (value) {
                  videoConfig.toggleAutoMute();
                },
                title: const Text('Auto Mute'),
                subtitle: const Text('Videos will be muted by default'),
              );
            },
          ),
          ListTile(
            onTap: () async {
              final date = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(1980),
                lastDate: DateTime(2030),
              );

              print(date);

              if (context.mounted) {
                final time = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );
                print(time);
              }

              if (context.mounted) {
                final booking = await showDateRangePicker(
                  context: context,
                  firstDate: DateTime(1980),
                  lastDate: DateTime(2000),
                  builder: (context, child) {
                    return Theme(
                      data: ThemeData(
                        appBarTheme: const AppBarTheme(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.black,
                        ),
                      ),
                      child: child!,
                    );
                  },
                );
                print(booking);
              }
            },
            title: const Text('What is your birthday?'),
          ),
          ListTile(
            title: const Text('Log out (iOS)'),
            textColor: Colors.red,
            onTap: () {
              showCupertinoDialog(
                context: context,
                builder: (context) => CupertinoAlertDialog(
                  title: const Text('are your sure?'),
                  content: const Text('Plx dont go'),
                  actions: [
                    CupertinoDialogAction(
                      child: const Text('No'),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    CupertinoDialogAction(
                      isDestructiveAction: true,
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Yes'),
                    ),
                  ],
                ),
              );
            },
          ),
          ListTile(
            title: const Text('Log out (iOS / Bottom)'),
            textColor: Colors.red,
            onTap: () {
              showCupertinoModalPopup(
                context: context,
                builder: (context) => CupertinoActionSheet(
                  title: const Text('are your sure?'),
                  message: const Text('Please doooooont log out'),
                  actions: [
                    CupertinoActionSheetAction(
                      isDefaultAction: true,
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Not log out'),
                    ),
                    CupertinoActionSheetAction(
                      isDestructiveAction: true,
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Yes plz'),
                    ),
                  ],
                ),
              );
            },
          ),
          const AboutListTile(),
        ],
      ),
    );
  }
}
