import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spendwise/dependencies.dart';
import 'package:spendwise/utils/firestore/data/repository/firestore_repository_impl.dart';
import 'package:spendwise/utils/firestore/domain/model/expense_model.dart';
import 'package:spendwise/utils/firestore/domain/usecases/add_user_usecase.dart';

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
