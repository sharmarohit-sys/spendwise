import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:spendwise/dependencies.dart';
import 'package:spendwise/utils/firestore/domain/expense_model.dart';
import 'package:spendwise/utils/firestore/data/firestore_repository_impl.dart';
part 'invalid_expense_controller.g.dart';

@riverpod
class InvalidExpenseController extends _$InvalidExpenseController {
  final _expenseRepository = getIt<FirestoreRepositoryImpl>();
  @override
  FutureOr<List<ExpenseModel>> build() {
    fetchAllInvalidExpense();
    return [];
  }

  Future<void> fetchAllInvalidExpense() async {
    state = const AsyncValue.loading();
    try {
      final expenses = await _expenseRepository.getInvalidExpenses();
      state = AsyncValue.data(expenses);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
