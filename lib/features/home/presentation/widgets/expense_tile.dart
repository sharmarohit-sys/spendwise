import 'package:flutter/material.dart';
import 'package:spendwise/core/utils/category_helper.dart';
import 'package:spendwise/core/utils/date_time_callback.dart';
import 'package:spendwise/core/services/firestore/domain/model/expense_model.dart';

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
            color: CategoryHelper.color(expense.category),
          ),
          child: Icon(
            CategoryHelper.icon(expense.category),
            color: Colors.white,
          ),
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
}
