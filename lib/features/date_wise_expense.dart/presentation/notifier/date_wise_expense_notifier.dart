import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:spendwise/dependencies.dart';
import 'package:spendwise/utils/firestore/data/firestore_repository_impl.dart';

import '../../../../utils/firestore/domain/expense_model.dart';

class DateWiseExpenseNotifier
    extends StateNotifier<AsyncValue<List<ExpenseModel>>> {
  DateWiseExpenseNotifier(this._expenseRepository)
    : super(const AsyncValue.data([])) {
    fetchDateWiseExpenses(DateTime.now());
  }
  // final _expenseRepository = getIt<FirestoreRepositoryImpl>();
  final FirestoreRepositoryImpl _expenseRepository;

  Future<void> fetchDateWiseExpenses(DateTime dateTime) async {
    state = const AsyncValue.loading();

    try {
      final expenses = await _expenseRepository.getExpensesByDate(dateTime);
      final List<ExpenseModel> todayExpenses = filterExpensesByDate(
        expenses,
        dateTime,
      );
      state = AsyncValue.data(todayExpenses);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  List<ExpenseModel> filterExpensesByDate(
    List<ExpenseModel> expenses,
    DateTime? start,
  ) {
    DateTime? end = start?.add(Duration(days: 1));
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

final dateWiseExpenseControllerProvider =
    StateNotifierProvider.autoDispose<
      DateWiseExpenseNotifier,
      AsyncValue<List<ExpenseModel>>
    >((ref) {
      final expenseRepository = getIt<FirestoreRepositoryImpl>();
      return DateWiseExpenseNotifier(expenseRepository);
    });
