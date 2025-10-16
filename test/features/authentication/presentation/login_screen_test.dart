import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spendwise/features/authentication/presentation/login_screen.dart';
import 'package:spendwise/constants/string_constants.dart';
import 'package:spendwise/features/authentication/presentation/widgets/auth_rich_text.dart';

void main() {
  testWidgets('LoginScreen displays all required widgets', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(child: MaterialApp(home: LoginScreen())),
    );

    // Check for title text
    expect(find.text(StringConstants.loginScreen), findsOneWidget);

    // Check for email and password fields
    expect(find.byType(TextField), findsNWidgets(2));
    expect(find.widgetWithIcon(TextField, Icons.email), findsOneWidget);
    expect(find.widgetWithIcon(TextField, Icons.lock), findsOneWidget);

    // Check for login button
    expect(find.text(StringConstants.login), findsOneWidget);

    // Check for AuthRichText widget
    expect(find.byType(AuthRichText), findsOneWidget);
  });
}
