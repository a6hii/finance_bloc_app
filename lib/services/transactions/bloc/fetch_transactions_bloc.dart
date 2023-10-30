// ignore_for_file: avoid_print

import 'package:finance_management/services/transactions/cloud/firebase_cloud_storage.dart';
import 'package:finance_management/services/transactions/cloud/models/transaction_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'fetch_transactions_event.dart';
part 'fetch_transactions_state.dart';

class FetchTransactionsBloc
    extends Bloc<TransactionsEvent, FetchTransactionsState> {
  FetchTransactionsBloc() : super(FetchTransactionsInitialState()) {
    on<FetchTransactionEvent>((event, emit) async {
      emit(FetchTransactionsInitialState());
      try {
        print("trying FetchTransactionsEvent");
        final transaction = FirebaseCloudStorage().getTransactionsForDuration(
          ownerUserId: event.userId,
          startDate: event.startTime,
          endDate: event.endTime,
        );
        print("trying FetchTransactionsEvent Success::");
        emit(TransactionsLoaded(transaction));
      } catch (er, st) {
        print("Error: $er\n stackTrace: $st");
        emit(FetchTransactionsError("Failed to get transactions!"));
      }
    });
    // on<RefreshTransactionEvent>(
    //   (event, emit) {
    //     emit(FetchTransactionsInitialState());
    //     try {
    //       final transaction = FirebaseCloudStorage().getTransactionsForDuration(
    //         ownerUserId: event.userId,
    //         startDate: event.startTime,
    //         endDate: event.endTime,
    //       );

    //       emit(TransactionsLoaded(transaction));
    //     } catch (er, st) {
    //       print("Error: $er\n stackTrace: $st");
    //       emit(FetchTransactionsError("Failed to get transactions!"));
    //     }
    //   },
    // );
  }
}
