// ignore_for_file: avoid_print

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../videos/view_models/playback_config_view_model.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          SwitchListTile.adaptive(
            value: ref.watch(playbackConfigProvider).muted,
            onChanged: ref.read(playbackConfigProvider.notifier).setMuted,
            title: const Text('Auto Mute'),
            subtitle: const Text('Videos will be muted by default'),
          ),
          SwitchListTile.adaptive(
            value: ref.watch(playbackConfigProvider).autoplay,
            onChanged: ref.read(playbackConfigProvider.notifier).setAutoplay,
            title: const Text('Auto Play'),
            subtitle: const Text('Videos will be played by default'),
          ),
          SwitchListTile.adaptive(
            value: false,
            onChanged: (value) => {},
            title: const Text('Enable notifications'),
          ),
          ListTile(
            onTap: () async {
              await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(1980),
                lastDate: DateTime(2030),
              );

              await showTimePicker(
                context: context,
                initialTime: TimeOfDay.now(),
              );

              await showDateRangePicker(
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
