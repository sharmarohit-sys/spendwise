import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:spendwise/core/constants/shared_preference.dart';
import 'package:spendwise/core/di/dependencies.dart';
import 'package:spendwise/core/services/firestore/domain/model/expense_model.dart';
import 'package:spendwise/core/services/firestore/domain/repository/firestore_repository.dart';
import 'package:spendwise/core/utils/local_storage.dart';

class FirestoreRepositoryImpl implements FirestoreRepository {
  final _db = FirebaseFirestore.instance;
  final _loalDb = getIt<LocalStorage>();

  late String collectionName;
  String? email;

  @override
  Future<bool> addUser({
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
      return true;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> addExpense({required ExpenseModel expense}) async {
    try {
      // Add without id first
      final docRef = await _db.collection(collectionName).add(expense.toJson());

      // Update the expense with the generated doc ID
      await docRef.update({'id': docRef.id});
      return true;
    } catch (e) {
      rethrow;
    }
  }

  // New edit/update method
  @override
  Future<bool> editExpense({
    required String expenseId,
    required ExpenseModel expense,
  }) async {
    try {
      await _db
          .collection(collectionName)
          .doc(expenseId)
          .update(expense.toJson());
      return true;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> deleteExpense({required String expenseId}) async {
    try {
      await _db.collection(collectionName).doc(expenseId).delete();
      return true;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<ExpenseModel>> getExpensesByUser() async {
    if (email == null) {
      email = _loalDb.readData(key: SharedPreference.emailIdKey);
      collectionName = 'expenses$email';
    }
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
    try {
      final snapshot = await _db
          .collection(collectionName)
          .where('status', isEqualTo: 'valid')
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
