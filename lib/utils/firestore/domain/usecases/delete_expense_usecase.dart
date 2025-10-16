import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spendwise/dependencies.dart';
import 'package:spendwise/utils/firestore/data/repository/firestore_repository_impl.dart';

class DeleteExpenseUseCase {
  final FirestoreRepositoryImpl repository;

  DeleteExpenseUseCase(this.repository);

  Future<bool> call({required String expenseId}) async {
    return repository.deleteExpense(expenseId: expenseId);
  }
}

final deleteExpenseUseCaseProvider = Provider.autoDispose<DeleteExpenseUseCase>(
  (ref) {
    return DeleteExpenseUseCase(getIt<FirestoreRepositoryImpl>());
  },
);
