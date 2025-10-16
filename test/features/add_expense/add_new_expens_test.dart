import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spendwise/features/add_expense/presentation/notifier/add_new_expense_notifer.dart';
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
    test('addExpense failure sets error state', () async {
      when(
        () => mockRepository.addExpense(expense: testExpense),
      ).thenThrow(Exception('Failed'));

      // Use a fake context since we don't need UI for state test
      final context = MockBuildContext();

      await notifier.addExpense(context, expense: testExpense);

      expect(notifier.state.error, isA<Exception>());
    });

    test('editExpense failure sets error state', () async {
      when(
        () => mockRepository.editExpense(expenseId: '1', expense: testExpense),
      ).thenThrow(Exception('Failed'));

      final context = MockBuildContext();

      await notifier.editExpense(context, expense: testExpense, expenseId: '1');

      expect(notifier.state.error, isA<Exception>());
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
