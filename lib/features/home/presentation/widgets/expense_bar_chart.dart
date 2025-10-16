import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:spendwise/constants/string_constants.dart';
import 'package:spendwise/utils/firestore/domain/model/expense_model.dart';

class ExpenseBarChart extends StatelessWidget {
  const ExpenseBarChart({super.key, required this.expenses});
  final List<ExpenseModel> expenses;

  @override
  Widget build(BuildContext context) {
    final chartData = getChartData(expenses);
    final barGroups = chartData.asMap().entries.map((entry) {
      final index = entry.key;
      final data = entry.value;
      final amount = data['amount'] as double;
      final color = _getCategoryColor(data['category'] as String);

      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: amount,
            color: color,
            width: 22,
            borderRadius: BorderRadius.circular(0),
          ),
        ],
      );
    }).toList();

    return Container(
      height: 150,
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(16),
      ),
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          borderData: FlBorderData(show: false),
          gridData: const FlGridData(show: false),
          titlesData: const FlTitlesData(
            leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          barGroups: barGroups,
          barTouchData: BarTouchData(enabled: false),
        ),
      ),
    );
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

  List<Map<String, dynamic>> getChartData(List<ExpenseModel> expenses) {
    final Map<String, double> groupedData = {};

    for (final expense in expenses) {
      groupedData.update(
        expense.category,
        (value) => value + expense.amount,
        ifAbsent: () => expense.amount,
      );
    }

    return groupedData.entries
        .map((entry) => {'category': entry.key, 'amount': entry.value})
        .toList();
  }
}
