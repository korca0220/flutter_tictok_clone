// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../authentication/repos/authentication_repo.dart';
import '../inbox/chats_screen.dart';
import '../videos/views/video_recording_screen.dart';

final notificationsProvider = AsyncNotifierProviderFamily(
  () => NotificationsProvider(),
);

class NotificationsProvider extends FamilyAsyncNotifier<void, BuildContext> {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  Future<void> initListeners(BuildContext context) async {
    final permission = await _messaging.requestPermission();

    if (permission.authorizationStatus == AuthorizationStatus.denied) {
      return;
    }

    // Foreground
    FirebaseMessaging.onMessage.listen((event) {
      print('I just got a message and im in the foreground');
      print(event.notification?.title);
    });

    // Background
    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      context.pushNamed(ChatsScreen.routeName);
    });

    // Terminated
    final notification = await _messaging.getInitialMessage();

    if (notification != null) {
      context.pushNamed(VideoRecordingScreen.routeName);
    }
  }

  @override
  FutureOr<void> build(BuildContext context) async {
    final token = await _messaging.getToken();

    if (token == null) return;
    await updateToken(token);
    await initListeners(context);

    _messaging.onTokenRefresh.listen((newToken) async {
      await updateToken(newToken);
    });
  }

  Future<void> updateToken(String token) async {
    final user = ref.read(authRepo).user;
    _db.collection('users').doc(user!.uid).update({
      'token': token,
    });
  }
}
