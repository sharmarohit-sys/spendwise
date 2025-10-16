import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spendwise/core/di/dependencies.dart';
import 'package:spendwise/core/services/firestore/data/repository/firestore_repository_impl.dart';
import 'package:spendwise/core/services/firestore/domain/model/expense_model.dart';

class GetExpensesByUserUseCase {
  GetExpensesByUserUseCase(this.repository);
  final FirestoreRepositoryImpl repository;

  Future<List<ExpenseModel>> call() async {
    return repository.getExpensesByUser();
  }
}

final getExpensesByUserUseCaseProvider =
    Provider.autoDispose<GetExpensesByUserUseCase>((ref) {
      return GetExpensesByUserUseCase(getIt<FirestoreRepositoryImpl>());
    });
