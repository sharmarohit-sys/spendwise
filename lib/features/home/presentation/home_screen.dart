import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spendwise/core/constants/image_constant.dart';
import 'package:spendwise/core/constants/string_constants.dart';
import 'package:spendwise/core/services/firestore/domain/model/expense_model.dart';
import 'package:spendwise/features/home/presentation/notifier/home_notifier.dart';
import 'package:spendwise/features/home/presentation/widgets/expense_bar_chart.dart';
import 'package:spendwise/features/home/presentation/widgets/expense_tile.dart';
import 'package:spendwise/core/widgets/async_value_widget.dart';
import 'package:spendwise/routes.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToAddExpense(context),
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
              onPressed: () => _navigateToDateWiseExpenseScreen(context),
              icon: const Icon(Icons.calendar_month_outlined),
            ),
            IconButton(
              onPressed: () => _navigateToInvalidExpenseScreen(context),
              icon: const Icon(Icons.receipt_long),
            ),
          ],
        ),
        automaticallyImplyLeading: false,
      ),
      body: Consumer(
        builder: (context, ref, child) {
          final controller = ref.watch(homeControllerProvider);
          return RefreshIndicator(
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
                              onTap: () => _navigateToAddExpense(
                                context,
                                expense: expense,
                              ),
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
        },
      ),
    );
  }

  void _navigateToAddExpense(
    BuildContext context, {
    ExpenseModel? expense,
  }) async =>
      await Navigator.pushNamed(
        context,
        Routes.addExpenseScreen,
        arguments: expense,
      ).then(
        (value) => value != null
            ? ref.read(homeControllerProvider.notifier).fetchExpenses()
            : null,
      );

  void _navigateToInvalidExpenseScreen(BuildContext context) =>
      Navigator.pushNamed(context, Routes.invalidExpenseScreen);

  void _navigateToDateWiseExpenseScreen(BuildContext context) =>
      Navigator.pushNamed(context, Routes.dateWiseExpenseScreen);
}
