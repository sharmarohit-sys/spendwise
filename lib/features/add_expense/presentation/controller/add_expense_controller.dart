import 'dart:async';

import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:spendwise/dependencies.dart';
import 'package:spendwise/utils/firestore/domain/expense_model.dart';
import 'package:spendwise/utils/firestore/data/firestore_repository_impl.dart';
part 'add_expense_controller.g.dart';

@riverpod
class AddExpenseController extends _$AddExpenseController {
  final _expenseRepository = getIt<FirestoreRepositoryImpl>();

  @override
  FutureOr<ExpenseModel?> build() {
    return null; // initial state
  }

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
    } catch (e, st) {
      // On error, update the state to error
      state = AsyncValue.error(e, st);
    }
  }
}
