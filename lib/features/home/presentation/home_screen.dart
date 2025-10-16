import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spendwise/core/constants/image_constant.dart';
import 'package:spendwise/core/constants/string_constants.dart';
import 'package:spendwise/features/home/presentation/notifier/home_notifier.dart';
import 'package:spendwise/features/home/presentation/widgets/expense_bar_chart.dart';
import 'package:spendwise/features/home/presentation/widgets/expense_tile.dart';
import 'package:spendwise/core/widgets/async_value_widget.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  Widget build(BuildContext context) {
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
            Image.asset(ImageConstant.logo, height: 30),
            const SizedBox(width: 16),
            const Text(StringConstants.allExpense),
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
      body: RefreshIndicator(
        onRefresh: () {
          return ref.read(homeControllerProvider.notifier).fetchExpenses();
        },
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
                    Text(StringConstants.noDataAvailable),
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
                                .navigateToAddExpense(
                                  context,
                                  expense: expense,
                                );
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
      ),
    );
  }
}
