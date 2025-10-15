// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_expense_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AddExpenseController)
const addExpenseControllerProvider = AddExpenseControllerProvider._();

final class AddExpenseControllerProvider
    extends $AsyncNotifierProvider<AddExpenseController, ExpenseModel?> {
  const AddExpenseControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'addExpenseControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$addExpenseControllerHash();

  @$internal
  @override
  AddExpenseController create() => AddExpenseController();
}

String _$addExpenseControllerHash() =>
    r'b9bd9ac4973ea0582fa92ed93cce69940b70a878';

abstract class _$AddExpenseController extends $AsyncNotifier<ExpenseModel?> {
  FutureOr<ExpenseModel?> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<ExpenseModel?>, ExpenseModel?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<ExpenseModel?>, ExpenseModel?>,
              AsyncValue<ExpenseModel?>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
