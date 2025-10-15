import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:spendwise/constants/dimensions.dart';
import 'package:spendwise/constants/string_constants.dart';

class AuthRichText extends StatelessWidget {
  const AuthRichText({super.key, this.onTap, this.isLogin = true});
  final Function()? onTap;
  final bool isLogin;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(top: Dimensions.padding * 2),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: isLogin
                  ? StringConstants.dontHaveAccountText
                  : StringConstants.alreadyHaveAccountText,
              style: TextStyle(color: colorScheme.onSurface),
            ),
            TextSpan(
              text: isLogin ? StringConstants.signUp : StringConstants.login,
              style: TextStyle(color: colorScheme.primary),
              recognizer: TapGestureRecognizer()..onTap = onTap,
            ),
          ],
        ),
      ),
    );
  }
}
