import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:spendwise/dependencies.dart';
import 'package:spendwise/navigation/routes.dart';

import 'package:spendwise/utils/firestore/data/firestore_repository_impl.dart';
import 'package:spendwise/utils/firestore/domain/expense_model.dart';

class HomeNotifier extends StateNotifier<AsyncValue<List<ExpenseModel>>> {
  HomeNotifier(this._expenseRepository) : super(const AsyncValue.data([])) {
    fetchExpenses();
  }
  // final _expenseRepository = getIt<FirestoreRepositoryImpl>();
  final FirestoreRepositoryImpl _expenseRepository;

  Future<void> fetchExpenses() async {
    state = const AsyncValue.loading();
    try {
      final expenses = await _expenseRepository.getExpensesByUser();
      expenses.sort(
        (left, right) =>
            DateTime.parse(right.date).compareTo(DateTime.parse(left.date)),
      );
      state = AsyncValue.data(expenses);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  void navigateToAddExpense(
    BuildContext context, {
    ExpenseModel? expense,
  }) async {
    final result = await Navigator.pushNamed(
      context,
      Routes.addExpenseScreen,
      arguments: expense,
    );
    if (result != null) {
      fetchExpenses();
    }
  }

  void navigateToInvalidExpenseScreen(
    BuildContext context, {
    ExpenseModel? expense,
  }) {
    Navigator.pushNamed(context, Routes.invalidExpenseScreen);
  }

  void navigateToDateWiseExpenseScreen(
    BuildContext context, {
    ExpenseModel? expense,
  }) {
    Navigator.pushNamed(context, Routes.dateWiseExpenseScreen);
  }
}

final homeControllerProvider =
    StateNotifierProvider<HomeNotifier, AsyncValue<List<ExpenseModel>>>(
      (ref) => HomeNotifier(getIt<FirestoreRepositoryImpl>()),
    );
