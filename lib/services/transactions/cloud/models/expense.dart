import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Expense extends Equatable {
  final Timestamp date;
  final double amount;
  final String category;
  final String paymentMode;
  final String? details;
  final String? type;

  const Expense({
    required this.date,
    required this.amount,
    required this.category,
    required this.paymentMode,
    this.details,
    this.type,
  });

  factory Expense.fromJson(Map<String, dynamic> json) {
    return Expense(
      date: json['date'],
      amount: double.parse(json['amount'].toString()),
      category: json['category'],
      paymentMode: json['paymentMode'],
      details: json['details'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'date': date,
      'amount': amount,
      'category': category,
      'paymentMode': paymentMode,
      'details': details,
    };
  }

  @override
  List<Object?> get props => [
        date,
        amount,
        category,
        paymentMode,
        details,
      ];
}

class MM extends Equatable {
  final Map<bool, Expense> a;
  MM({required this.a});
  @override
  List<Object?> get props => [a];
}
