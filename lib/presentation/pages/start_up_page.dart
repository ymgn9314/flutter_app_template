import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:page_transition/page_transition.dart';

import '../../../model/use_cases/auth/fetch_logged_in_with_anonymously.dart';
import '../../../model/use_cases/auth/sign_in_with_anonymously.dart';
import '../../../presentation/pages/main/main_page.dart';
import '../../utils/provider.dart';

class StartUpPage extends HookConsumerWidget {
  const StartUpPage({Key? key}) : super(key: key);

  static Future<void> show(BuildContext context) async {
    await Navigator.of(context, rootNavigator: true)
        .pushReplacement<MaterialPageRoute<dynamic>, void>(
      PageTransition(
        type: PageTransitionType.fade,
        child: const StartUpPage(),
        duration: const Duration(milliseconds: 500),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useEffect(() {
      Future(() async {
        final isLoggedIn = ref.read(fetchLoggedInWithAnonymouslyProvider)();
        if (isLoggedIn) {
          ref
              .read(authStateProvider.state)
              .update((state) => AuthState.signInWithAnonymously);
        } else {
          await ref.read(signInWithAnonymouslyProvider)();
        }
        unawaited(MainPage.show(context));
      });
      return null;
    }, const []);
    return const Scaffold(
      body: Center(
        child: CupertinoActivityIndicator(),
      ),
    );
  }
}
