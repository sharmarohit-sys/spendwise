import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:spendwise/core/constants/string_constants.dart';

class MarkInvalidExpense extends StatelessWidget {
  const MarkInvalidExpense({
    super.key,
    this.status = 'valid',
    this.onStatusChanged,
  });
  final String status;
  final Function(String status)? onStatusChanged;

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<String> statusNotifier = ValueNotifier<String>(status);
    return ValueListenableBuilder(
      valueListenable: statusNotifier,
      builder: (context, value, child) {
        return CheckboxListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
          value: value == 'invalid',
          title: Text(StringConstants.markInvalid.tr()),
          onChanged: (val) {
            statusNotifier.value = val == true ? 'invalid' : 'valid';
            onStatusChanged?.call(statusNotifier.value);
          },
        );
      },
    );
  }
}
