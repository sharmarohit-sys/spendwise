import 'package:flutter/material.dart';
import 'package:spendwise/constants/string_constants.dart';
import 'package:spendwise/utils/date_time_callback.dart';
import 'package:spendwise/utils/firestore/domain/model/expense_model.dart';

class ExpenseTile extends StatelessWidget {
  const ExpenseTile({super.key, required this.expense, this.onTap});
  final ExpenseModel expense;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    final date = DateTime.parse(expense.date);
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        leading: Container(
          height: 40,
          width: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: _getCategoryColor(expense.category),
          ),
          child: Icon(_getCategoryIcon(expense.category), color: Colors.white),
        ),
        title: Text(expense.category),
        subtitle: Text(
          DateTimeCallback.getTimeInString(date),
          // '${date.day}/${date.month}/${date.year}',
          style: const TextStyle(color: Colors.grey),
        ),
        trailing: Text(
          '\$${expense.amount}', //'\$${amount.toStringAsFixed(2)}',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        onTap: onTap,
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
