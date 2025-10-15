import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spendwise/features/add_expense/presentation/controller/add_new_expense_notifer_new.dart';
import 'package:spendwise/utils/firestore/data/firestore_repository_impl.dart';
import 'package:spendwise/utils/firestore/domain/expense_model.dart';

// Mock repository
class MockFirestoreRepositoryImpl extends Mock
    implements FirestoreRepositoryImpl {}

// Fake BuildContext for non-widget tests
class MockBuildContext extends Mock implements BuildContext {}

void main() {
  late MockFirestoreRepositoryImpl mockRepository;
  late AddNewExpenseNotifier notifier;

  setUp(() {
    mockRepository = MockFirestoreRepositoryImpl();
    notifier = AddNewExpenseNotifier(mockRepository);
  });

  final testExpense = ExpenseModel(
    id: '1',
    amount: 100,
    date: '2025-10-15T10:00:00Z',
    category: 'Food',
    status: 'valid',
    timestamp: DateTime.parse('2025-10-15T10:00:00Z'),
  );

  group('AddNewExpenseNotifier', () {
    testWidgets('addExpense success shows SnackBar and pops', (tester) async {
      when(
        () => mockRepository.addExpense(expense: testExpense),
      ).thenAnswer((_) async => true);

      final key = GlobalKey<NavigatorState>();

      await tester.pumpWidget(
        MaterialApp(
          navigatorKey: key,
          home: Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () =>
                    notifier.addExpense(context, expense: testExpense),
                child: const Text('Save Expense'),
              );
            },
          ),
        ),
      );

      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      // Verify state is reset
      expect(notifier.state.value, null);

      // SnackBar is shown
      expect(find.text('Expense added successfully'), findsOneWidget);
    });

    test('addExpense failure sets error state', () async {
      when(
        () => mockRepository.addExpense(expense: testExpense),
      ).thenThrow(Exception('Failed'));

      // Use a fake context since we don't need UI for state test
      final context = MockBuildContext();

      await notifier.addExpense(context, expense: testExpense);

      expect(notifier.state.error, isA<Exception>());
    });

    testWidgets('editExpense success shows SnackBar and pops', (tester) async {
      when(
        () => mockRepository.editExpense(expenseId: '1', expense: testExpense),
      ).thenAnswer((_) async => true);

      final key = GlobalKey<NavigatorState>();

      await tester.pumpWidget(
        MaterialApp(
          navigatorKey: key,
          home: Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () => notifier.editExpense(
                  context,
                  expense: testExpense,
                  expenseId: '1',
                ),
                child: const Text('Edit Expense'),
              );
            },
          ),
        ),
      );

      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      expect(notifier.state.value, null);
      expect(find.text('Expense Updated successfully'), findsOneWidget);
    });

    test('editExpense failure sets error state', () async {
      when(
        () => mockRepository.editExpense(expenseId: '1', expense: testExpense),
      ).thenThrow(Exception('Failed'));

      final context = MockBuildContext();

      await notifier.editExpense(context, expense: testExpense, expenseId: '1');

      expect(notifier.state.error, isA<Exception>());
    });

    testWidgets('deleteExpense success shows SnackBar and pops', (
      tester,
    ) async {
      when(
        () => mockRepository.deleteExpense(expenseId: '1'),
      ).thenAnswer((_) async => true);

      final key = GlobalKey<NavigatorState>();

      await tester.pumpWidget(
        MaterialApp(
          navigatorKey: key,
          home: Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () =>
                    notifier.deleteExpense(context, expenseId: '1'),
                child: const Text('Delete Expense'),
              );
            },
          ),
        ),
      );

      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      expect(notifier.state.value, null);
      expect(find.text('Expense Deleted successfully'), findsOneWidget);
    });

    test('deleteExpense failure sets error state', () async {
      when(
        () => mockRepository.deleteExpense(expenseId: '1'),
      ).thenThrow(Exception('Failed'));

      final context = MockBuildContext();

      await notifier.deleteExpense(context, expenseId: '1');
      expect(notifier.state.error, isA<Exception>());
    });
  });
}
