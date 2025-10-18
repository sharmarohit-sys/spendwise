import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spendwise/core/constants/string_constants.dart';
import 'package:spendwise/features/invalid_expense/presentation/notifier/invalid_expense_notifier_new.dart';
import 'package:spendwise/core/widgets/async_value_widget.dart';
import 'package:spendwise/features/invalid_expense/presentation/widgets/invalid_tile.dart';

class InvalidExpenseScreen extends StatelessWidget {
  const InvalidExpenseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(StringConstants.invalidExpense)),
      body: Consumer(
        builder: (context, ref, child) {
          final controller = ref.watch(invalidExpenseControllerProvider);
          return AsyncValueWidget(
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
              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: data.length,
                itemBuilder: (context, index) {
                  final expense = data[index];
                  return InvalidTile(expense: expense);
                },
              );
            },
          );
        },
      ),
    );
  }
}
