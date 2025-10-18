import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spendwise/core/services/firestore/data/repository/firestore_repository_impl.dart';
import 'package:spendwise/core/services/firestore/domain/model/expense_model.dart';
import 'package:spendwise/core/services/firestore/domain/usecases/add_expense_usecase.dart';
import 'package:spendwise/core/services/firestore/domain/usecases/add_user_usecase.dart';
import 'package:spendwise/core/services/firestore/domain/usecases/delete_expense_usecase.dart';
import 'package:spendwise/core/services/firestore/domain/usecases/edit_expense_usecase.dart';
import 'package:spendwise/core/services/firestore/domain/usecases/get_expenses_by_date_usecase.dart';
import 'package:spendwise/core/services/firestore/domain/usecases/get_expenses_by_user_usecase.dart';
import 'package:spendwise/core/services/firestore/domain/usecases/get_invalid_expenses_usecase.dart';

class MockFirestoreRepository extends Mock implements FirestoreRepositoryImpl {}

void main() {
  late MockFirestoreRepository mockRepository;
  late AddExpenseUseCase addExpenseUseCase;
  late GetExpensesByUserUseCase getExpensesByUserUseCase;
  late GetExpensesByDateUseCase getExpensesByDateUseCase;
  late DeleteExpenseUseCase deleteExpenseUseCase;
  late EditExpenseUseCase editExpenseUseCase;
  late AddUserUseCase addUserUseCase;
  late GetInvalidExpensesUseCase getInvalidExpensesUseCase;

  setUp(() {
    mockRepository = MockFirestoreRepository();
    addExpenseUseCase = AddExpenseUseCase(mockRepository);
    getExpensesByUserUseCase = GetExpensesByUserUseCase(mockRepository);
    getExpensesByDateUseCase = GetExpensesByDateUseCase(mockRepository);
    deleteExpenseUseCase = DeleteExpenseUseCase(mockRepository);
    editExpenseUseCase = EditExpenseUseCase(mockRepository);
    addUserUseCase = AddUserUseCase(mockRepository);
    getInvalidExpensesUseCase = GetInvalidExpensesUseCase(mockRepository);
  });

  final testExpense1 = ExpenseModel(
    id: '1',
    category: 'Coffee',
    amount: 5.0,
    date: DateTime.now().toIso8601String(),
    status: 'valid',
    timestamp: DateTime.now(),
  );
  final testExpense2 = ExpenseModel(
    id: '2',
    category: 'Food',
    amount: 5.0,
    date: DateTime.now().toIso8601String(),
    status: 'valid',
    timestamp: DateTime.now(),
  );

  test('AddExpenseUseCase calls repository.addExpense', () async {
    when(
      () => mockRepository.addExpense(expense: testExpense1),
    ).thenAnswer((_) async => true);

    final result = await addExpenseUseCase.call(expense: testExpense1);

    expect(result, true);
    verify(() => mockRepository.addExpense(expense: testExpense1)).called(1);
  });

  test(
    'GetExpensesByUserUseCase calls repository.getExpensesByUser and sorts',
    () async {
      final expenses = [testExpense1, testExpense2];

      when(
        () => mockRepository.getExpensesByUser(),
      ).thenAnswer((_) async => expenses);

      final result = await getExpensesByUserUseCase.call();

      expect(result.first.date, expenses[0].date); // Latest date first
      verify(() => mockRepository.getExpensesByUser()).called(1);
    },
  );

  test('GetExpensesByDateUseCase filters expenses correctly', () async {
    final now = DateTime.now();
    final expenses = [testExpense1, testExpense2];

    when(
      () => mockRepository.getExpensesByDate(now),
    ).thenAnswer((_) async => expenses);

    final result = await getExpensesByDateUseCase.call(now);

    expect(result.every((e) => DateTime.parse(e.date).day == now.day), true);
    verify(() => mockRepository.getExpensesByDate(now)).called(1);
  });

  test('DeleteExpenseUseCase calls repository.deleteExpense', () async {
    when(
      () => mockRepository.deleteExpense(expenseId: '1'),
    ).thenAnswer((_) async => true);

    final result = await deleteExpenseUseCase.call(expenseId: '1');

    expect(result, true);
    verify(() => mockRepository.deleteExpense(expenseId: '1')).called(1);
  });

  test('EditExpenseUseCase calls repository.editExpense', () async {
    when(
      () => mockRepository.editExpense(expenseId: '1', expense: testExpense1),
    ).thenAnswer((_) async => true);

    final result = await editExpenseUseCase.call(
      expenseId: '1',
      expense: testExpense1,
    );

    expect(result, true);
    verify(
      () => mockRepository.editExpense(expenseId: '1', expense: testExpense1),
    ).called(1);
  });

  test('AddUserUseCase calls repository.addUser', () async {
    when(
      () => mockRepository.addUser(
        name: 'John',
        email: 'john@example.com',
        uId: '123',
      ),
    ).thenAnswer((_) async => true);

    final result = await addUserUseCase.call(
      name: 'John',
      email: 'john@example.com',
      uId: '123',
    );

    expect(result, true);
    verify(
      () => mockRepository.addUser(
        name: 'John',
        email: 'john@example.com',
        uId: '123',
      ),
    ).called(1);
  });

  test(
    'GetInvalidExpensesUseCase calls repository.getInvalidExpenses',
    () async {
      when(
        () => mockRepository.getInvalidExpenses(),
      ).thenAnswer((_) async => [testExpense1]);

      final result = await getInvalidExpensesUseCase.call();

      expect(result.length, 1);
      expect(result.first.status, 'valid'); // testExpense.status
      verify(() => mockRepository.getInvalidExpenses()).called(1);
    },
  );
}
