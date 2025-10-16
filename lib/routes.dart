import 'package:flutter/material.dart';
import 'package:spendwise/core/services/firestore/domain/model/expense_model.dart';
import 'package:spendwise/features/add_expense/presentation/add_expense_screen.dart';
import 'package:spendwise/features/authentication/presentation/login_screen.dart';
import 'package:spendwise/features/authentication/presentation/register_screen.dart';
import 'package:spendwise/features/date_wise_expense.dart/presentation/date_wise_expense.dart';
import 'package:spendwise/features/home/presentation/home_screen.dart';
import 'package:spendwise/features/invalid_expense/presentation/invalid_expense_screen.dart';
import 'package:spendwise/features/splash/splash_screen.dart';

class Routes {
  static const String splashScreen = '/splash';
  static const String loginScreen = '/login';
  static const String registerScreen = '/register';
  static const String homeScreen = '/home';
  static const String addExpenseScreen = '/add-expense';
  static const String invalidExpenseScreen = '/invalid-expense';
  static const String dateWiseExpenseScreen = '/date-wise-expense';

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splashScreen:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case loginScreen:
        return MaterialPageRoute(builder: (_) => LoginScreen());
      case registerScreen:
        return MaterialPageRoute(builder: (_) => RegisterScreen());
      case homeScreen:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case addExpenseScreen:
        final expenseModel = settings.arguments as ExpenseModel?;
        return MaterialPageRoute(
          builder: (_) => AddExpenseScreen(expenseModel: expenseModel),
        );
      case invalidExpenseScreen:
        return MaterialPageRoute(builder: (_) => const InvalidExpenseScreen());
      case dateWiseExpenseScreen:
        return MaterialPageRoute(builder: (_) => const DateWiseExpense());
      default:
        return null;
    }
  }
}
