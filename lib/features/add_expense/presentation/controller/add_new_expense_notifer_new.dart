import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:spendwise/dependencies.dart';
import 'package:spendwise/utils/firestore/data/firestore_repository_impl.dart';
import 'package:spendwise/utils/firestore/domain/expense_model.dart';

class AddNewExpenseNotifier extends StateNotifier<AsyncValue<ExpenseModel?>> {
  AddNewExpenseNotifier(this._expenseRepository)
    : super(const AsyncValue.data(null));

  final FirestoreRepositoryImpl _expenseRepository;

  Future<void> addExpense(
    BuildContext context, {
    required ExpenseModel expense,
    required,
  }) async {
    state = const AsyncValue.loading();
    try {
      await _expenseRepository.addExpense(expense: expense);

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
      await _expenseRepository.editExpense(
        expenseId: expenseId,
        expense: expense,
      );

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
      await _expenseRepository.deleteExpense(expenseId: expenseId);

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
      final expenseRepository = getIt<FirestoreRepositoryImpl>();
      return AddNewExpenseNotifier(expenseRepository);
    });
