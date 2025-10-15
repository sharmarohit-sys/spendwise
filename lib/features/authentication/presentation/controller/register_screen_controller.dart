import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:spendwise/dependencies.dart';
import 'package:spendwise/utils/firestore/data/firestore_repository_impl.dart';
import 'package:spendwise/features/authentication/data/authentication_repository.dart';
import 'package:spendwise/navigation/routes.dart';

part 'register_screen_controller.g.dart';

@riverpod
class RegisterScreenController extends _$RegisterScreenController {
  final authenticationRepository = getIt<AuthenticationRepository>();
  final expenseRepository = getIt<FirestoreRepositoryImpl>();

  @override
  FutureOr<void> build() {}

  Future<bool> registerUser({
    required String emailId,
    required String password,
    required String userName,
  }) async {
    state = const AsyncValue.loading();
    try {
      final isRegistered = await authenticationRepository.registerUser(
        emailId: emailId,
        password: password,
        userName: userName,
      );

      return isRegistered.isSuccess;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
    return false;
  }

  void navigateToLoginScreen(BuildContext context) {
    Navigator.pushNamed(context, Routes.loginScreen);
  }
}
