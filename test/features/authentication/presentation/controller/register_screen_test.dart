import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spendwise/features/authentication/presentation/register_screen.dart';
import 'package:spendwise/core/constants/string_constants.dart';

void main() {
  testWidgets('RegisterScreen displays all required fields and button', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(child: MaterialApp(home: RegisterScreen())),
    );

    // Check for title
    expect(find.text(StringConstants.registerScreen), findsOneWidget);

    // Check for username, email, password fields
    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is TextField &&
            widget.decoration?.hintText == StringConstants.userNameHintText,
      ),
      findsOneWidget,
    );

    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is TextField &&
            widget.decoration?.hintText == StringConstants.emailHintText,
      ),
      findsOneWidget,
    );

    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is TextField &&
            widget.decoration?.hintText == StringConstants.password,
      ),
      findsOneWidget,
    );

    // Check for register button
    expect(find.text(StringConstants.register), findsOneWidget);

    // Check for AuthRichText
    expect(find.byType(GestureDetector), findsWidgets);
  });
}
