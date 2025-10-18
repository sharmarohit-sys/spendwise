import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:spendwise/core/services/firestore/domain/model/expense_model.dart';
import 'package:spendwise/core/services/firestore/domain/usecases/add_expense_usecase.dart';
import 'package:spendwise/core/services/firestore/domain/usecases/delete_expense_usecase.dart';
import 'package:spendwise/core/services/firestore/domain/usecases/edit_expense_usecase.dart';
import 'package:spendwise/core/utils/spendwise_toast.dart';

class AddNewExpenseNotifier extends StateNotifier<AsyncValue<ExpenseModel?>> {
  AddNewExpenseNotifier({
    required this.addExpenseUseCase,
    required this.editExpenseUseCase,
    required this.deleteExpenseUseCase,
  }) : super(const AsyncValue.data(null));

  final AddExpenseUseCase addExpenseUseCase;
  final EditExpenseUseCase editExpenseUseCase;
  final DeleteExpenseUseCase deleteExpenseUseCase;

  Future<void> addExpense({required ExpenseModel expense}) async {
    state = const AsyncValue.loading();
    try {
      await addExpenseUseCase.call(expense: expense);
      state = const AsyncValue.data(null);
      SpendWiseToast.success('Expense Added successfully');
    } catch (e, st) {
      // On error, update the state to error
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> editExpense({
    required ExpenseModel expense,
    required String expenseId,
  }) async {
    state = const AsyncValue.loading();
    try {
      await editExpenseUseCase.call(expenseId: expenseId, expense: expense);
      state = const AsyncValue.data(null);
      SpendWiseToast.success('Expense Updated successfully');
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      SpendWiseToast.error(e.toString());
    }
  }

  Future<void> deleteExpense({required String expenseId}) async {
    state = const AsyncValue.loading();
    try {
      await deleteExpenseUseCase.call(expenseId: expenseId);
      state = const AsyncValue.data(null);
      SpendWiseToast.success('Expense Deleted successfully');
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
