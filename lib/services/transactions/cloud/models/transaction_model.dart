import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:finance_management/services/transactions/cloud/models/expense.dart';

enum TransactionType { expense, income }

class TransactionModel extends Equatable {
  final String? documentId;
  final List<Expense>? expenses;
  final List<Expense>? income;
  final double? currentBalance;
  // final MonthlyBudget? monthlyBudget;
  final String uid;
  final TransactionType? type;
  final Timestamp? date;

  const TransactionModel({
    this.documentId,
    this.expenses,
    this.income,
    this.currentBalance,
    // this.monthlyBudget,
    required this.uid,
    this.type,
    this.date,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    List<Expense>? expenses = (json['expenses'] as List<dynamic>?)
        ?.map((e) => Expense.fromJson(e))
        .toList();
    List<Expense>? income = (json['income'] as List<dynamic>?)
        ?.map((e) => Expense.fromJson(e))
        .toList();
    double? currentBalance = json['current_balance'] as double?;

    return TransactionModel(
      expenses: expenses,
      income: income,
      currentBalance: currentBalance,
      // monthlyBudget: json["monthly_budget"] != null
      //     ? MonthlyBudget.fromJson(json["monthly_budget"])
      //     : json["monthly_budget"],
      uid: json['user_id'],
      date: json['date'],
    );
  }

  factory TransactionModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final Map<String, dynamic> data = snapshot.data() ?? {};

    List<Expense>? expenses = (data['expenses'] as List<dynamic>?)
        ?.map((e) => Expense.fromJson(e))
        .toList();
    List<Expense>? income = (data['income'] as List<dynamic>?)
        ?.map((e) => Expense.fromJson(e))
        .toList();
    double? currentBalance = data['current_balance'] as double?;
    // MonthlyBudget? monthlyBudget = (data['monthly_budget'] as MonthlyBudget?);
    String uid = data['user_id'] as String? ?? '';
    Timestamp date =
        data['date'] != null ? data['date'] as Timestamp : Timestamp.now();

    return TransactionModel(
      documentId: snapshot.id,
      expenses: expenses,
      income: income,
      currentBalance: currentBalance,
      // monthlyBudget: monthlyBudget,
      uid: uid,
      date: date,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'expenses':
          expenses != null ? expenses?.map((e) => e.toMap()).toList() : {},
      'income': income != null ? income?.map((e) => e.toMap()).toList() : {},
      'current_balance': currentBalance ?? {},
      // 'monthly_budget': monthlyBudget?.toMap(),
      'user_id': uid,
      'date': date,
    };
  }

  TransactionModel copyWith({
    String? documentId,
    List<Expense>? expenses,
    List<Expense>? income,
    double? currentBalance,
    String? uid,
    TransactionType? type,
    Timestamp? date,
  }) {
    return TransactionModel(
      documentId: documentId ?? this.documentId,
      expenses: expenses ?? this.expenses,
      income: income ?? this.income,
      currentBalance: currentBalance ?? this.currentBalance,
      uid: uid ?? this.uid,
      type: type ?? this.type,
      date: date ?? this.date,
    );
  }

  @override
  List<Object?> get props => [
        expenses,
        income,
        currentBalance,
        // monthlyBudget,
        uid,
        type,
        date,
      ];
}
