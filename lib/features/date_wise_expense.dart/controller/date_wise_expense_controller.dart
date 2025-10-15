import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:spendwise/dependencies.dart';
import 'package:spendwise/utils/firestore/domain/expense_model.dart';
import 'package:spendwise/utils/firestore/domain/firestore_repository.dart';
import 'package:spendwise/utils/firestore/data/firestore_repository_impl.dart';

part 'date_wise_expense_controller.g.dart';

@riverpod
class DateWiseExpenseController extends _$DateWiseExpenseController {
  final _expenseRepository = getIt<FirestoreRepositoryImpl>();

  @override
  FutureOr<List<ExpenseModel>> build() {
    fetchDateWiseExpenses(DateTime.now());
    return [];
  }

  Future<void> fetchDateWiseExpenses(DateTime dateTime) async {
    state = const AsyncValue.loading();

    try {
      final expenses = await _expenseRepository.getExpensesByDate(dateTime);
      final List<ExpenseModel> todayExpenses = expenses.where((expense) {
        final DateTime expenseDate = DateTime.parse(expense.date);

        return expenseDate.year == dateTime.year &&
            expenseDate.month == dateTime.month &&
            expenseDate.day == dateTime.day;
      }).toList();

      todayExpenses.sort(
        (a, b) => DateTime.parse(b.date).compareTo(DateTime.parse(a.date)),
      );
      state = AsyncValue.data(todayExpenses);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  List<ExpenseModel> filterExpensesByDate(
    List<ExpenseModel> expenses,
    DateTime? start,
    DateTime? end,
  ) {
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
      (a, b) => DateTime.parse(b.date).compareTo(DateTime.parse(a.date)),
    );

    return filtered;
  }
}
