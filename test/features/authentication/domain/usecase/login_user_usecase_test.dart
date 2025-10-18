import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spendwise/features/authentication/domain/model/result_model.dart';
import 'package:spendwise/features/authentication/domain/repositories/authentication_repository_base.dart';
import 'package:spendwise/features/authentication/domain/usecases/login_user_usecase.dart';

class MockAuthRepository extends Mock implements AuthenticationRepositoryBase {}

void main() {
  late MockAuthRepository mockRepository;
  late LoginUserUseCase loginUserUseCase;

  setUp(() {
    mockRepository = MockAuthRepository();
    loginUserUseCase = LoginUserUseCase(mockRepository);
  });

  group('LoginUserUseCase', () {
    test('returns success when repository login succeeds', () async {
      // arrange
      when(
        () => mockRepository.loginUserWithEmailAndPassword(
          emailId: any(named: 'emailId'),
          password: any(named: 'password'),
        ),
      ).thenAnswer((_) async => Result.success());

      // act
      final result = await loginUserUseCase.call(
        emailId: 'test@example.com',
        password: '123456',
      );

      // assert
      expect(result.isSuccess, true);
      verify(
        () => mockRepository.loginUserWithEmailAndPassword(
          emailId: 'test@example.com',
          password: '123456',
        ),
      ).called(1);
    });

    test('returns failure when repository login fails', () async {
      // arrange
      when(
        () => mockRepository.loginUserWithEmailAndPassword(
          emailId: any(named: 'emailId'),
          password: any(named: 'password'),
        ),
      ).thenAnswer((_) async => Result.failure('Invalid credentials'));

      // act
      final result = await loginUserUseCase.call(
        emailId: 'wrong@example.com',
        password: 'wrong',
      );

      // assert
      expect(result.error, 'Invalid credentials');
    });
  });
}
