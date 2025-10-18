import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:spendwise/core/services/firestore/domain/model/expense_model.dart';
import 'package:spendwise/core/services/firestore/domain/usecases/get_expenses_by_user_usecase.dart';

class HomeNotifier extends StateNotifier<AsyncValue<List<ExpenseModel>>> {
  HomeNotifier(this._getExpensesByUserUseCase)
    : super(const AsyncValue.data([])) {
    fetchExpenses();
  }
  final GetExpensesByUserUseCase _getExpensesByUserUseCase;

  Future<void> fetchExpenses() async {
    state = const AsyncValue.loading();
    try {
      final expenses = await _getExpensesByUserUseCase.call();

      state = AsyncValue.data(expenses);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final homeControllerProvider =
    StateNotifierProvider<HomeNotifier, AsyncValue<List<ExpenseModel>>>(
      (ref) => HomeNotifier(ref.read(getExpensesByUserUseCaseProvider)),
    );
