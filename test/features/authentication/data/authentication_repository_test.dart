import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spendwise/core/services/firestore/domain/repository/firestore_repository.dart';
import 'package:spendwise/core/utils/local_storage.dart';
import 'package:spendwise/features/authentication/data/repositories/authentication_repository.dart';

// ---- Mock Classes ----
class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockUserCredential extends Mock implements UserCredential {}

class MockUser extends Mock implements User {}

class MockLocalStorage extends Mock implements LocalStorage {}

class MockFirestoreRepository extends Mock implements FirestoreRepository {}

void main() {
  late MockFirebaseAuth mockFirebaseAuth;
  late MockLocalStorage mockLocalStorage;
  late MockFirestoreRepository mockFirestoreRepo;
  late MockUserCredential mockUserCredential;
  late MockUser mockUser;
  late AuthenticationRepository repository;

  setUp(() {
    mockFirebaseAuth = MockFirebaseAuth();
    mockLocalStorage = MockLocalStorage();
    mockFirestoreRepo = MockFirestoreRepository();
    mockUserCredential = MockUserCredential();
    mockUser = MockUser();

    repository = AuthenticationRepository(
      auth: mockFirebaseAuth,
      localStorage: mockLocalStorage,
      firestoreExpenseRepository: mockFirestoreRepo,
    );
  });

  group('AuthenticationRepository - registerUser', () {
    test('should return success when user registration succeeds', () async {
      // arrange
      when(
        () => mockFirebaseAuth.createUserWithEmailAndPassword(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenAnswer((_) async => mockUserCredential);

      when(() => mockUserCredential.user).thenReturn(mockUser);
      when(() => mockUser.uid).thenReturn('uid123');

      when(
        () => mockFirestoreRepo.addUser(
          name: any(named: 'name'),
          email: any(named: 'email'),
          uId: any(named: 'uId'),
        ),
      ).thenAnswer((_) async => true);

      when(
        () => mockLocalStorage.saveData(
          key: any(named: 'key'),
          value: any(named: 'value'),
        ),
      ).thenAnswer((_) async {});

      // act
      final result = await repository.registerUser(
        emailId: 'test@example.com',
        password: '123456',
        userName: 'John',
      );

      // assert
      expect(result.isSuccess, true);

      verify(
        () => mockFirebaseAuth.createUserWithEmailAndPassword(
          email: 'test@example.com',
          password: '123456',
        ),
      ).called(1);

      verify(
        () => mockFirestoreRepo.addUser(
          name: 'John',
          email: 'test@example.com',
          uId: 'uid123',
        ),
      ).called(1);
    });

    test('should return failure when Firebase throws exception', () async {
      when(
        () => mockFirebaseAuth.createUserWithEmailAndPassword(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenThrow(FirebaseAuthException(code: 'email-already-in-use'));

      final result = await repository.registerUser(
        emailId: 'test@example.com',
        password: '123456',
        userName: 'John',
      );
      expect(result.error, contains('email-already-in-use'));
    });
  });

  group('AuthenticationRepository - loginUserWithEmailAndPassword', () {
    test('should return success when login succeeds', () async {
      // arrange
      when(
        () => mockFirebaseAuth.signInWithEmailAndPassword(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenAnswer((_) async => mockUserCredential);

      when(() => mockUserCredential.user).thenReturn(mockUser);
      when(() => mockUser.uid).thenReturn('uid123');
      when(() => mockUser.displayName).thenReturn('John Doe');

      when(
        () => mockFirestoreRepo.addUser(
          name: any(named: 'name'),
          email: any(named: 'email'),
          uId: any(named: 'uId'),
        ),
      ).thenAnswer((_) async => true);

      when(
        () => mockLocalStorage.saveData(
          key: any(named: 'key'),
          value: any(named: 'value'),
        ),
      ).thenAnswer((_) async {});

      // act
      final result = await repository.loginUserWithEmailAndPassword(
        emailId: 'test@example.com',
        password: '123456',
      );

      // assert
      expect(result.isSuccess, true);

      verify(
        () => mockFirebaseAuth.signInWithEmailAndPassword(
          email: 'test@example.com',
          password: '123456',
        ),
      ).called(1);
    });

    test('should return failure when Firebase throws error', () async {
      when(
        () => mockFirebaseAuth.signInWithEmailAndPassword(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenThrow(FirebaseAuthException(code: 'wrong-password'));

      final result = await repository.loginUserWithEmailAndPassword(
        emailId: 'test@example.com',
        password: 'wrongpass',
      );
      expect(result.error, contains('wrong-password'));
    });
  });
}
