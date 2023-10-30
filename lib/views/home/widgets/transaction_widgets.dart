import 'package:finance_management/config/route_names.dart';
import 'package:finance_management/views/home/widgets/dashboard_card.dart';
import 'package:finance_management/views/home/widgets/recent_transactions_list.dart';
import 'package:finance_management/services/transactions/cloud/models/transaction_model.dart';
import 'package:flutter/material.dart';

class TransactionWidgets extends StatelessWidget {
  final TransactionModel? transactions;
  final int totalTransactions;
  final double totalExpenses;
  final double totalIncome;
  const TransactionWidgets({
    required this.transactions,
    required this.totalTransactions,
    required this.totalExpenses,
    required this.totalIncome,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: Stack(
        children: [
          SingleChildScrollView(
            child: SizedBox(
              height: MediaQuery.sizeOf(context).height,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 12, bottom: 24),
                        child: Text(
                          "This month",
                          style: Theme.of(context).textTheme.displaySmall,
                        ),
                      )),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      DashboardCard(
                        color: const Color(0xFF222226),
                        icon: const Icon(
                          Icons.balance_rounded,
                          color: Colors.white70,
                        ),
                        labelText: "Balance",
                        value: transactions?.currentBalance.toString() ?? '0',
                      ),
                      DashboardCard(
                        color: const Color(0xFF0D4362),
                        icon: const Icon(
                          Icons.compare_arrows_rounded,
                          color: Colors.white70,
                        ),
                        labelText: "Total transactions",
                        value: totalTransactions.toString(),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 18),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        DashboardCard(
                          color: const Color(0xFFCE6A78),
                          icon: const Icon(
                            Icons.arrow_upward_rounded,
                            color: Colors.white70,
                          ),
                          labelText: "Spending",
                          value: totalExpenses.toString(),
                        ),
                        DashboardCard(
                          color: const Color(0xFF437745),
                          icon: const Icon(
                            Icons.arrow_downward_rounded,
                            color: Colors.white70,
                          ),
                          labelText: "Income",
                          value: totalIncome.toString(),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 36, bottom: 26),
                    child: Text("Recent Transactions",
                        style: Theme.of(context).textTheme.displaySmall),
                  ),
                  transactions == null ||
                          (transactions?.expenses == null &&
                              transactions?.income == null)
                      ? Text(
                          "No transactions yet!",
                          style:
                              Theme.of(context).textTheme.bodySmall!.copyWith(
                                    color: Colors.white70,
                                  ),
                        )
                      : RecentTransactionsList(transactions: transactions),
                  //TODO: Add BudgetWidgets
                  // Padding(
                  //   padding:
                  //       const EdgeInsets.only(top: 40, bottom: 26),
                  //   child: Text(
                  //     "Your budget",
                  //     style:
                  //         Theme.of(context).textTheme.displaySmall,
                  //   ),
                  // ),
                  // transactions == null ||
                  //         transactions.monthlyBudget == null
                  //     ? Text(
                  //         "No budget created.",
                  //         style: Theme.of(context)
                  //             .textTheme
                  //             .bodySmall!
                  //             .copyWith(
                  //               color: Colors.white70,
                  //             ),
                  //       )
                  //     : Container(
                  //         height: 160,
                  //         width: MediaQuery.sizeOf(context).width *
                  //             0.68,
                  //         decoration: BoxDecoration(
                  //           color: const Color(0xFF222226),
                  //           borderRadius: BorderRadius.circular(4),
                  //         ),
                  //         child: Column(
                  //           crossAxisAlignment:
                  //               CrossAxisAlignment.start,
                  //           children: [
                  //             Padding(
                  //               padding: const EdgeInsets.only(
                  //                   top: 16, left: 14),
                  //               child: Text(
                  //                 "Budget left",
                  //                 style: Theme.of(context)
                  //                     .textTheme
                  //                     .displayMedium,
                  //               ),
                  //             ),
                  //             Padding(
                  //               padding: const EdgeInsets.only(
                  //                   top: 8, left: 14),
                  //               child: Text(transactions
                  //                       ?.monthlyBudget?.totalBudget
                  //                       .toString() ??
                  //                   '\$ 5555'),
                  //             ),
                  //             Builder(builder: (context) {
                  //               final ValueNotifier<double>
                  //                   progress =
                  //                   ValueNotifier((transactions!
                  //                           .monthlyBudget!
                  //                           .totalBudget) /
                  //                       (int.parse(totalExpenses)));
                  //               return ValueListenableBuilder(
                  //                   valueListenable: progress,
                  //                   builder: (context, value, _) {
                  //                     return LinearProgressIndicator(
                  //                       value: value,
                  //                       borderRadius:
                  //                           BorderRadius.circular(
                  //                               6.0),
                  //                       backgroundColor:
                  //                           const Color(0xFF363636),
                  //                       valueColor:
                  //                           const AlwaysStoppedAnimation<
                  //                               Color>(
                  //                         Colors.pink,
                  //                       ),
                  //                     );
                  //                   });
                  //             })
                  //           ],
                  //         ),
                  //       ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 44, right: 16),
              child: InkWell(
                onTap: () {
                  Navigator.of(context).pushNamed(addOrUpdateTransaction,
                      arguments: transactions);
                },
                child: const CircleAvatar(
                  backgroundColor: Colors.amberAccent,
                  child: Icon(Icons.add),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
