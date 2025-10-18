import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spendwise/core/constants/string_constants.dart';
import 'package:spendwise/core/widgets/spend_wise_button.dart';
import 'package:spendwise/core/widgets/spend_wise_text_field.dart';
import 'package:spendwise/features/add_expense/presentation/widgets/mark_invalid_expense.dart';
import 'package:spendwise/features/add_expense/presentation/notifier/add_new_expense_notifer.dart';
import 'package:spendwise/core/utils/date_time_callback.dart';
import 'package:spendwise/core/services/firestore/domain/model/expense_model.dart';
import 'package:spendwise/core/widgets/async_value_widget.dart';
// import '../services/firestore_service.dart';

class AddExpenseScreen extends ConsumerStatefulWidget {
  const AddExpenseScreen({super.key, this.expenseModel});
  final ExpenseModel? expenseModel;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AddExpenseScreenState();
}

class _AddExpenseScreenState extends ConsumerState<AddExpenseScreen> {
  final _formKey = GlobalKey<FormState>();
  // final _firestoreService = FirestoreService();

  final TextEditingController amountCtrl = TextEditingController();
  final TextEditingController noteCtrl = TextEditingController();
  ProviderSubscription<AsyncValue<dynamic>>?
  addNewExpenseControllerSubscription;

  String? _category;
  DateTime _selectedDate = DateTime.now();
  final _categories = ['Food', 'Travel', 'Shopping', 'Coffee'];
  String expenseStatus = 'valid';

  @override
  void initState() {
    super.initState();
    if (widget.expenseModel != null) {
      amountCtrl.text = widget.expenseModel?.amount.toString() ?? '0';
      noteCtrl.text = widget.expenseModel!.note ?? '';
      _category = widget.expenseModel!.category;
      _selectedDate = DateTime.parse(widget.expenseModel!.date);
      expenseStatus = widget.expenseModel!.status;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      addNewExpenseControllerSubscription = ref.listenManual<AsyncValue>(
        addExpenseControllerProvider,
        (prev, next) {
          next.whenData((_) {
            if (context.mounted) {
              Navigator.pop(context, true);
            }
          });
        },
      );
    });
  }

  void _saveExpense() async {
    if (_formKey.currentState!.validate()) {
      final expense = ExpenseModel(
        id: widget.expenseModel?.id ?? '',

        category: _category ?? '',
        note: noteCtrl.text.trim(),
        amount: double.parse(amountCtrl.text.trim()),
        date: _selectedDate.toIso8601String(),
        status: expenseStatus,
        timestamp: _selectedDate,
      );
      widget.expenseModel != null
          ? ref
                .read(addExpenseControllerProvider.notifier)
                .editExpense(
                  expenseId: widget.expenseModel!.id,
                  expense: expense,
                )
          : ref
                .read(addExpenseControllerProvider.notifier)
                .addExpense(expense: expense);
    }
  }

  @override
  void dispose() {
    amountCtrl.dispose();
    noteCtrl.dispose();
    addNewExpenseControllerSubscription?.close();
    log('Add Expense Screen addNewExpenseControllerSubscription disposed');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(addExpenseControllerProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.expenseModel != null
              ? StringConstants.editExpense.tr()
              : StringConstants.addExpense.tr(),
        ),
        actions: [
          if (widget.expenseModel != null)
            IconButton(
              onPressed: () => ref
                  .read(addExpenseControllerProvider.notifier)
                  .deleteExpense(expenseId: widget.expenseModel?.id ?? ''),
              icon: const Icon(Icons.delete_outlined, color: Colors.red),
            ),
        ],
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: AsyncValueWidget(
          value: controller,
          data: (data) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    SpendWiseTextField(
                      controller: amountCtrl,
                      maxLength: 10,
                      labelText: StringConstants.amount.tr(),
                      keyboardType: TextInputType.number,
                      hintText: StringConstants.enterAmount.tr(),
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      prefixIcon: const Icon(Icons.attach_money),
                      validator: (v) => v == null || v.isEmpty
                          ? StringConstants.enterAmount.tr()
                          : null,
                    ),

                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: _category,
                      decoration: InputDecoration(
                        labelText: StringConstants.category.tr(),
                        prefixIcon: const Icon(Icons.category),
                        border: const OutlineInputBorder(),
                      ),
                      items: _categories
                          .map(
                            (e) => DropdownMenuItem(value: e, child: Text(e)),
                          )
                          .toList(),
                      onChanged: (newValue) => _category = newValue,
                      validator: (value) => value == null
                          ? StringConstants.selectCategory.tr()
                          : null,
                    ),
                    const SizedBox(height: 16),
                    GestureDetector(
                      onTap: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2020),
                          lastDate: DateTime.now(),
                        );
                        if (date != null) setState(() => _selectedDate = date);
                      },
                      child: Container(
                        height: 56,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        alignment: Alignment.centerLeft,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadiusGeometry.circular(4),
                          border: Border.all(
                            color: const Color(0xFF000000),
                            width: 1.0,
                            style: BorderStyle.solid,
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.calendar_today_outlined),
                            const SizedBox(width: 16),
                            Text(
                              DateTimeCallback.getTimeInString(_selectedDate),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    SpendWiseTextField(
                      controller: noteCtrl,

                      labelText: StringConstants.noteOptional.tr(),
                      hintText: StringConstants.noteOptional.tr(),

                      prefixIcon: const Icon(Icons.note_alt_outlined),
                    ),

                    if (widget.expenseModel != null) ...[
                      const SizedBox(height: 8),

                      MarkInvalidExpense(
                        status: expenseStatus,
                        onStatusChanged: (status) => expenseStatus = status,
                      ),
                    ],
                    const SizedBox(height: 16),
                    SpendWiseButton(
                      title: StringConstants.saveExpense.tr(),
                      onTap: _saveExpense,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
