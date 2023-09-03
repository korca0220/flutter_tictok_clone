import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../view_models/user_avatar_view_model.dart';

class UserAvatar extends ConsumerWidget {
  const UserAvatar({
    super.key,
    required this.uid,
    required this.name,
    required this.hasAvatar,
  });
  final String uid;
  final String name;
  final bool hasAvatar;

  Future<void> _onAvatarTap(BuildContext context, WidgetRef ref) async {
    final xFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 40,
      maxHeight: 150,
      maxWidth: 150,
    );
    if (xFile != null) {
      final file = File(xFile.path);
      ref.read(userAvatarProvider.notifier).uploadAvatar(context, file);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(userAvatarProvider).when(
          error: (error, stackTrace) => const Center(
            child: Text('Error'),
          ),
          loading: () => Container(
            width: 100,
            height: 100,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
            ),
            child: const CircularProgressIndicator(),
          ),
          data: (data) => GestureDetector(
            onTap: () => _onAvatarTap(context, ref),
            child: CircleAvatar(
              radius: 50,
              foregroundImage: hasAvatar
                  ? NetworkImage(
                      'https://firebasestorage.googleapis.com/v0/b/tik-tok-junewoo.appspot.com/o/avatars%2F$uid?alt=media&token=b15373e4-a8b7-4a0d-8f8a-0e2d907cbd63',
                    )
                  : null,
              child: Text(name),
            ),
          ),
        );
  }
}
