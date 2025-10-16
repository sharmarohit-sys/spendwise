import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spendwise/dependencies.dart';
import 'package:spendwise/utils/firestore/data/repository/firestore_repository_impl.dart';
import 'package:spendwise/utils/firestore/domain/model/expense_model.dart';

class GetExpensesByDateUseCase {
  GetExpensesByDateUseCase(this.repository);
  final FirestoreRepositoryImpl repository;

  Future<List<ExpenseModel>> call(DateTime date) async {
    return repository.getExpensesByDate(date);
  }
}

final getExpensesByDateUseCaseProvider =
    Provider.autoDispose<GetExpensesByDateUseCase>((ref) {
      return GetExpensesByDateUseCase(getIt<FirestoreRepositoryImpl>());
    });
