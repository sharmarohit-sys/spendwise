import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:spendwise/core/constants/shared_preference.dart';
import 'package:spendwise/core/di/dependencies.dart';
import 'package:spendwise/routes.dart';
import 'package:spendwise/core/utils/local_storage.dart';

part 'splash_screen_controller.g.dart';

@riverpod
class SplashScreenController extends _$SplashScreenController {
  final localStorage = getIt<LocalStorage>();

  @override
  FutureOr<void> build() {}

  void checkLoginStatus(BuildContext context) {
    Future.delayed(const Duration(seconds: 2), () {
      final isLoggedIn =
          localStorage.readData(key: SharedPreference.isLoginKey) == 'True';
      if (isLoggedIn) {
        if (context.mounted) {
          Navigator.pushReplacementNamed(context, Routes.homeScreen);
        }
      } else {
        if (context.mounted) {
          Navigator.pushReplacementNamed(context, Routes.loginScreen);
        }
      }
    });
  }
}
