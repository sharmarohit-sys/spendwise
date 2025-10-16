import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spendwise/core/di/dependencies.dart';
import 'package:spendwise/core/services/firestore/data/repository/firestore_repository_impl.dart';

class AddUserUseCase {
  AddUserUseCase(this.repository);
  final FirestoreRepositoryImpl repository;

  Future<bool> call({
    required String name,
    required String email,
    required String uId,
  }) async {
    return repository.addUser(name: name, email: email, uId: uId);
  }
}

final addUserUseCaseProvider = Provider.autoDispose<AddUserUseCase>((ref) {
  return AddUserUseCase(getIt<FirestoreRepositoryImpl>());
});
