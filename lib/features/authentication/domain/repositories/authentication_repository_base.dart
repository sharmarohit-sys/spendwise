import 'package:spendwise/features/authentication/domain/model/result_model.dart';

abstract class AuthenticationRepositoryBase {
  Future<Result> registerUser({
    required String emailId,
    required String password,
    required String userName,
  });

  Future<Result> loginUserWithEmailAndPassword({
    required String emailId,
    required String password,
  });
}
