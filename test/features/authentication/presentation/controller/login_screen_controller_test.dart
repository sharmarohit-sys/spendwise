import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spendwise/features/authentication/domain/model/result_model.dart';
import 'package:spendwise/features/authentication/domain/usecases/login_user_usecase.dart';
import 'package:spendwise/features/authentication/presentation/notifier/login_screen_notifier.dart';
import 'package:spendwise/routes.dart';

// ✅ Mock use case
class MockLoginUserUseCase extends Mock implements LoginUserUseCase {}

void main() {
  late MockLoginUserUseCase mockLoginUseCase;

  setUpAll(() {
    registerFallbackValue(''); // for any named parameters if needed
  });

  setUp(() {
    mockLoginUseCase = MockLoginUserUseCase();
  });

  testWidgets('login succeeds and navigates to Home', (tester) async {
    // Arrange
    when(
      () => mockLoginUseCase(
        emailId: any(named: 'emailId'),
        password: any(named: 'password'),
      ),
    ).thenAnswer((_) async => Result.success());

    final container = ProviderContainer(
      overrides: [
        loginScreenControllerProvider.overrideWith(
          (ref) => LoginScreenNotifier(mockLoginUseCase),
        ),
      ],
    );

    final controller = container.read(loginScreenControllerProvider.notifier);

    // Act: pump widget
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          routes: {
            Routes.homeScreen: (_) => const Scaffold(body: Text('Home')),
          },
          home: Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () {
                  controller.login(
                    emailId: 'test@example.com',
                    password: 'password123',
                    context: context,
                  );
                },
                child: const Text('Login'),
              );
            },
          ),
        ),
      ),
    );

    await tester.tap(find.text('Login'));
    await tester.pumpAndSettle(); // wait for async and navigation

    // Assert
    expect(find.text('Home'), findsOneWidget);

    final state = container.read(loginScreenControllerProvider);
    expect(state, isA<AsyncData<void>>());
  });

  testWidgets('login fails and sets state to error', (tester) async {
    // Arrange
    final exception = Exception('Login failed');
    when(
      () => mockLoginUseCase(
        emailId: any(named: 'emailId'),
        password: any(named: 'password'),
      ),
    ).thenThrow(exception);

    final container = ProviderContainer(
      overrides: [
        loginScreenControllerProvider.overrideWith(
          (ref) => LoginScreenNotifier(mockLoginUseCase),
        ),
      ],
    );

    final controller = container.read(loginScreenControllerProvider.notifier);

    // Pump a real widget for BuildContext
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          home: Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () {
                  controller.login(
                    emailId: 'fail@example.com',
                    password: 'wrongpassword',
                    context: context,
                  );
                },
                child: const Text('Login'),
              );
            },
          ),
        ),
      ),
    );

    // Act
    await tester.tap(find.text('Login'));
    await tester.pumpAndSettle();

    // Assert
    final state = container.read(loginScreenControllerProvider);
    expect(state.hasError, true);
    expect(state.error.toString(), contains('Login failed'));
  });
}
