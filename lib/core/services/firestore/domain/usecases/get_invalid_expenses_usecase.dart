import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spendwise/core/di/dependencies.dart';
import 'package:spendwise/core/services/firestore/data/repository/firestore_repository_impl.dart';
import 'package:spendwise/core/services/firestore/domain/model/expense_model.dart';

class GetInvalidExpensesUseCase {
  final FirestoreRepositoryImpl repository;

  GetInvalidExpensesUseCase(this.repository);

  Future<List<ExpenseModel>> call() async {
    return repository.getInvalidExpenses();
  }
}

final getInvalidExpensesUseCaseProvider =
    Provider.autoDispose<GetInvalidExpensesUseCase>((ref) {
      return GetInvalidExpensesUseCase(getIt<FirestoreRepositoryImpl>());
    });
