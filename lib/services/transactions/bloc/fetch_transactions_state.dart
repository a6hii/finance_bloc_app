part of 'fetch_transactions_bloc.dart';

// State
abstract class FetchTransactionsState {}

class FetchTransactionsInitialState extends FetchTransactionsState {}

class TransactionsLoaded extends FetchTransactionsState {
  final Stream<Iterable<TransactionModel>> data;
  TransactionsLoaded(this.data);
}

class FetchTransactionsError extends FetchTransactionsState {
  final String error;
  FetchTransactionsError(this.error);
}
