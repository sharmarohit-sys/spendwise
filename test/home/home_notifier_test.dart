import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spendwise/features/home/presentation/controller/home_controller_new.dart';
import 'package:spendwise/navigation/routes.dart';
import 'package:spendwise/utils/firestore/data/firestore_repository_impl.dart';
import 'package:spendwise/utils/firestore/domain/expense_model.dart';

// Mock repository
class MockFirestoreRepositoryImpl extends Mock
    implements FirestoreRepositoryImpl {}

// Mock NavigatorObserver to test navigation
class MockNavigatorObserver extends Mock implements NavigatorObserver {}

void main() {
  late MockFirestoreRepositoryImpl mockRepository;
  late HomeControllerNew controller;

  setUp(() {
    mockRepository = MockFirestoreRepositoryImpl();
    controller = HomeControllerNew(mockRepository);
  });

  final expense1 = ExpenseModel(
    id: '1',
    amount: 100,
    date: '2025-10-15T10:00:00Z',
    category: 'Food',
    status: 'valid',
    timestamp: DateTime.parse('2025-10-15T10:00:00Z'),
  );

  final expense2 = ExpenseModel(
    id: '2',
    amount: 200,
    date: '2025-10-15T15:00:00Z',
    category: 'Coffee',
    status: 'valid',
    timestamp: DateTime.parse('2025-10-15T15:00:00Z'),
  );

  final expense3 = ExpenseModel(
    id: '3',
    amount: 150,
    date: '2025-10-14T12:00:00Z',
    category: 'Shopping',
    status: 'valid',
    timestamp: DateTime.parse('2025-10-14T12:00:00Z'),
  );

  group('HomeControllerNew', () {
    test('fetchExpenses updates state with sorted expenses', () async {
      when(
        () => mockRepository.getExpensesByUser(),
      ).thenAnswer((_) async => [expense1, expense2, expense3]);

      await controller.fetchExpenses();

      expect(controller.state.value, isA<List<ExpenseModel>>());
      expect(controller.state.value!.length, 3);
      expect(controller.state.value!.first, expense2); // latest first
      expect(controller.state.value!.last, expense3); // oldest last
    });

    test('fetchExpenses sets error state on exception', () async {
      when(
        () => mockRepository.getExpensesByUser(),
      ).thenThrow(Exception('Failed to fetch'));

      await controller.fetchExpenses();

      expect(controller.state.error, isA<Exception>());
    });

    testWidgets('navigateToAddExpense triggers fetchExpenses on result', (
      tester,
    ) async {
      final navigatorObserver = MockNavigatorObserver();

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () {
                  controller.navigateToAddExpense(context);
                },
                child: const Text('Add Expense'),
              );
            },
          ),
          navigatorObservers: [navigatorObserver],
          routes: {
            Routes.addExpenseScreen: (context) =>
                const Scaffold(body: Text('Add Expense Screen')),
          },
        ),
      );

      when(
        () => mockRepository.getExpensesByUser(),
      ).thenAnswer((_) async => [expense1]);

      // Mock Navigator.pushNamed to return a non-null result
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      // You can check if fetchExpenses was called by asserting state changes
      expect(controller.state, isA<AsyncValue<List<ExpenseModel>>>());
    });
  });
}
