import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spendwise/core/di/dependencies.dart';
import 'package:spendwise/core/services/firestore/data/repository/firestore_repository_impl.dart';
import 'package:spendwise/core/services/firestore/domain/model/expense_model.dart';

class EditExpenseUseCase {
  final FirestoreRepositoryImpl repository;

  EditExpenseUseCase(this.repository);

  Future<bool> call({
    required String expenseId,
    required ExpenseModel expense,
  }) async {
    return repository.editExpense(expenseId: expenseId, expense: expense);
  }
}

final editExpenseUseCaseProvider = Provider.autoDispose<EditExpenseUseCase>((
  ref,
) {
  return EditExpenseUseCase(getIt<FirestoreRepositoryImpl>());
});
