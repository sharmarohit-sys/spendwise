import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:spendwise/features/authentication/domain/usecases/login_user_usecase.dart';

class LoginScreenNotifier extends StateNotifier<AsyncValue<void>> {
  LoginScreenNotifier(this._loginUserUseCase)
    : super(const AsyncValue.data(null));

  final LoginUserUseCase _loginUserUseCase;

  Future<void> login({
    required String emailId,
    required String password,
  }) async {
    state = const AsyncValue.loading();
    try {
      final result = await _loginUserUseCase(
        emailId: emailId,
        password: password,
      );

      if (result.isSuccess) {
        state = const AsyncValue.data(null);
        //
      } else {
        state = AsyncValue.error(
          result.error ?? 'Unable to login',
          StackTrace.current,
        );
      }
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final loginScreenControllerProvider =
    StateNotifierProvider.autoDispose<LoginScreenNotifier, AsyncValue<void>>((
      ref,
    ) {
      return LoginScreenNotifier(ref.read(loginuseCaseProvider));
    });
