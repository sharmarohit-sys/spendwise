// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_screen_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(LoginScreenController)
const loginScreenControllerProvider = LoginScreenControllerProvider._();

final class LoginScreenControllerProvider
    extends $AsyncNotifierProvider<LoginScreenController, void> {
  const LoginScreenControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'loginScreenControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$loginScreenControllerHash();

  @$internal
  @override
  LoginScreenController create() => LoginScreenController();
}

String _$loginScreenControllerHash() =>
    r'd80d480ceb383cbb810a343d1c859834b3515b31';

abstract class _$LoginScreenController extends $AsyncNotifier<void> {
  FutureOr<void> build();
  @$mustCallSuper
  @override
  void runBuild() {
    build();
    final ref = this.ref as $Ref<AsyncValue<void>, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<void>, void>,
              AsyncValue<void>,
              Object?,
              Object?
            >;
    element.handleValue(ref, null);
  }
}
