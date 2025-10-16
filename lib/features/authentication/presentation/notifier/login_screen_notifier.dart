import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:spendwise/dependencies.dart';
import 'package:spendwise/features/authentication/data/repositories/authentication_repository.dart';
import 'package:spendwise/features/authentication/domain/usecases/login_user_usecase.dart';
import 'package:spendwise/navigation/routes.dart';

class LoginScreenNotifier extends StateNotifier<AsyncValue<void>> {
  LoginScreenNotifier(this._loginUserUseCase)
    : super(const AsyncValue.data(null));

  final LoginUserUseCase _loginUserUseCase;

  Future<void> login({
    required String emailId,
    required String password,
    required BuildContext context,
  }) async {
    state = const AsyncValue.loading();
    try {
      final result = await _loginUserUseCase(
        emailId: emailId,
        password: password,
      );

      if (result.isSuccess) {
        state = const AsyncValue.data(null);
        if (context.mounted) Navigator.pushNamed(context, Routes.homeScreen);
      } else {
        state = AsyncValue.error(
          result.error ?? 'Unable to login',
          StackTrace.current,
        );
      }
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  void navigateToRegisterScreen(BuildContext context) {
    Navigator.pushNamed(context, Routes.registerScreen);
  }
}

final loginScreenControllerProvider =
    StateNotifierProvider.autoDispose<LoginScreenNotifier, AsyncValue<void>>((
      ref,
    ) {
      return LoginScreenNotifier(ref.read(loginuseCaseProvider));
    });
