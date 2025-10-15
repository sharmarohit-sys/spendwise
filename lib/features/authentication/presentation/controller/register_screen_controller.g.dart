// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'register_screen_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(RegisterScreenController)
const registerScreenControllerProvider = RegisterScreenControllerProvider._();

final class RegisterScreenControllerProvider
    extends $AsyncNotifierProvider<RegisterScreenController, void> {
  const RegisterScreenControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'registerScreenControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$registerScreenControllerHash();

  @$internal
  @override
  RegisterScreenController create() => RegisterScreenController();
}

String _$registerScreenControllerHash() =>
    r'9a842eb7d6affe84d98526b412e0a56bc126e43b';

abstract class _$RegisterScreenController extends $AsyncNotifier<void> {
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
