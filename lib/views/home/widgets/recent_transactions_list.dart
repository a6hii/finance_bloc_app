import 'package:finance_management/config/route_names.dart';
import 'package:finance_management/services/transactions/cloud/models/expense.dart';
import 'package:finance_management/services/transactions/cloud/models/transaction_model.dart';
import 'package:flutter/material.dart';

class RecentTransactionsList extends StatelessWidget {
  const RecentTransactionsList({
    super.key,
    required this.transactions,
  });

  final TransactionModel? transactions;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Builder(builder: (context) {
        // List<Expense> allTransactions = [
        //   ...transactions?.expenses ?? [],
        //   ...transactions?.income ?? []
        // ];

        // allTransactions.sort((a, b) => a.date.compareTo(b.date));

        List<Expense> combinedList = [];

        // Combine expenses and income into a single list
        combinedList.addAll(transactions?.expenses ?? []);
        combinedList.addAll(transactions?.income ?? []);

        // Sort the combined list by date
        combinedList.sort((a, b) {
          final Expense expenseA = a;
          final Expense expenseB = b;

          final DateTime today = DateTime.now();

          final Duration differenceA = today.difference(expenseA.date.toDate());
          final Duration differenceB = today.difference(expenseB.date.toDate());

          return differenceA.compareTo(differenceB);
        });
        return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: combinedList.length,
            itemBuilder: (context, index) {
              final item = combinedList[index];
              final isExpense = transactions?.expenses?.contains(item) ?? false;

              // Differentiate expense and income by color
              final color = isExpense
                  ? const Color(0xFF222226)
                  : const Color.fromARGB(255, 51, 92, 52);
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6)),
                  tileColor: color,
                  leading: isExpense
                      ? const Icon(Icons.arrow_upward_rounded,
                          color: Colors.white)
                      : const Icon(Icons.arrow_downward_rounded,
                          color: Colors.white),
                  onTap: () {
                    Navigator.of(context).pushNamed(addOrUpdateTransaction,
                        arguments: {isExpense: item});
                  },
                  title: Text(
                    '\u20B9 ${combinedList[index].amount.toString()}',
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(combinedList[index].category,
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                              fontWeight: FontWeight.w400,
                            )),
                  ),
                ),
              );
            });
      }),
    );
  }
}
