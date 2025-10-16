import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spendwise/features/date_wise_expense.dart/presentation/notifier/date_wise_expense_notifier.dart';
import 'package:spendwise/utils/firestore/data/firestore_repository_impl.dart';
import 'package:spendwise/utils/firestore/domain/expense_model.dart';

class MockFirestoreRepositoryImpl extends Mock
    implements FirestoreRepositoryImpl {}

void main() {
  late MockFirestoreRepositoryImpl mockRepository;
  late DateWiseExpenseNotifier controller;

  setUp(() {
    mockRepository = MockFirestoreRepositoryImpl();
    controller = DateWiseExpenseNotifier(mockRepository);
  });

  final expense1 = ExpenseModel(
    id: '1',
    amount: 100,
    date: '2025-10-15T10:00:00Z',
    category: 'Food',
    status: 'valid',
    timestamp: DateTime.now(),
  );

  final expense2 = ExpenseModel(
    id: '2',
    amount: 100,
    date: '2025-10-15T10:00:00Z',
    category: 'Shopping',
    status: 'valid',
    timestamp: DateTime.now(),
  );

  final expense3 = ExpenseModel(
    id: '1',
    amount: 100,
    date: '2025-10-15T10:00:00Z',
    category: 'Coffee',
    status: 'valid',
    timestamp: DateTime.now(),
  );

  group('DateWiseExpenseControllerNew', () {
    test('fetchDateWiseExpenses updates state with today expenses', () async {
      // Arrange
      when(
        () => mockRepository.getExpensesByDate(any()),
      ).thenAnswer((_) async => [expense1, expense2, expense3]);

      // Act
      await controller.fetchDateWiseExpenses(DateTime(2025, 10, 15));

      // Assert
      // expect(controller.state, false);
      expect(controller.state.value, isA<List<ExpenseModel>>());
      expect(controller.state.value!.length, 3);
      expect(controller.state.value!.first, expense1); // sorted descending
      expect(controller.state.value!.last, expense3);
    });

    test('fetchDateWiseExpenses sets error state on exception', () async {
      // Arrange
      when(
        () => mockRepository.getExpensesByDate(any()),
      ).thenThrow(Exception('Failed to fetch'));

      // Act
      await controller.fetchDateWiseExpenses(DateTime(2025, 10, 15));

      // Assert
      // expect(controller.state.hasError, true);
      expect(controller.state.error, isA<Exception>());
    });
  });
}
