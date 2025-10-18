import 'package:firebase_auth/firebase_auth.dart';
import 'package:spendwise/core/constants/shared_preference.dart';
import 'package:spendwise/core/services/firestore/domain/repository/firestore_repository.dart';
import 'package:spendwise/features/authentication/domain/repositories/authentication_repository_base.dart';
import 'package:spendwise/features/authentication/domain/model/result_model.dart';
import 'package:spendwise/core/utils/local_storage.dart';

class AuthenticationRepository implements AuthenticationRepositoryBase {
  AuthenticationRepository({
    required this.auth,
    required this.localStorage,
    required this.firestoreExpenseRepository,
  });

  final FirebaseAuth auth;
  final LocalStorage localStorage;
  final FirestoreRepository firestoreExpenseRepository;

  @override
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
        await saveUserDataToLocalStorage(
          userName: userName,
          emailId: emailId,
          uId: cred.user?.uid ?? '',
        );
        return Result.success();
      }
      return Result.failure('Unknown error occurred during registration.');
    } catch (e) {
      return Result.failure(e.toString());
    }
  }

  @override
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
        await saveUserDataToLocalStorage(
          userName: cred.user?.displayName ?? '',
          emailId: emailId,
          uId: cred.user?.uid ?? '',
        );
        return Result.success();
      }
      return Result.failure('Unknown error occurred during login.');
    } catch (e) {
      return Result.failure(e.toString());
    }
  }

  Future<void> saveUserDataToLocalStorage({
    required String userName,
    required String emailId,
    required String uId,
  }) async {
    await firestoreExpenseRepository.addUser(
      name: userName,
      email: emailId,
      uId: uId,
    );
    await localStorage.saveData(
      key: SharedPreference.userNameKey,
      value: userName,
    );
    await localStorage.saveData(
      key: SharedPreference.emailIdKey,
      value: emailId,
    );
    await localStorage.saveData(key: SharedPreference.uIdKey, value: uId);
    await localStorage.saveData(
      key: SharedPreference.isLoginKey,
      value: 'True',
    );
  }
}
