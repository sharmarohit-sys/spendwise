import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spendwise/components/spend_wise_button.dart';
import 'package:spendwise/components/spend_wise_text_field.dart';
import 'package:spendwise/constants/dimensions.dart';
import 'package:spendwise/constants/string_constants.dart';
import 'package:spendwise/features/authentication/presentation/controller/login_screen_controller.dart';
import 'package:spendwise/features/authentication/presentation/widgets/auth_rich_text.dart';
import 'package:spendwise/widget/async_value_widget.dart';

class LoginScreen extends ConsumerWidget {
  LoginScreen({super.key});

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loginController = ref.watch(loginScreenControllerProvider);
    final formKey = GlobalKey<FormState>();
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
                const Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: Dimensions.padding * 5,
                  ),
                  child: Text(StringConstants.loginScreen),
                ),
                SpendWiseTextField(
                  controller: emailController,
                  hintText: StringConstants.emailHintText,
                  prefixIcon: const Icon(Icons.email),
                  validator: (value) {
                    return value!.isNotEmpty ? null : 'Enter email';
                  },
                ),
                const SizedBox(height: Dimensions.padding * 3),
                SpendWiseTextField(
                  controller: passwordController,
                  hintText: StringConstants.password,
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
                    title: StringConstants.login,
                    isLoading: loginController.isLoading,
                    onTap: () {
                      if (formKey.currentState!.validate()) {
                        ref
                            .read(loginScreenControllerProvider.notifier)
                            .login(
                              emailId: emailController.text,
                              password: passwordController.text,
                              context: context,
                            );
                      }
                    },
                  ),
                ),

                AuthRichText(
                  isLogin: true,
                  onTap: () => ref
                      .read(loginScreenControllerProvider.notifier)
                      .navigateToRegisterScreen(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
