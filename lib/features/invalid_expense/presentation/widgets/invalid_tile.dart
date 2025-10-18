import 'package:flutter/material.dart';
import 'package:spendwise/core/constants/string_constants.dart';
import 'package:spendwise/core/services/firestore/domain/model/expense_model.dart';
import 'package:spendwise/core/utils/category_helper.dart';

class InvalidTile extends StatelessWidget {
  const InvalidTile({super.key, required this.expense});

  final ExpenseModel expense;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusGeometry.circular(8),
        side: BorderSide(color: CategoryHelper.color(expense.category)),
      ),
      leading: Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: CategoryHelper.color(expense.category),
        ),
        child: Icon(CategoryHelper.icon(expense.category), color: Colors.white),
      ),
      title: Text(expense.category),
      subtitle: Text(
        '\$${expense.amount}',
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
      trailing: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
  }
}
