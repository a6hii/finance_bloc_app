import 'package:finance_management/constants/enums.dart';
import 'package:finance_management/views/home/widgets/transaction_widgets.dart';
import 'package:finance_management/services/transactions/bloc/fetch_transactions_bloc.dart';
import 'package:finance_management/services/transactions/cloud/models/transaction_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:finance_management/config/route_names.dart';
import 'package:finance_management/services/auth/auth_service.dart';
import 'package:finance_management/services/auth/bloc/auth_bloc.dart';
import 'package:finance_management/services/auth/bloc/auth_event.dart';
import 'package:finance_management/utilities/dialogs/logout_dialog.dart';
import 'package:flutter_bloc/flutter_bloc.dart' show BlocBuilder, ReadContext;

class HomeTransactionsView extends StatefulWidget {
  const HomeTransactionsView({Key? key}) : super(key: key);

  @override
  _HomeTransactionsViewState createState() => _HomeTransactionsViewState();
}

class _HomeTransactionsViewState extends State<HomeTransactionsView> {
  // late FetchTransactionsBloc bloc;
  String get userId => AuthService.firebase().currentUser!.id;
  DateTime? endDate;
  DateTime? startDate; //Get DateTime of 1st day of Month
  @override
  void initState() {
    endDate = DateTime.now();
    startDate = DateTime(endDate!.year, endDate!.month, 1);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    context
        .read<FetchTransactionsBloc>()
        .add(FetchTransactionEvent(userId, startDate!, endDate!));
    return Scaffold(
      appBar: AppBar(
        title: Text("Hi ${FirebaseAuth.instance.currentUser?.displayName}"),
        actions: [
          // IconButton(
          //   onPressed: () {
          //     // TODo: Implement refresh
          //   },
          //   icon: const Icon(Icons.refresh),
          // ),
          PopupMenuButton<MenuAction>(
            onSelected: (value) async {
              switch (value) {
                case MenuAction.logout:
                  final shouldLogout = await showLogOutDialog(context);
                  if (shouldLogout && context.mounted) {
                    context.read<AuthBloc>().add(
                          const AuthEventLogOut(),
                        );
                  }
              }
            },
            itemBuilder: (context) {
              return [
                const PopupMenuItem<MenuAction>(
                  value: MenuAction.logout,
                  child: Text("Logout"),
                ),
              ];
            },
          )
        ],
      ),
      body: BlocBuilder<FetchTransactionsBloc, FetchTransactionsState>(
        builder: (context, state) {
          if (state is FetchTransactionsInitialState) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is TransactionsLoaded) {
            final transactionsStream = state.data;
            return StreamBuilder<Iterable<TransactionModel>>(
                stream: transactionsStream,
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                    case ConnectionState.active:
                      if (snapshot.hasData) {
                        print(
                            "dataa:: ${snapshot.data}\n lenght: ${snapshot.data?.length}");
                        final transactions =
                            snapshot.data != null && snapshot.data!.isNotEmpty
                                ? snapshot.data?.first
                                : null;

                        final totalTransactions = transactions != null
                            ? (transactions.expenses?.length ?? 0) +
                                (transactions.income?.length ?? 0)
                            : 0;

                        final listExpenses =
                            snapshot.data != null && snapshot.data!.isNotEmpty
                                ? snapshot.data!.map((e) {
                                    return e.expenses;
                                  }).first
                                : null;

                        final totalExpenses = listExpenses?.fold<double>(
                                0,
                                (previousValue, element) =>
                                    previousValue + element.amount) ??
                            0;

                        final listIncome =
                            snapshot.data != null && snapshot.data!.isNotEmpty
                                ? snapshot.data!.map((e) {
                                    return e.income;
                                  }).first
                                : null;
                        final totalIncome = listIncome?.fold<double>(
                                0,
                                (previousValue, element) =>
                                    previousValue + element.amount) ??
                            0;

                        return TransactionWidgets(
                          transactions: transactions,
                          totalTransactions: totalTransactions,
                          totalExpenses: totalExpenses,
                          totalIncome: totalIncome,
                          onTap: () {
                            Navigator.of(context)
                                .pushNamed(addOrUpdateTransaction,
                                    arguments: transactions)
                                .then((value) {
                              if (value == true) {
                                final endDate = DateTime.now();
                                final startDate =
                                    DateTime(endDate.year, endDate.month, 1);
                                context.read<FetchTransactionsBloc>().add(
                                    FetchTransactionEvent(
                                        userId, startDate, endDate));
                              }
                            });
                          },
                        );
                      } else {
                        return const Center(child: CircularProgressIndicator());
                      }
                    default:
                      return const Center(child: CircularProgressIndicator());
                  }
                });
          } else if (state is FetchTransactionsError) {
            return Center(
              child: Text('Failed to load transactions: ${state.error}'),
            );
          }
          return Container(); // Placeholder widget
        },
      ),
    );
  }
}
