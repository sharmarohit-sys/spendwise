import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spendwise/features/authentication/data/authentication_repository.dart';
import 'package:spendwise/features/authentication/domain/result_model.dart';
import 'package:spendwise/features/authentication/presentation/controller/login_screen_controller.dart';
import 'package:spendwise/navigation/routes.dart';

class MockAuthenticationRepository extends Mock
    implements AuthenticationRepository {}

class FakeBuildContext extends Fake implements BuildContext {}

void main() {
  late MockAuthenticationRepository mockAuthRepo;

  setUpAll(() {
    registerFallbackValue(FakeBuildContext());
  });

  setUp(() {
    mockAuthRepo = MockAuthenticationRepository();
  });

  testWidgets('loginUserWithEmailAndPassword succeeds and sets state to data', (
    tester,
  ) async {
    final container = ProviderContainer(
      overrides: [
        loginScreenControllerProvider.overrideWith(
          (ref) => LoginScreenController(mockAuthRepo),
        ),
      ],
    );

    final controller = container.read(loginScreenControllerProvider.notifier);

    when(
      () => mockAuthRepo.loginUserWithEmailAndPassword(
        emailId: any(named: 'emailId'),
        password: any(named: 'password'),
      ),
    ).thenAnswer((_) async => Result.success());

    // Create a real widget to provide BuildContext
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

    // Optionally verify navigation result
    expect(find.text('Home'), findsOneWidget);

    final state = container.read(loginScreenControllerProvider);
    expect(state, isA<AsyncData<void>>());
  });

  test('loginUserWithEmailAndPassword fails and sets state to error', () async {
    final container = ProviderContainer(
      overrides: [
        loginScreenControllerProvider.overrideWith(
          (ref) => LoginScreenController(mockAuthRepo),
        ),
      ],
    );

    final controller = container.read(loginScreenControllerProvider.notifier);

    // Arrange
    final exception = Exception('Login failed');
    when(
      () => mockAuthRepo.loginUserWithEmailAndPassword(
        emailId: any(named: 'emailId'),
        password: any(named: 'password'),
      ),
    ).thenThrow(exception);

    // Act
    await controller.login(
      emailId: 'fail@example.com',
      password: 'wrongpassword',
      context: FakeBuildContext(),
    );

    // Assert
    final state = container.read(loginScreenControllerProvider);
    expect(state.hasError, true);
    expect(state.error, equals(exception));
  });
}
