import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spendwise/core/di/dependencies.dart';
import 'package:spendwise/core/services/firestore/data/repository/firestore_repository_impl.dart';

class DeleteExpenseUseCase {
  DeleteExpenseUseCase(this.repository);
  final FirestoreRepositoryImpl repository;

  Future<bool> call({required String expenseId}) async {
    return repository.deleteExpense(expenseId: expenseId);
  }
}

final deleteExpenseUseCaseProvider = Provider.autoDispose<DeleteExpenseUseCase>(
  (ref) {
    return DeleteExpenseUseCase(getIt<FirestoreRepositoryImpl>());
  },
);
