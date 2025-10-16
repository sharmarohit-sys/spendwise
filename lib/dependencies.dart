import 'package:get_it/get_it.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spendwise/utils/firestore/data/repository/firestore_repository_impl.dart';
import 'package:spendwise/utils/firestore/domain/repository/firestore_repository.dart';
import 'package:spendwise/features/authentication/data/repositories/authentication_repository.dart';
import 'package:spendwise/utils/local_storage.dart';

final getIt = GetIt.instance;

class Dependencies {
  Future<void> setUpDependencyInjection() async {
    getIt.registerSingleton<FirebaseAuth>(FirebaseAuth.instance);

    getIt.registerSingletonAsync<SharedPreferences>(
      () async => await SharedPreferences.getInstance(),
    );

    await getIt.isReady<SharedPreferences>();

    getIt.registerSingleton<LocalStorage>(
      LocalStorage(getIt<SharedPreferences>()),
    );
    getIt.registerSingleton<FirestoreRepositoryImpl>(FirestoreRepositoryImpl());
    getIt.registerSingleton<AuthenticationRepository>(
      AuthenticationRepository(
        auth: getIt<FirebaseAuth>(),
        localStorage: getIt<LocalStorage>(),
        firestoreExpenseRepository: getIt<FirestoreRepositoryImpl>(),
      ),
    );
  }
}
