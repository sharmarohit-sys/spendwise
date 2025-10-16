import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:spendwise/utils/firestore/domain/model/expense_model.dart';
import 'package:spendwise/utils/firestore/domain/usecases/get_invalid_expenses_usecase.dart';

class InvalidExpenseNotifier
    extends StateNotifier<AsyncValue<List<ExpenseModel>>> {
  InvalidExpenseNotifier(this._getInvalidExpensesUseCase)
    : super(const AsyncValue.data([])) {
    fetchAllInvalidExpense();
  }
  // final _expenseRepository = getIt<FirestoreRepositoryImpl>();
  final GetInvalidExpensesUseCase _getInvalidExpensesUseCase;

  Future<void> fetchAllInvalidExpense() async {
    state = const AsyncValue.loading();
    try {
      final expenses = await _getInvalidExpensesUseCase.call();
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
      return InvalidExpenseNotifier(
        ref.read(getInvalidExpensesUseCaseProvider),
      );
    });
