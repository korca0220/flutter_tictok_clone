import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'common/widgets/main_navigation/main_navigation.dart';
import 'features/authentication/login_screen.dart';
import 'features/authentication/repos/authentication_repo.dart';
import 'features/authentication/sign_up_screen.dart';
import 'features/inbox/activity_screen.dart';
import 'features/inbox/chat_detail_screen.dart';
import 'features/inbox/chats_screen.dart';
import 'features/onboading/interests_screen.dart';
import 'features/videos/views/video_recording_screen.dart';

final routerProvider = Provider(
  (ref) {
    // ref.watch(authState);
    return GoRouter(
      initialLocation: '/home',
      redirect: (context, state) {
        final isLoggedIn = ref.read(authRepo).isLoggedIn;
        if (!isLoggedIn) {
          if (state.matchedLocation != SignUpScreen.routeURL &&
              state.matchedLocation != LoginScreen.routeURL) {
            return SignUpScreen.routeURL;
          }
        }
        return null;
      },
      routes: [
        GoRoute(
          name: SignUpScreen.routeName,
          path: SignUpScreen.routeURL,
          builder: (context, state) => const SignUpScreen(),
        ),
        GoRoute(
          name: LoginScreen.routeName,
          path: LoginScreen.routeURL,
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          name: InterestsScreen.routeName,
          path: InterestsScreen.routeURL,
          builder: (context, state) => const InterestsScreen(),
        ),
        GoRoute(
          path: '/:tab(home|discover|inbox|profile)',
          name: MainNavigation.routeName,
          builder: (context, state) {
            final tab = state.pathParameters['tab']!;
            return MainNavigation(tab: tab);
          },
        ),
        GoRoute(
          name: ActivityScreen.routeName,
          path: ActivityScreen.routeURL,
          builder: (context, state) => const ActivityScreen(),
        ),
        GoRoute(
          name: ChatsScreen.routeName,
          path: ChatsScreen.routeURL,
          builder: (context, state) => const ChatsScreen(),
          routes: <GoRoute>[
            GoRoute(
              name: ChatDetailScreen.routeName,
              path: ChatDetailScreen.routeURL,
              builder: (context, state) {
                final chatId = state.pathParameters['chatId']!;
                return ChatDetailScreen(chatId: chatId);
              },
            ),
          ],
        ),
        GoRoute(
          name: VideoRecordingScreen.routeName,
          path: VideoRecordingScreen.routeURL,
          pageBuilder: (context, state) {
            return CustomTransitionPage(
              transitionDuration: const Duration(milliseconds: 200),
              child: const VideoRecordingScreen(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                final position = Tween(
                  begin: const Offset(0, 1),
                  end: Offset.zero,
                ).animate(animation);
                return SlideTransition(
                  position: position,
                  child: child,
                );
              },
            );
          },
        ),
      ],
    );
  },
);
