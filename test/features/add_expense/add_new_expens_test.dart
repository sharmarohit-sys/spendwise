import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spendwise/features/add_expense/presentation/notifier/add_new_expense_notifer.dart';
import 'package:spendwise/core/services/firestore/domain/model/expense_model.dart';
import 'package:spendwise/core/services/firestore/domain/usecases/add_expense_usecase.dart';
import 'package:spendwise/core/services/firestore/domain/usecases/delete_expense_usecase.dart';
import 'package:spendwise/core/services/firestore/domain/usecases/edit_expense_usecase.dart';

// ✅ Mock use cases
class MockAddExpenseUseCase extends Mock implements AddExpenseUseCase {}

class MockEditExpenseUseCase extends Mock implements EditExpenseUseCase {}

class MockDeleteExpenseUseCase extends Mock implements DeleteExpenseUseCase {}

// Fake BuildContext for non-widget tests
class MockBuildContext extends Mock implements BuildContext {}

void main() {
  late MockAddExpenseUseCase mockAddUseCase;
  late MockEditExpenseUseCase mockEditUseCase;
  late MockDeleteExpenseUseCase mockDeleteUseCase;
  late AddNewExpenseNotifier notifier;

  setUp(() {
    mockAddUseCase = MockAddExpenseUseCase();
    mockEditUseCase = MockEditExpenseUseCase();
    mockDeleteUseCase = MockDeleteExpenseUseCase();

    notifier = AddNewExpenseNotifier(
      addExpenseUseCase: mockAddUseCase,
      editExpenseUseCase: mockEditUseCase,
      deleteExpenseUseCase: mockDeleteUseCase,
    );
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
        () => mockAddUseCase.call(expense: testExpense),
      ).thenThrow(Exception('Failed'));

      final context = MockBuildContext();

      await notifier.addExpense(context, expense: testExpense);

      expect(notifier.state.error, isA<Exception>());
    });

    test('editExpense failure sets error state', () async {
      when(
        () => mockEditUseCase.call(expenseId: '1', expense: testExpense),
      ).thenThrow(Exception('Failed'));

      final context = MockBuildContext();

      await notifier.editExpense(context, expense: testExpense, expenseId: '1');

      expect(notifier.state.error, isA<Exception>());
    });

    test('deleteExpense failure sets error state', () async {
      when(
        () => mockDeleteUseCase.call(expenseId: '1'),
      ).thenThrow(Exception('Failed'));

      final context = MockBuildContext();

      await notifier.deleteExpense(context, expenseId: '1');

      expect(notifier.state.error, isA<Exception>());
    });

    test('addExpense success sets state to data', () async {
      when(
        () => mockAddUseCase.call(expense: testExpense),
      ).thenAnswer((_) async => Future.value());

      final context = MockBuildContext();

      await notifier.addExpense(context, expense: testExpense);

      expect(notifier.state, isA<AsyncData<ExpenseModel?>>());
    });

    test('editExpense success sets state to data', () async {
      when(
        () => mockEditUseCase.call(expenseId: '1', expense: testExpense),
      ).thenAnswer((_) async => Future.value());

      final context = MockBuildContext();

      await notifier.editExpense(context, expense: testExpense, expenseId: '1');

      expect(notifier.state, isA<AsyncData<ExpenseModel?>>());
    });

    test('deleteExpense success sets state to data', () async {
      when(
        () => mockDeleteUseCase.call(expenseId: '1'),
      ).thenAnswer((_) async => Future.value());

      final context = MockBuildContext();

      await notifier.deleteExpense(context, expenseId: '1');

      expect(notifier.state, isA<AsyncData<ExpenseModel?>>());
    });
  });
}
