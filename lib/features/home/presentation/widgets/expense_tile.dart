import 'package:flutter/material.dart';
import 'package:spendwise/utils/firestore/domain/expense_model.dart';

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
          '${date.day}/${date.month}/${date.year}',
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
      case 'food':
        return Icons.restaurant;
      case 'travel':
        return Icons.flight;
      case 'shopping':
        return Icons.shopping_bag;
      case 'coffee':
        return Icons.local_cafe;
      default:
        return Icons.attach_money;
    }
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'food':
        return Colors.blue;
      case 'travel':
        return Colors.deepOrange;
      case 'shopping':
        return Colors.orangeAccent;
      case 'coffee':
        return Colors.purple;
      default:
        return Colors.green;
    }
  }
}
