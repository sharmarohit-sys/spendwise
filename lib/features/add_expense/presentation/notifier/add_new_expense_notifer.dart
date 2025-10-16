import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:spendwise/core/di/dependencies.dart';
import 'package:spendwise/core/services/firestore/data/repository/firestore_repository_impl.dart';
import 'package:spendwise/core/services/firestore/domain/model/expense_model.dart';
import 'package:spendwise/core/services/firestore/domain/usecases/add_expense_usecase.dart';
import 'package:spendwise/core/services/firestore/domain/usecases/delete_expense_usecase.dart';
import 'package:spendwise/core/services/firestore/domain/usecases/edit_expense_usecase.dart';

class AddNewExpenseNotifier extends StateNotifier<AsyncValue<ExpenseModel?>> {
  AddNewExpenseNotifier({
    required this.addExpenseUseCase,
    required this.editExpenseUseCase,
    required this.deleteExpenseUseCase,
  }) : super(const AsyncValue.data(null));

  final AddExpenseUseCase addExpenseUseCase;
  final EditExpenseUseCase editExpenseUseCase;
  final DeleteExpenseUseCase deleteExpenseUseCase;

  Future<void> addExpense(
    BuildContext context, {
    required ExpenseModel expense,
    required,
  }) async {
    state = const AsyncValue.loading();
    try {
      await addExpenseUseCase.call(expense: expense);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Expense added successfully')),
        );

        Navigator.pop(context, true);
      }
      state = const AsyncValue.data(null);
    } catch (e, st) {
      // On error, update the state to error
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> editExpense(
    BuildContext context, {
    required ExpenseModel expense,
    required String expenseId,
  }) async {
    state = const AsyncValue.loading();
    try {
      await editExpenseUseCase.call(expenseId: expenseId, expense: expense);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Expense Updated successfully')),
        );
        Navigator.pop(context, true);
      }
      state = const AsyncValue.data(null);
    } catch (e, st) {
      // On error, update the state to error
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> deleteExpense(
    BuildContext context, {
    required String expenseId,
  }) async {
    state = const AsyncValue.loading();
    try {
      await deleteExpenseUseCase.call(expenseId: expenseId);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Expense Deleted successfully')),
        );
        Navigator.pop(context, true);
      }
      state = const AsyncValue.data(null);
    } catch (e, st) {
      // On error, update the state to error
      state = AsyncValue.error(e, st);
    }
  }
}

final addExpenseControllerProvider =
    StateNotifierProvider.autoDispose<
      AddNewExpenseNotifier,
      AsyncValue<ExpenseModel?>
    >((ref) {
      final addExpense = ref.read(addExpenseUseCaseProvider);
      final editExpense = ref.read(editExpenseUseCaseProvider);
      final deleteExpense = ref.read(deleteExpenseUseCaseProvider);
      return AddNewExpenseNotifier(
        addExpenseUseCase: addExpense,
        editExpenseUseCase: editExpense,
        deleteExpenseUseCase: deleteExpense,
      );
    });
