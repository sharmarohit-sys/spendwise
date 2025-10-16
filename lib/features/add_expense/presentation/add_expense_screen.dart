import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spendwise/constants/string_constants.dart';
import 'package:spendwise/features/add_expense/presentation/notifier/add_new_expense_notifer.dart';
import 'package:spendwise/utils/date_time_callback.dart';
import 'package:spendwise/utils/firestore/domain/expense_model.dart';
import 'package:spendwise/widget/async_value_widget.dart';
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

  final TextEditingController _amountCtrl = TextEditingController();
  final TextEditingController _noteCtrl = TextEditingController();

  String? _category;
  DateTime _selectedDate = DateTime.now();
  final _categories = ['Food', 'Travel', 'Shopping', 'Coffee'];
  String expenseStatus = 'valid';

  @override
  void initState() {
    super.initState();
    if (widget.expenseModel != null) {
      _amountCtrl.text = widget.expenseModel?.amount.toString() ?? '0';
      _noteCtrl.text = widget.expenseModel!.note ?? '';
      _category = widget.expenseModel!.category;
      _selectedDate = DateTime.parse(widget.expenseModel!.date);
      expenseStatus = widget.expenseModel!.status;
    }
  }

  void _saveExpense() async {
    if (_formKey.currentState!.validate()) {
      final expense = ExpenseModel(
        id: widget.expenseModel?.id ?? '',

        category: _category ?? '',
        note: _noteCtrl.text.trim(),
        amount: double.parse(_amountCtrl.text.trim()),
        date: _selectedDate.toIso8601String(),
        status: expenseStatus,
        timestamp: _selectedDate,
      );
      widget.expenseModel != null
          ? ref
                .read(addExpenseControllerProvider.notifier)
                .editExpense(
                  context,
                  expenseId: widget.expenseModel!.id,
                  expense: expense,
                )
          : ref
                .read(addExpenseControllerProvider.notifier)
                .addExpense(context, expense: expense);
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(addExpenseControllerProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.expenseModel != null
              ? StringConstants.editExpense
              : StringConstants.addExpense,
        ),
        actions: [
          if (widget.expenseModel != null)
            IconButton(
              onPressed: () => ref
                  .read(addExpenseControllerProvider.notifier)
                  .deleteExpense(
                    context,
                    expenseId: widget.expenseModel?.id ?? '',
                  ),
              icon: const Icon(Icons.delete_outlined, color: Colors.red),
            ),
        ],
      ),
      body: AsyncValueWidget(
        value: controller,
        data: (data) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  TextFormField(
                    controller: _amountCtrl,
                    maxLength: 10,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: const InputDecoration(
                      labelText: StringConstants.amount,
                      counterText: '',
                      prefixIcon: Icon(Icons.attach_money),
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (v) => v == null || v.isEmpty
                        ? StringConstants.enterAmount
                        : null,
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: _category,
                    decoration: const InputDecoration(
                      labelText: StringConstants.category,
                      prefixIcon: Icon(Icons.category),
                      border: OutlineInputBorder(),
                    ),
                    items: _categories
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (v) => _category = v,
                    validator: (v) =>
                        v == null ? StringConstants.selectCategory : null,
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
                          Text(DateTimeCallback.getTimeInString(_selectedDate)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _noteCtrl,
                    decoration: const InputDecoration(
                      labelText: StringConstants.noteOptional,
                      prefixIcon: Icon(Icons.note_alt_outlined),
                      border: OutlineInputBorder(),
                    ),
                  ),

                  if (widget.expenseModel != null) ...[
                    const SizedBox(height: 8),

                    MarkInvalidExpense(
                      status: expenseStatus,
                      onStatusChanged: (status) => expenseStatus = status,
                    ),
                  ],
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _saveExpense,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      StringConstants.saveExpense,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

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
          title: const Text(StringConstants.markInvalid),
          onChanged: (val) {
            statusNotifier.value = val == true ? 'invalid' : 'valid';
            onStatusChanged?.call(statusNotifier.value);
          },
        );
      },
    );
  }
}
