// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'date_wise_expense_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(DateWiseExpenseController)
const dateWiseExpenseControllerProvider = DateWiseExpenseControllerProvider._();

final class DateWiseExpenseControllerProvider
    extends
        $AsyncNotifierProvider<DateWiseExpenseController, List<ExpenseModel>> {
  const DateWiseExpenseControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dateWiseExpenseControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dateWiseExpenseControllerHash();

  @$internal
  @override
  DateWiseExpenseController create() => DateWiseExpenseController();
}

String _$dateWiseExpenseControllerHash() =>
    r'2f26dea011d1283c67c9e8921a0b5969c9a168be';

abstract class _$DateWiseExpenseController
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
