import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spendwise/core/di/dependencies.dart';
import 'package:spendwise/core/services/firestore/data/repository/firestore_repository_impl.dart';
import 'package:spendwise/core/services/firestore/domain/model/expense_model.dart';
import 'package:spendwise/core/services/firestore/domain/usecases/add_user_usecase.dart';

class AddExpenseUseCase {
  final FirestoreRepositoryImpl repository;

  AddExpenseUseCase(this.repository);

  Future<bool> call({required ExpenseModel expense}) async {
    return repository.addExpense(expense: expense);
  }
}

final addExpenseUseCaseProvider = Provider.autoDispose<AddExpenseUseCase>((
  ref,
) {
  return AddExpenseUseCase(getIt<FirestoreRepositoryImpl>());
});
