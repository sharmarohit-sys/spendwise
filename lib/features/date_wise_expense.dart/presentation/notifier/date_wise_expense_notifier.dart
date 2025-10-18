import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:spendwise/core/services/firestore/domain/usecases/get_expenses_by_date_usecase.dart';

import '../../../../core/services/firestore/domain/model/expense_model.dart';

class DateWiseExpenseNotifier
    extends StateNotifier<AsyncValue<List<ExpenseModel>>> {
  DateWiseExpenseNotifier(this._getExpensesByDateUseCase)
    : super(const AsyncValue.data([])) {
    fetchDateWiseExpenses(DateTime.now());
  }
  final GetExpensesByDateUseCase _getExpensesByDateUseCase;
  Future<void> fetchDateWiseExpenses(DateTime dateTime) async {
    state = const AsyncValue.loading();
    try {
      final expenses = await _getExpensesByDateUseCase.call(dateTime);
      state = AsyncValue.data(expenses);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final dateWiseExpenseControllerProvider =
    StateNotifierProvider.autoDispose<
      DateWiseExpenseNotifier,
      AsyncValue<List<ExpenseModel>>
    >((ref) {
      final dateWise = ref.read(getExpensesByDateUseCaseProvider);
      return DateWiseExpenseNotifier(dateWise);
    });
