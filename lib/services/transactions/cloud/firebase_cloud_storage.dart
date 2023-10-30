import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartx/dartx.dart';
import 'package:finance_management/services/auth/auth_service.dart';
import 'package:finance_management/services/transactions/cloud/cloud_storage_exceptions.dart';
import 'package:finance_management/services/transactions/cloud/models/expense.dart';
import 'package:finance_management/services/transactions/cloud/models/transaction_model.dart';

class FirebaseCloudStorage {
  final transactionsCollection =
      FirebaseFirestore.instance.collection('transactions');

  // Future<void> deleteTransaction({required String documentId}) async {
  //   try {
  //     await transactions.doc(documentId).delete();
  //   } catch (e) {
  //     throw CouldNotDeleteTransactionException();
  //   }
  // }

  Future<void> updateTransaction({
    required String documentId,
    required String amount,
    required String category,
    required String paymentMode,
    String? details,
  }) async {
    try {
      await transactionsCollection.doc(documentId).update({
        'expenses': FieldValue.arrayUnion([
          {
            'amount': amount,
            'category': category,
            'paymentMode': paymentMode,
            'details': details,
          }
        ])
      });
    } catch (e) {
      throw CouldNotUpdateTransactionsException();
    }
  }

  Stream<Iterable<TransactionModel>> getTransactionsForDuration({
    required String ownerUserId,
    required DateTime startDate,
    required DateTime endDate,
  }) {
    // Convert the DateTime objects to Firestore Timestamps
    Timestamp startTimestamp = Timestamp.fromDate(startDate);
    Timestamp endTimestamp = Timestamp.fromDate(endDate);

    final allTransactions = transactionsCollection
        .where('user_id', isEqualTo: ownerUserId)
        .where('date', isGreaterThanOrEqualTo: startTimestamp)
        .where('date', isLessThanOrEqualTo: endTimestamp)
        .snapshots()
        .map((event) =>
            event.docs.map((doc) => TransactionModel.fromSnapshot(doc)));
    print("getTransactionsForDuration");
    return allTransactions;
  }

  Future<void> addNewTransaction({
    required String docId,
    required String type,
    required DateTime date,
    required String amount,
    required String category,
    required String paymentMode,
    String? details,
  }) async {
    try {
      if (docId.isNotNullOrEmpty) {
        final existingDoc = await transactionsCollection.doc(docId).get();
        if (existingDoc.exists) {
          final currentBalance = existingDoc.get('current_balance') as double;

          // Update the balance by adding the amountToAdd
          final newBalance = type == TransactionType.income.name.toString()
              ? currentBalance + amount.toInt()
              : currentBalance - amount.toInt();
          // If the document already exists, update the existing fields
          await transactionsCollection.doc(existingDoc.id).update({
            'current_balance': newBalance,
            if (type == TransactionType.expense.name.toString())
              'expenses': FieldValue.arrayUnion([
                {
                  'amount': amount.toDouble(),
                  'category': category,
                  'paymentMode': paymentMode,
                  'details': details,
                  'date': Timestamp.fromDate(date),
                }
              ]),
            if (type == TransactionType.income.name.toString())
              'income': FieldValue.arrayUnion([
                {
                  'amount': amount.toDouble(),
                  'category': category,
                  'paymentMode': paymentMode,
                  'details': details,
                  'date': Timestamp.fromDate(date),
                }
              ]),
          });
        }
      } else {
        print("SET");

        TransactionModel transaction = TransactionModel(
          expenses: type == TransactionType.expense.name.toString()
              ? [
                  Expense(
                    date: Timestamp.fromDate(date),
                    amount: amount.toDouble(),
                    category: category,
                    paymentMode: paymentMode,
                    details: details ?? '',
                  )
                ]
              : [],
          income: type == TransactionType.income.name.toString()
              ? [
                  Expense(
                    date: Timestamp.fromDate(date),
                    amount: amount.toDouble(),
                    category: category,
                    paymentMode: paymentMode,
                    details: details ?? '',
                  )
                ]
              : [],
          currentBalance: type == TransactionType.income.name.toString()
              ? amount.toDouble()
              : (0.0 - amount.toDouble()), // Your current balance as a double

          uid: AuthService.firebase().currentUser!.id,
          date:
              Timestamp.fromDate(DateTime.now()), // Timestamp for current date
        );
        await transactionsCollection.doc(transaction.uid).set(
              transaction.toMap(),
            );
      }
    } catch (err, st) {
      print("Error :: $err \n st:: $st");
      throw Exception();
    }
  }

  static final FirebaseCloudStorage _shared =
      FirebaseCloudStorage._sharedInstance();
  FirebaseCloudStorage._sharedInstance();
  factory FirebaseCloudStorage() => _shared;
}
