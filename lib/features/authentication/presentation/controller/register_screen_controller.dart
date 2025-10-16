import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:spendwise/dependencies.dart';
import 'package:spendwise/features/authentication/data/authentication_repository.dart';
import 'package:spendwise/navigation/routes.dart';

class RegisterScreenController extends StateNotifier<AsyncValue<void>> {
  RegisterScreenController(this.authenticationRepository)
    : super(const AsyncValue.data(null));

  final AuthenticationRepository authenticationRepository;

  Future<bool> registerUser(
    BuildContext context, {
    required String emailId,
    required String password,
    required String userName,
  }) async {
    state = const AsyncValue.loading();
    try {
      final result = await authenticationRepository.registerUser(
        emailId: emailId,
        password: password,
        userName: userName,
      );
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
      state = AsyncValue.error(e, st);
    }
    return false;
  }

  void navigateToLoginScreen(BuildContext context) {
    Navigator.pushReplacementNamed(context, Routes.loginScreen);
  }
}

final registerScreenControllerProvider =
    StateNotifierProvider.autoDispose<
      RegisterScreenController,
      AsyncValue<void>
    >((ref) {
      return RegisterScreenController(getIt<AuthenticationRepository>());
    });
