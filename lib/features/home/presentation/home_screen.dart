import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spendwise/features/home/presentation/controller/home_controller.dart';
import 'package:spendwise/features/home/presentation/widgets/expense_bar_chart.dart';
import 'package:spendwise/features/home/presentation/widgets/expense_tile.dart';
import 'package:spendwise/widget/async_value_widget.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final controller = ref.watch(homeControllerProvider);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => ref
            .read(homeControllerProvider.notifier)
            .navigateToAddExpense(context),
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        centerTitle: false,
        title: Row(
          children: [
            Icon(
              Icons.savings_rounded,
              // size: Dimensions.padding * 30,
              color: colorScheme.primary,
            ),
            const SizedBox(width: 16),
            const Text('All Expenses'),
            const Spacer(),
            IconButton(
              onPressed: () => ref
                  .read(homeControllerProvider.notifier)
                  .navigateToDateWiseExpenseScreen(context),
              icon: const Icon(Icons.calendar_month_outlined),
            ),
            IconButton(
              onPressed: () => ref
                  .read(homeControllerProvider.notifier)
                  .navigateToInvalidExpenseScreen(context),
              icon: const Icon(Icons.receipt_long),
            ),
          ],
        ),
        automaticallyImplyLeading: false,
      ),
      body: AsyncValueWidget(
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
                  Text('No Expenses'),
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

                      return ExpenseTile(
                        expense: expense,
                        onTap: () {
                          ref
                              .read(homeControllerProvider.notifier)
                              .navigateToAddExpense(context, expense: expense);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
