import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

import '../../constants/gaps.dart';
import '../../constants/sizes.dart';
import '../../utils.dart';
import 'login_form_screen.dart';
import 'view_models/social_auth_view_model.dart';
import 'widgets/auth_button.dart';

void onLoginTap(BuildContext context) {
  context.pop();
}

_onEmailLoginTap(BuildContext context) {
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (context) => const LoginFormScreen(),
    ),
  );
}

class LoginScreen extends ConsumerWidget {
  static const routeURL = '/login';
  static const routeName = 'login';
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: Sizes.size40,
          ),
          child: Column(
            children: [
              Gaps.v80,
              const Text(
                'Login for TikTok',
                style: TextStyle(
                  fontSize: Sizes.size24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Gaps.v20,
              const Opacity(
                opacity: 0.7,
                child: Text(
                  'Create a profile, follow other accounts, make your own videos, and more.',
                  style: TextStyle(
                    fontSize: Sizes.size16,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Gaps.v40,
              AuthButton(
                icon: const FaIcon(FontAwesomeIcons.user),
                text: 'Use Email & Password',
                onTap: () => _onEmailLoginTap(context),
              ),
              Gaps.v16,
              AuthButton(
                icon: const FaIcon(FontAwesomeIcons.github),
                text: 'Continue with GitHub',
                onTap: () {
                  ref.read(socialAuthProvider.notifier).githubSignIn(context);
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 1,
        color: isDarkMode(context) ? null : Colors.grey.shade50,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: Sizes.size32),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Don\'t have an account?'),
              Gaps.h5,
              GestureDetector(
                onTap: () {
                  onLoginTap(context);
                },
                child: Text(
                  'Sign up',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
