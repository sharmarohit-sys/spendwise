// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'invalid_expense_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(InvalidExpenseController)
const invalidExpenseControllerProvider = InvalidExpenseControllerProvider._();

final class InvalidExpenseControllerProvider
    extends
        $AsyncNotifierProvider<InvalidExpenseController, List<ExpenseModel>> {
  const InvalidExpenseControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'invalidExpenseControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$invalidExpenseControllerHash();

  @$internal
  @override
  InvalidExpenseController create() => InvalidExpenseController();
}

String _$invalidExpenseControllerHash() =>
    r'a9dd28cfa4191c712130e307e7b3a2e8b673f70a';

abstract class _$InvalidExpenseController
    extends $AsyncNotifier<List<ExpenseModel>> {
  FutureOr<List<ExpenseModel>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref as $Ref<AsyncValue<List<ExpenseModel>>, List<ExpenseModel>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<ExpenseModel>>, List<ExpenseModel>>,
              AsyncValue<List<ExpenseModel>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
