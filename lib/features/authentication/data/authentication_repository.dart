import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:spendwise/constants/shared_preference.dart';
import 'package:spendwise/utils/firestore/data/firestore_repository_impl.dart';
import 'package:spendwise/features/authentication/domain/result_model.dart';
import 'package:spendwise/utils/local_storage.dart';

class AuthenticationRepository {
  AuthenticationRepository({
    required this.auth,
    required this.localStorage,
    required this.firestoreExpenseRepository,
  });

  final FirebaseAuth auth;
  final LocalStorage localStorage;
  final FirestoreRepositoryImpl firestoreExpenseRepository;

  Future<Result> registerUser({
    required String emailId,
    required String password,
    required String userName,
  }) async {
    try {
      final cred = await auth.createUserWithEmailAndPassword(
        email: emailId,
        password: password,
      );

      if (cred.user != null) {
        saveUserDataToLocalStorage(
          userName: userName,
          emailId: emailId,
          uId: cred.user?.uid ?? '',
        );
        return Result.success();
      }
      return Result.failure('Unknown error occurred during registration.');
    } catch (e) {
      log(e.toString(), stackTrace: StackTrace.current);
      return Result.failure(e.toString());
    }
  }

  Future<Result> loginUserWithEmailAndPassword({
    required String emailId,
    required String password,
  }) async {
    try {
      final cred = await auth.signInWithEmailAndPassword(
        email: emailId,
        password: password,
      );
      if (cred.user != null) {
        saveUserDataToLocalStorage(
          userName: cred.user?.displayName ?? '',
          emailId: emailId,
          uId: cred.user?.uid ?? '',
        );
        return Result.success();
      }
      return Result.failure('Unknown error occurred during login.');
    } catch (e) {
      log(e.toString());
      return Result.failure(e.toString());
    }
  }

  /// Stores user authentication data in local storage.
  void saveUserDataToLocalStorage({
    required String userName,
    required String emailId,
    required String uId,
  }) {
    firestoreExpenseRepository.addUser(
      name: userName,
      email: emailId,
      uId: uId,
    );
    localStorage.saveData(key: SharedPreference.userNameKey, value: userName);
    localStorage.saveData(key: SharedPreference.emailIdKey, value: emailId);
    localStorage.saveData(key: SharedPreference.uIdKey, value: uId);
    localStorage.saveData(key: SharedPreference.isLoginKey, value: 'True');
  }
}
