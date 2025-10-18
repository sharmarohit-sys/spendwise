import 'package:flutter/material.dart';
import 'package:spendwise/core/constants/string_constants.dart';

class CategoryHelper {
  static IconData icon(String category) => _getIcon(category);
  static Color color(String category) => _getColor(category);

  static IconData _getIcon(String category) {
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

  static Color _getColor(String category) {
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
