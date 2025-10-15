// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'splash_screen_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SplashScreenController)
const splashScreenControllerProvider = SplashScreenControllerProvider._();

final class SplashScreenControllerProvider
    extends $AsyncNotifierProvider<SplashScreenController, void> {
  const SplashScreenControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'splashScreenControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$splashScreenControllerHash();

  @$internal
  @override
  SplashScreenController create() => SplashScreenController();
}

String _$splashScreenControllerHash() =>
    r'b29f7fd3d796105ceabb95ed9151cb8fd7b5158a';

abstract class _$SplashScreenController extends $AsyncNotifier<void> {
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
