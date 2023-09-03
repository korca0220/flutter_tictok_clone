import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../view_models/user_avatar_view_model.dart';

class UserAvatar extends ConsumerWidget {
  const UserAvatar({
    super.key,
    required this.name,
    required this.hasAvatar,
  });
  final String name;
  final bool hasAvatar;

  Future<void> _onAvatarTap(WidgetRef ref) async {
    final xFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 40,
      maxHeight: 150,
      maxWidth: 150,
    );
    if (xFile != null) {
      final file = File(xFile.path);
      ref.read(userAvatarProvider.notifier).uploadAvatar(file);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(userAvatarProvider).isLoading;
    return GestureDetector(
      onTap: isLoading ? null : () => _onAvatarTap(ref),
      child: isLoading
          ? Container(
              width: 100,
              height: 100,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
              ),
              child: const CircularProgressIndicator(),
            )
          : CircleAvatar(
              radius: 50,
              foregroundImage: hasAvatar
                  ? const NetworkImage(
                      'https://avatars.githubusercontent.com/u/25660275?v=4',
                    )
                  : null,
              child: Text(name),
            ),
    );
  }
}
