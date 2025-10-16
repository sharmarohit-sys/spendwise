import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:spendwise/dependencies.dart';
import 'package:spendwise/features/authentication/data/authentication_repository.dart';
import 'package:spendwise/navigation/routes.dart';

class LoginScreenController extends StateNotifier<AsyncValue<void>> {
  LoginScreenController(this.authenticationRepository)
    : super(const AsyncValue.data(null));

  final AuthenticationRepository authenticationRepository;

  Future<void> login({
    required String emailId,
    required String password,
    required BuildContext context,
  }) async {
    state = const AsyncValue.loading();
    try {
      final result = await authenticationRepository
          .loginUserWithEmailAndPassword(emailId: emailId, password: password);
      if (result.isSuccess) {
        state = const AsyncValue.data(null);
        if (context.mounted) Navigator.pushNamed(context, Routes.homeScreen);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result.error ?? 'Unable to login')),
        );
        state = AsyncValue.error(
          result.error ?? 'Unable to login',
          StackTrace.current,
        );
      }
    } catch (e, st) {
      // On error, update the state to error
      state = AsyncValue.error(e, st);
    }
  }

  void navigateToRegisterScreen(BuildContext context) {
    Navigator.pushNamed(context, Routes.registerScreen);
  }
}

final loginScreenControllerProvider =
    StateNotifierProvider.autoDispose<LoginScreenController, AsyncValue<void>>((
      ref,
    ) {
      return LoginScreenController(getIt<AuthenticationRepository>());
    });
