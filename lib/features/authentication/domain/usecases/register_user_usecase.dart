import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spendwise/core/di/dependencies.dart';
import 'package:spendwise/features/authentication/data/repositories/authentication_repository.dart';
import 'package:spendwise/features/authentication/domain/repositories/authentication_repository_base.dart';
import 'package:spendwise/features/authentication/domain/model/result_model.dart';

class RegisterUserUseCase {
  RegisterUserUseCase(this.repository);
  final AuthenticationRepositoryBase repository;

  Future<Result> call({
    required String emailId,
    required String password,
    required String userName,
  }) async {
    return repository.registerUser(
      emailId: emailId,
      password: password,
      userName: userName,
    );
  }
}

final registerUseCaseProvider = Provider.autoDispose<RegisterUserUseCase>((
  ref,
) {
  return RegisterUserUseCase(getIt<AuthenticationRepository>());
});
