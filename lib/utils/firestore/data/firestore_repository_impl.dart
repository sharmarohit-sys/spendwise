import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:spendwise/constants/shared_preference.dart';
import 'package:spendwise/dependencies.dart';
import 'package:spendwise/utils/firestore/domain/expense_model.dart';
import 'package:spendwise/utils/firestore/domain/firestore_repository.dart';
import 'package:spendwise/utils/local_storage.dart';

class FirestoreRepositoryImpl implements FirestoreRepository {
  FirestoreRepositoryImpl() {
    final email = _loalDb.readData(key: SharedPreference.emailIdKey);
    collectionName = 'expenses$email';
  }
  final _db = FirebaseFirestore.instance;
  final _loalDb = getIt<LocalStorage>();

  late String collectionName;

  @override
  Future<void> addUser({
    required String name,
    required String email,
    required String uId,
  }) async {
    try {
      // Add without id first
      final docRef = await _db.collection('user').add({
        'name': name,
        'email': email,
        'uId': uId,
      });

      // Update the expense with the generated doc ID
      await docRef.update({'id': docRef.id});
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> addExpense({required ExpenseModel expense}) async {
    try {
      // Add without id first
      final docRef = await _db.collection(collectionName).add(expense.toJson());

      // Update the expense with the generated doc ID
      await docRef.update({'id': docRef.id});
    } catch (e) {
      rethrow;
    }
  }

  // New edit/update method
  @override
  Future<void> editExpense({
    required String expenseId,
    required ExpenseModel expense,
  }) async {
    try {
      await _db
          .collection(collectionName)
          .doc(expenseId)
          .update(expense.toJson());
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> deleteExpense({required String expenseId}) async {
    try {
      await _db.collection(collectionName).doc(expenseId).delete();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<ExpenseModel>> getExpensesByUser() async {
    try {
      final snapshot = await _db
          .collection(collectionName)
          .where('status', isEqualTo: 'valid')
          .orderBy('date', descending: true)
          .get();

      return snapshot.docs.map((e) => ExpenseModel.fromJson(e.data())).toList();
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<List<ExpenseModel>> getExpensesByDate(DateTime date) async {
    final start = DateTime(date.year, date.month, date.day);
    final end = start.add(const Duration(days: 1));

    try {
      final snapshot = await _db
          .collection(collectionName)
          .where('status', isEqualTo: 'valid')
          //TODO: update the where filer query
          // .where('date', isGreaterThanOrEqualTo: start)
          // .where('date', isLessThan: end)
          .get();

      return snapshot.docs.map((e) => ExpenseModel.fromJson(e.data())).toList();
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<List<ExpenseModel>> getInvalidExpenses() async {
    final snapshot = await _db
        .collection(collectionName)
        .where('status', isEqualTo: 'invalid')
        .get();

    return snapshot.docs.map((e) => ExpenseModel.fromJson(e.data())).toList();
  }
}
