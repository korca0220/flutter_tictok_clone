import 'package:go_router/go_router.dart';

import 'features/authentication/email_screen.dart';
import 'features/authentication/login_screen.dart';
import 'features/authentication/sign_up_screen.dart';
import 'features/authentication/username_screen.dart';

final router = GoRouter(
  routes: [
    GoRoute(
      path: SignUpScreen.routerName,
      builder: (context, state) => const SignUpScreen(),
    ),
    GoRoute(
      path: LoginScreen.routerName,
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: UsernameScreen.routerName,
      builder: (context, state) => const UsernameScreen(),
    ),
    GoRoute(
      path: EmailScreen.routerName,
      builder: (context, state) => const EmailScreen(),
    ),
  ],
);
