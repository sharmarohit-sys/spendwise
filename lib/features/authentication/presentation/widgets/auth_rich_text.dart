import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:spendwise/core/constants/dimensions.dart';
import 'package:spendwise/core/constants/string_constants.dart';

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
                  ? StringConstants.dontHaveAccountText.tr()
                  : StringConstants.alreadyHaveAccountText.tr(),
              style: TextStyle(color: colorScheme.onSurface),
            ),
            TextSpan(
              text: isLogin
                  ? StringConstants.signUp.tr()
                  : StringConstants.login.tr(),
              style: TextStyle(color: colorScheme.primary),
              recognizer: TapGestureRecognizer()..onTap = onTap,
            ),
          ],
        ),
      ),
    );
  }
}
