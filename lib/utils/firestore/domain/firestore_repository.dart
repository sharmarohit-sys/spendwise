// expense_repository.dart
import 'package:spendwise/utils/firestore/domain/expense_model.dart';

abstract class FirestoreRepository {
  Future<void> addUser({
    required String name,
    required String email,
    required String uId,
  });
  Future<void> addExpense({required ExpenseModel expense});
  Future<void> editExpense({
    required String expenseId,
    required ExpenseModel expense,
  });

  Future<void> deleteExpense({required String expenseId});
  Future<List<ExpenseModel>> getExpensesByUser();
  Future<List<ExpenseModel>> getExpensesByDate(DateTime date);
  Future<List<ExpenseModel>> getInvalidExpenses();
}
