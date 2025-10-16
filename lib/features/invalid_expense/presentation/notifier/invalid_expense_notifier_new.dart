import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:spendwise/dependencies.dart';
import 'package:spendwise/utils/firestore/data/firestore_repository_impl.dart';
import 'package:spendwise/utils/firestore/domain/expense_model.dart';

class InvalidExpenseNotifier
    extends StateNotifier<AsyncValue<List<ExpenseModel>>> {
  InvalidExpenseNotifier(this._expenseRepository)
    : super(const AsyncValue.data([])) {
    fetchAllInvalidExpense();
  }
  // final _expenseRepository = getIt<FirestoreRepositoryImpl>();
  final FirestoreRepositoryImpl _expenseRepository;

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

final invalidExpenseControllerProvider =
    StateNotifierProvider.autoDispose<
      InvalidExpenseNotifier,
      AsyncValue<List<ExpenseModel>>
    >((ref) {
      final expenseRepository = getIt<FirestoreRepositoryImpl>();
      return InvalidExpenseNotifier(expenseRepository);
    });
