import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spendwise/core/di/dependencies.dart';
import 'package:spendwise/core/services/firestore/data/repository/firestore_repository_impl.dart';
import 'package:spendwise/core/services/firestore/domain/model/expense_model.dart';

class GetExpensesByDateUseCase {
  GetExpensesByDateUseCase(this.repository);
  final FirestoreRepositoryImpl repository;

  Future<List<ExpenseModel>> call(DateTime date) async {
    final expenses = await repository.getExpensesByDate(date);
    final List<ExpenseModel> expensesForDate = filterExpensesByDate(
      expenses,
      date,
    );
    return expensesForDate;
  }

  List<ExpenseModel> filterExpensesByDate(
    List<ExpenseModel> expenses,
    DateTime? start,
  ) {
    final DateTime? end = start?.add(const Duration(days: 1));
    final filtered = expenses.where((expense) {
      final expenseDate = DateTime.parse(
        expense.date,
      ); // ISO string to DateTime
      if (start != null && expenseDate.isBefore(start)) return false;
      if (end != null && expenseDate.isAfter(end)) return false;
      return true;
    }).toList();

    // Sort by date descending (latest first)
    filtered.sort(
      (left, right) =>
          DateTime.parse(right.date).compareTo(DateTime.parse(left.date)),
    );

    return filtered;
  }
}

final getExpensesByDateUseCaseProvider =
    Provider.autoDispose<GetExpensesByDateUseCase>((ref) {
      return GetExpensesByDateUseCase(getIt<FirestoreRepositoryImpl>());
    });
