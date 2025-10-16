import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spendwise/core/constants/string_constants.dart';
import 'package:spendwise/features/invalid_expense/presentation/notifier/invalid_expense_notifier_new.dart';
import 'package:spendwise/core/widgets/async_value_widget.dart';

class InvalidExpenseScreen extends ConsumerStatefulWidget {
  const InvalidExpenseScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _InvalidExpenseScreenState();
}

class _InvalidExpenseScreenState extends ConsumerState<InvalidExpenseScreen> {
  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(invalidExpenseControllerProvider);
    return Scaffold(
      appBar: AppBar(title: const Text(StringConstants.invalidExpense)),
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

              return ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadiusGeometry.circular(8),
                  side: BorderSide(color: _getCategoryColor(expense.category)),
                ),
                leading: Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: _getCategoryColor(expense.category),
                  ),
                  child: Icon(
                    _getCategoryIcon(expense.category),
                    color: Colors.white,
                  ),
                ),
                title: Text(expense.category),
                subtitle: Text(
                  '\$${expense.amount}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                trailing: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.red.shade100,
                  ),
                  child: const Text(
                    StringConstants.invalid,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                      color: Colors.red,
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case StringConstants.food:
        return Icons.restaurant;
      case StringConstants.travel:
        return Icons.flight;
      case StringConstants.shopping:
        return Icons.shopping_bag;
      case StringConstants.coffee:
        return Icons.local_cafe;
      default:
        return Icons.attach_money;
    }
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case StringConstants.food:
        return Colors.blue;
      case StringConstants.travel:
        return Colors.deepOrange;
      case StringConstants.shopping:
        return Colors.orangeAccent;
      case StringConstants.coffee:
        return Colors.purple;
      default:
        return Colors.green;
    }
  }
}
