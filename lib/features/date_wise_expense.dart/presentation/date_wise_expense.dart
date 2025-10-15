import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spendwise/features/date_wise_expense.dart/controller/date_wise_notifier_new.dart';
import 'package:spendwise/features/date_wise_expense.dart/presentation/widgets/date_selector.dart';
import 'package:spendwise/features/home/presentation/widgets/expense_bar_chart.dart';
import 'package:spendwise/features/home/presentation/widgets/expense_tile.dart';
import 'package:spendwise/widget/async_value_widget.dart';

class DateWiseExpense extends ConsumerStatefulWidget {
  const DateWiseExpense({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _DateWiseExpenseState();
}

class _DateWiseExpenseState extends ConsumerState<DateWiseExpense> {
  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(dateWiseExpenseControllerProvider);
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text('Date Wise Expenses'),
      ),
      body: Column(
        children: [
          DateSelector(
            onSelected: (date) {
              ref
                  .read(dateWiseExpenseControllerProvider.notifier)
                  .fetchDateWiseExpenses(date);
            },
          ),
          Expanded(
            child: AsyncValueWidget(
              value: controller,
              data: (data) {
                if (data.isEmpty) {
                  return const Center(
                    child: Column(
                      children: [
                        Spacer(),
                        Icon(
                          Icons.receipt_long_outlined,
                          color: Colors.blueGrey,
                          size: 150,
                        ),
                        Text('No data available'),
                        Spacer(),
                      ],
                    ),
                  );
                }
                final totalAmount = data.fold<double>(
                  0,
                  (previousValue, element) => previousValue + element.amount,
                );

                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      ExpenseBarChart(expenses: data),
                      const SizedBox(height: 16),

                      Text(
                        '\$${totalAmount.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Expense List
                      Expanded(
                        child: ListView.builder(
                          itemCount: data.length,
                          itemBuilder: (context, index) {
                            final expense = data[index];

                            return ExpenseTile(expense: expense);
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
