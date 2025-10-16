import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spendwise/dependencies.dart';
import 'package:spendwise/utils/firestore/data/repository/firestore_repository_impl.dart';
import 'package:spendwise/utils/firestore/domain/model/expense_model.dart';

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
