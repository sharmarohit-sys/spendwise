import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:spendwise/dependencies.dart';
import 'package:spendwise/utils/firestore/domain/expense_model.dart';

import 'package:spendwise/navigation/routes.dart';
import 'package:spendwise/utils/firestore/data/firestore_repository_impl.dart';
part 'home_controller.g.dart';

@riverpod
class HomeController extends _$HomeController {
  final _expenseRepository = getIt<FirestoreRepositoryImpl>();

  @override
  FutureOr<List<ExpenseModel>> build() {
    fetchExpenses();
    return [];
  }

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

  List<ExpenseModel> filterExpensesByDate(
    List<ExpenseModel> expenses,
    DateTime? start,
    DateTime? end,
  ) {
    final filtered = expenses.where((expense) {
      final expenseDate = DateTime.parse(
        expense.date,
      ); // ISO string to DateTime
      if (start != null && expenseDate.isBefore(start)) return false;
      if (end != null && expenseDate.isAfter(end)) return false;
      return true;
    }).toList();

    // Sort by date descending (latest first)
    filtered.sort(
      (left, right) =>
          DateTime.parse(right.date).compareTo(DateTime.parse(left.date)),
    );

    return filtered;
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
