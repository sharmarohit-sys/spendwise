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
import 'package:spendwise/features/authentication/presentation/notifier/register_screen_controller.dart';
import 'package:spendwise/features/authentication/presentation/widgets/auth_rich_text.dart';
import 'package:spendwise/routes.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final userNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  ProviderSubscription<AsyncValue<dynamic>>? registerControllerSubscription;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      registerControllerSubscription = ref.listenManual<AsyncValue>(
        registerScreenControllerProvider,
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

  void _navigateToLoginScreen(BuildContext context) {
    Navigator.pushReplacementNamed(context, Routes.loginScreen);
  }

  @override
  void dispose() {
    userNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    registerControllerSubscription?.close();
    log('Register Screen registerControllerSubscription disposed');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final registerController = ref.watch(registerScreenControllerProvider);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        minimum: const EdgeInsets.symmetric(
          horizontal: Dimensions.padding * 3,
          vertical: Dimensions.padding * 2,
        ),
        child: IgnorePointer(
          ignoring: registerController.isLoading,
          child: Form(
            key: formKey,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: Dimensions.padding * 5,
                  ),
                  child: Text(StringConstants.registerScreen.tr()),
                ),
                SpendWiseTextField(
                  controller: userNameController,
                  hintText: StringConstants.userNameHintText.tr(),
                  prefixIcon: const Icon(Icons.person),
                  validator: (value) {
                    return value!.isNotEmpty ? null : 'Enter user name';
                  },
                ),
                const SizedBox(height: Dimensions.padding * 3),
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
                    title: StringConstants.register.tr(),
                    onTap: () {
                      if (formKey.currentState!.validate()) {
                        ref
                            .read(registerScreenControllerProvider.notifier)
                            .registerUser(
                              emailId: emailController.text,
                              password: passwordController.text,
                              userName: userNameController.text,
                            );
                      }
                    },
                  ),
                ),

                AuthRichText(
                  isLogin: false,
                  onTap: () => _navigateToLoginScreen(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
