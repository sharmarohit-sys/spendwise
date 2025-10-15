import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class ExpenseModel extends Equatable {
  factory ExpenseModel.fromJson(Map<String, dynamic> json) {
    return ExpenseModel(
      id: json['id'] ?? '',

      category: json['category'] ?? '',
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      note: json['note'],
      date: json['date'],
      status: json['status'] ?? 'valid',
      timestamp: json['timestamp'] != null
          ? (json['timestamp'] as Timestamp).toDate()
          : json['date'] != null
          ? DateTime.parse(json['date'])
          : DateTime.now(),
    );
  }

  const ExpenseModel({
    required this.id,
    required this.category,
    required this.amount,
    required this.date,
    required this.status,
    required this.timestamp,
    this.note,
  });

  final String id;
  final String category;
  final double amount;
  final String? note;
  final String date;
  final String status;
  final DateTime timestamp;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category': category,
      'amount': amount,
      'note': note,
      'date': date,
      'status': status,
      'timestamp': Timestamp.fromDate(timestamp),
    };
  }

  @override
  List<Object?> get props => [
    id,

    category,
    amount,
    note,
    date,
    status,
    timestamp,
  ];
}
