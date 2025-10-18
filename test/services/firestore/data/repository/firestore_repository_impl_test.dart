// ignore_for_file: subtype_of_sealed_class

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spendwise/core/services/firestore/data/repository/firestore_repository_impl.dart';
import 'package:spendwise/core/services/firestore/domain/model/expense_model.dart';
import 'package:spendwise/core/utils/local_storage.dart';

class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}

class MockCollectionReference extends Mock
    implements CollectionReference<Map<String, dynamic>> {}

class MockDocumentReference extends Mock
    implements DocumentReference<Map<String, dynamic>> {}

class MockQuerySnapshot extends Mock
    implements QuerySnapshot<Map<String, dynamic>> {}

class MockQueryDocumentSnapshot extends Mock
    implements QueryDocumentSnapshot<Map<String, dynamic>> {}

class MockLocalStorage extends Mock implements LocalStorage {}

void main() {
  late FirestoreRepositoryImpl repository;
  late MockFirebaseFirestore mockFirestore;
  late MockCollectionReference mockCollection;
  late MockDocumentReference mockDoc;
  late MockQuerySnapshot mockSnapshot;
  late MockQueryDocumentSnapshot mockQueryDoc;
  late MockLocalStorage mockLocalStorage;

  setUp(() {
    mockFirestore = MockFirebaseFirestore();
    mockCollection = MockCollectionReference();
    mockDoc = MockDocumentReference();
    mockSnapshot = MockQuerySnapshot();
    mockQueryDoc = MockQueryDocumentSnapshot();
    mockLocalStorage = MockLocalStorage();

    repository = FirestoreRepositoryImpl(mockFirestore, mockLocalStorage);

    repository.collectionName = 'expensesTest';
    repository.email = 'test@example.com';
  });

  group('FirestoreRepositoryImpl', () {
    test('addExpense adds document and updates id', () async {
      final expense = ExpenseModel(
        id: '1',
        category: 'Coffee',
        amount: 5.0,
        date: DateTime.now().toIso8601String(),
        status: 'valid',
        timestamp: DateTime.now(),
      );

      when(() => mockFirestore.collection(any())).thenReturn(mockCollection);
      when(() => mockCollection.add(any())).thenAnswer((_) async => mockDoc);
      when(() => mockDoc.id).thenReturn('mock_doc_id');
      when(() => mockDoc.update(any())).thenAnswer((_) async {});

      final result = await repository.addExpense(expense: expense);

      expect(result, true);
      verify(() => mockCollection.add(expense.toJson())).called(1);
      verify(() => mockDoc.update({'id': 'mock_doc_id'})).called(1);
    });

    test('editExpense updates document', () async {
      final expense = ExpenseModel(
        id: '1',
        category: 'Groceries',
        amount: 5.0,
        date: DateTime.now().toIso8601String(),
        status: 'valid',
        timestamp: DateTime.now(),
      );

      when(() => mockFirestore.collection(any())).thenReturn(mockCollection);
      when(() => mockCollection.doc(any())).thenReturn(mockDoc);
      when(() => mockDoc.update(any())).thenAnswer((_) async {});

      final result = await repository.editExpense(
        expenseId: '123',
        expense: expense,
      );

      expect(result, true);
      verify(() => mockCollection.doc('123')).called(1);
      verify(() => mockDoc.update(expense.toJson())).called(1);
    });

    test('deleteExpense deletes document', () async {
      when(() => mockFirestore.collection(any())).thenReturn(mockCollection);
      when(() => mockCollection.doc(any())).thenReturn(mockDoc);
      when(() => mockDoc.delete()).thenAnswer((_) async {});

      final result = await repository.deleteExpense(expenseId: '123');

      expect(result, true);
      verify(() => mockDoc.delete()).called(1);
    });

    test('getExpensesByUser returns list of expenses', () async {
      final data = {
        'id': '1',
        'category': 'Coffee',
        'amount': 20.0,
        'date': DateTime.now().toIso8601String(),
        'status': 'valid',
      };

      when(() => mockFirestore.collection(any())).thenReturn(mockCollection);
      when(
        () => mockCollection.where('status', isEqualTo: 'valid'),
      ).thenReturn(mockCollection);
      when(() => mockCollection.get()).thenAnswer((_) async => mockSnapshot);
      when(() => mockSnapshot.docs).thenReturn([mockQueryDoc]);
      when(() => mockQueryDoc.data()).thenReturn(data);

      final result = await repository.getExpensesByUser();

      expect(result, isA<List<ExpenseModel>>());
      expect(result.first.category, 'Coffee');
      verify(() => mockCollection.get()).called(1);
    });

    test('getInvalidExpenses returns list of invalid expenses', () async {
      final data = {
        'id': '2',
        'title': 'Refund',
        'amount': 50.0,
        'date': DateTime.now().toIso8601String(),
        'status': 'invalid',
      };

      when(() => mockFirestore.collection(any())).thenReturn(mockCollection);
      when(
        () => mockCollection.where('status', isEqualTo: 'invalid'),
      ).thenReturn(mockCollection);
      when(() => mockCollection.get()).thenAnswer((_) async => mockSnapshot);
      when(() => mockSnapshot.docs).thenReturn([mockQueryDoc]);
      when(() => mockQueryDoc.data()).thenReturn(data);

      final result = await repository.getInvalidExpenses();

      expect(result.first.status, 'invalid');
      verify(() => mockCollection.get()).called(1);
    });
  });
}
