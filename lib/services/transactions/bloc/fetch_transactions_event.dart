part of 'fetch_transactions_bloc.dart';

// Event
abstract class TransactionsEvent {
  final String userId;
  final DateTime startTime;
  final DateTime endTime;
  TransactionsEvent(
    this.userId,
    this.startTime,
    this.endTime,
  );
}

class FetchTransactionEvent extends TransactionsEvent {
  FetchTransactionEvent(super.userId, super.startTime, super.endTime);
}
