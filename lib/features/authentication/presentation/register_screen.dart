import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spendwise/components/spend_wise_button.dart';
import 'package:spendwise/components/spend_wise_text_field.dart';
import 'package:spendwise/constants/dimensions.dart';
import 'package:spendwise/constants/string_constants.dart';
import 'package:spendwise/features/authentication/presentation/notifier/register_screen_controller.dart';
import 'package:spendwise/features/authentication/presentation/widgets/auth_rich_text.dart';

class RegisterScreen extends ConsumerWidget {
  RegisterScreen({super.key});

  final userNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                const Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: Dimensions.padding * 5,
                  ),
                  child: Text(StringConstants.registerScreen),
                ),
                SpendWiseTextField(
                  controller: userNameController,
                  hintText: StringConstants.userNameHintText,
                  prefixIcon: const Icon(Icons.person),
                  validator: (value) {
                    return value!.isNotEmpty ? null : 'Enter user name';
                  },
                ),
                const SizedBox(height: Dimensions.padding * 3),
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
                    isLoading: registerController.isLoading,
                    title: StringConstants.register,
                    onTap: () {
                      if (formKey.currentState!.validate()) {
                        ref
                            .read(registerScreenControllerProvider.notifier)
                            .registerUser(
                              context,
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
                  onTap: () => ref
                      .read(registerScreenControllerProvider.notifier)
                      .navigateToLoginScreen(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
