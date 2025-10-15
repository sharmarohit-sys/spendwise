import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:spendwise/dependencies.dart';
import 'package:spendwise/features/authentication/data/authentication_repository.dart';
import 'package:spendwise/navigation/routes.dart';

part 'login_screen_controller.g.dart';

@riverpod
class LoginScreenController extends _$LoginScreenController {
  final authenticationRepository = getIt<AuthenticationRepository>();

  @override
  FutureOr<void> build() {}

  Future<void> loginUserWithEmailAndPassword({
    required String emailId,
    required String password,
    required BuildContext context,
  }) async {
    state = const AsyncValue.loading();
    try {
      await authenticationRepository.loginUserWithEmailAndPassword(
        emailId: emailId,
        password: password,
      );
      if (context.mounted) Navigator.pushNamed(context, Routes.homeScreen);
    } catch (e, st) {
      // On error, update the state to error
      state = AsyncValue.error(e, st);
    }
  }

  void navigateToRegisterScreen(BuildContext context) {
    Navigator.pushNamed(context, Routes.registerScreen);
  }
}
