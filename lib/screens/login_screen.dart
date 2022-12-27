import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_docs_clone/constants/colors.dart';
import 'package:google_docs_clone/constants/fonts.dart';
import 'package:google_docs_clone/repository/auth_repository.dart';
import 'package:google_docs_clone/screens/home_screen.dart';
import 'package:routemaster/routemaster.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  void signInWithGoogle(
    WidgetRef ref,
    BuildContext context,
  ) async {
    final sMessenger = ScaffoldMessenger.of(context);
    final navigator = Routemaster.of(context);
    final errorModel =
        await ref.read(authRepositoryProvider).signInWithGoogle();

    if (errorModel.error == null) {
      ref.read(userProvider.notifier).update((state) => errorModel.data);
      navigator.replace('/');
    } else {
      sMessenger.showSnackBar(
        SnackBar(
          content: Text(errorModel.error!),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Center(
        child: TextButton.icon(
          onPressed: () => signInWithGoogle(ref, context),
          icon: Image.asset(
            "assets/google-logo.png",
            height: 24,
          ),
          label: Text(
            'Sign In With Google',
            style: Fonts.buttonText(context),
          ),
          style: TextButton.styleFrom(
            minimumSize: const Size(250, 50),
            backgroundColor: kWhiteColor,
            padding: const EdgeInsets.all(20),
            side: const BorderSide(width: 1.0),
          ),
        ),
      ),
    );
  }
}
