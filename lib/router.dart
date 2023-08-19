import 'package:go_router/go_router.dart';

import 'common/widgets/main_navigation/main_navigation.dart';
import 'features/authentication/login_screen.dart';
import 'features/authentication/sign_up_screen.dart';
import 'features/onboading/interests_screen.dart';

final router = GoRouter(
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
  ],
);
