import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spendwise/core/di/dependencies.dart';
import 'package:spendwise/features/authentication/data/repositories/authentication_repository.dart';
import 'package:spendwise/features/authentication/domain/repositories/authentication_repository_base.dart';
import 'package:spendwise/features/authentication/domain/model/result_model.dart';

class LoginUserUseCase {
  final AuthenticationRepositoryBase repository;

  LoginUserUseCase(this.repository);

  Future<Result> call({
    required String emailId,
    required String password,
  }) async {
    return repository.loginUserWithEmailAndPassword(
      emailId: emailId,
      password: password,
    );
  }
}

final loginuseCaseProvider = Provider.autoDispose<LoginUserUseCase>((ref) {
  return LoginUserUseCase(getIt<AuthenticationRepository>());
});
