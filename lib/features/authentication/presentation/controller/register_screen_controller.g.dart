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
    r'5b1e155a5b8e8855e34b4e6cb9dc689ab2e833e7';

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
