// expense_repository.dart
import 'package:spendwise/utils/firestore/domain/model/expense_model.dart';

abstract class FirestoreRepository {
  Future<bool> addUser({
    required String name,
    required String email,
    required String uId,
  });
  Future<bool> addExpense({required ExpenseModel expense});
  Future<bool> editExpense({
    required String expenseId,
    required ExpenseModel expense,
  });

  Future<bool> deleteExpense({required String expenseId});
  Future<List<ExpenseModel>> getExpensesByUser();
  Future<List<ExpenseModel>> getExpensesByDate(DateTime date);
  Future<List<ExpenseModel>> getInvalidExpenses();
}
