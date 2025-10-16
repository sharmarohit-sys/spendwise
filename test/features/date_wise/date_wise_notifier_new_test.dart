import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spendwise/features/date_wise_expense.dart/presentation/notifier/date_wise_expense_notifier.dart';
import 'package:spendwise/utils/firestore/domain/model/expense_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spendwise/utils/firestore/domain/usecases/get_expenses_by_date_usecase.dart';

// ✅ Mock use case
class MockGetExpensesByDateUseCase extends Mock
    implements GetExpensesByDateUseCase {}

void main() {
  late MockGetExpensesByDateUseCase mockUseCase;
  late DateWiseExpenseNotifier controller;

  setUp(() {
    mockUseCase = MockGetExpensesByDateUseCase();
    controller = DateWiseExpenseNotifier(mockUseCase);
  });

  final expense1 = ExpenseModel(
    id: '1',
    amount: 100,
    date: '2025-10-15T12:00:00Z',
    category: 'Food',
    status: 'valid',
    timestamp: DateTime.now(),
  );

  final expense2 = ExpenseModel(
    id: '2',
    amount: 200,
    date: '2025-10-15T15:00:00Z',
    category: 'Shopping',
    status: 'valid',
    timestamp: DateTime.now(),
  );

  final expense3 = ExpenseModel(
    id: '3',
    amount: 50,
    date: '2025-10-15T09:00:00Z',
    category: 'Coffee',
    status: 'valid',
    timestamp: DateTime.now(),
  );

  group('DateWiseExpenseNotifier', () {
    test('fetchDateWiseExpenses updates state with today expenses', () async {
      // Arrange
      when(
        () => mockUseCase.call(any()),
      ).thenAnswer((_) async => [expense1, expense2, expense3]);

      // Act
      await controller.fetchDateWiseExpenses(DateTime(2025, 10, 15));

      // Assert
      final stateValue = controller.state.value!;
      expect(stateValue, isA<List<ExpenseModel>>());
      expect(stateValue.length, 3);

      // Check sorting: latest first
      expect(stateValue.first, expense2);
      expect(stateValue[1], expense1);
      expect(stateValue.last, expense3);
    });

    test('fetchDateWiseExpenses sets error state on exception', () async {
      // Arrange
      when(
        () => mockUseCase.call(any()),
      ).thenThrow(Exception('Failed to fetch'));

      // Act
      await controller.fetchDateWiseExpenses(DateTime(2025, 10, 15));

      // Assert
      expect(controller.state.hasError, true);
      expect(controller.state.error, isA<Exception>());
    });
  });
}
