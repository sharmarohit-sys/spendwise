import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spendwise/features/authentication/domain/model/result_model.dart';
import 'package:spendwise/features/authentication/domain/repositories/authentication_repository_base.dart';
import 'package:spendwise/features/authentication/domain/usecases/register_user_usecase.dart';

class MockAuthRepository extends Mock implements AuthenticationRepositoryBase {}

void main() {
  late MockAuthRepository mockRepository;
  late RegisterUserUseCase registerUserUseCase;

  setUp(() {
    mockRepository = MockAuthRepository();
    registerUserUseCase = RegisterUserUseCase(mockRepository);
  });

  group('RegisterUserUseCase', () {
    test('returns success when repository registration succeeds', () async {
      // arrange
      when(
        () => mockRepository.registerUser(
          emailId: any(named: 'emailId'),
          password: any(named: 'password'),
          userName: any(named: 'userName'),
        ),
      ).thenAnswer((_) async => Result.success());

      // act
      final result = await registerUserUseCase.call(
        emailId: 'test@example.com',
        password: '123456',
        userName: 'John Doe',
      );

      // assert
      expect(result.isSuccess, true);
      verify(
        () => mockRepository.registerUser(
          emailId: 'test@example.com',
          password: '123456',
          userName: 'John Doe',
        ),
      ).called(1);
    });

    test('returns failure when repository registration fails', () async {
      // arrange
      when(
        () => mockRepository.registerUser(
          emailId: any(named: 'emailId'),
          password: any(named: 'password'),
          userName: any(named: 'userName'),
        ),
      ).thenAnswer((_) async => Result.failure('Email already exists'));

      // act
      final result = await registerUserUseCase.call(
        emailId: 'duplicate@example.com',
        password: '123456',
        userName: 'Existing User',
      );

      // assert
      expect(result.error, 'Email already exists');
    });
  });
}
