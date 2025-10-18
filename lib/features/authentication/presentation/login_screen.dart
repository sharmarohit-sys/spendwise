import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spendwise/core/utils/full_screen_loader.dart';
import 'package:spendwise/core/utils/spendwise_toast.dart';
import 'package:spendwise/core/widgets/spend_wise_button.dart';
import 'package:spendwise/core/widgets/spend_wise_text_field.dart';
import 'package:spendwise/core/constants/dimensions.dart';
import 'package:spendwise/core/constants/string_constants.dart';
import 'package:spendwise/features/authentication/presentation/notifier/login_screen_notifier.dart';
import 'package:spendwise/features/authentication/presentation/widgets/auth_rich_text.dart';
import 'package:spendwise/routes.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  ProviderSubscription<AsyncValue<dynamic>>? loginControllerSubscription;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loginControllerSubscription = ref.listenManual<AsyncValue>(
        loginScreenControllerProvider,
        (prev, next) {
          next.when(
            data: (_) {
              FullScreenLoader.hide(context);
              if (context.mounted) {
                Navigator.pushReplacementNamed(context, Routes.homeScreen);
              }
            },
            error: (error, _) {
              FullScreenLoader.hide(context);
              SpendWiseToast.error(error.toString());
            },
            loading: () {
              FullScreenLoader.show(context);
            },
          );
        },
      );
    });
  }

  void _navigateToRegisterScreen(BuildContext context) =>
      Navigator.pushNamed(context, Routes.registerScreen);

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    loginControllerSubscription?.close();
    log('Login Screen loginControllerSubscription disposed');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loginController = ref.watch(loginScreenControllerProvider);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        minimum: const EdgeInsets.symmetric(
          horizontal: Dimensions.padding * 3,
          vertical: Dimensions.padding * 2,
        ),
        child: IgnorePointer(
          ignoring: loginController.isLoading,
          child: Form(
            key: formKey,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: Dimensions.padding * 5,
                  ),
                  child: Text(StringConstants.loginScreen.tr()),
                ),
                SpendWiseTextField(
                  controller: emailController,
                  hintText: StringConstants.emailHintText.tr(),
                  prefixIcon: const Icon(Icons.email),
                  validator: (value) {
                    return value!.isNotEmpty ? null : 'Enter email';
                  },
                ),
                const SizedBox(height: Dimensions.padding * 3),
                SpendWiseTextField(
                  controller: passwordController,
                  hintText: StringConstants.password.tr(),
                  prefixIcon: const Icon(Icons.lock),
                  validator: (value) {
                    return value!.isNotEmpty ? null : 'Enter password';
                  },
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: Dimensions.padding * 5,
                  ),
                  child: SpendWiseButton(
                    title: StringConstants.login.tr(),

                    onTap: () {
                      if (formKey.currentState!.validate()) {
                        ref
                            .read(loginScreenControllerProvider.notifier)
                            .login(
                              emailId: emailController.text,
                              password: passwordController.text,
                            );
                      }
                    },
                  ),
                ),

                AuthRichText(
                  isLogin: true,
                  onTap: () => _navigateToRegisterScreen(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
