import 'package:dartx/dartx.dart';
import 'package:finance_management/views/create_update_transaction/constants/constants.dart';
import 'package:finance_management/views/create_update_transaction/services/get_date_time.dart';
import 'package:finance_management/services/transactions/cloud/models/expense.dart';
import 'package:finance_management/services/transactions/cloud/models/transaction_model.dart';
import 'package:flutter/material.dart';
import 'package:finance_management/services/auth/auth_service.dart';
import 'package:finance_management/utilities/generics/get_arguments.dart';
import 'package:finance_management/services/transactions/cloud/firebase_cloud_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class TransactionTypeSelectionCubit extends Cubit<TransactionType> {
  TransactionTypeSelectionCubit() : super(TransactionType.expense);

  void toggleTransactionType(TransactionType button) => emit(button);
}

class CreateUpdateTransactionView extends StatefulWidget {
  const CreateUpdateTransactionView({Key? key}) : super(key: key);

  @override
  _CreateUpdateTransactionViewState createState() =>
      _CreateUpdateTransactionViewState();
}

class _CreateUpdateTransactionViewState
    extends State<CreateUpdateTransactionView> {
  TransactionModel? _transaction;
  late final FirebaseCloudStorage _transactionService;
  late final TextEditingController _dateController;
  late final TextEditingController _amountController;
  late final TextEditingController _categoryController;
  late final TextEditingController _paymentModeController;
  late final TextEditingController _detailsController;
  String paymentModeValue = 'Cash';

  @override
  void initState() {
    _transactionService = FirebaseCloudStorage();
    _dateController = TextEditingController();
    _amountController = TextEditingController();
    _categoryController = TextEditingController();
    _paymentModeController = TextEditingController();
    _detailsController = TextEditingController();
    super.initState();
  }

  Future<TransactionModel> createOrGetExistingTransaction(
      BuildContext context) async {
    //Get transaction from arguments
    final widgetTransaction = context.getArgument<TransactionModel>();
    final existingTransaction = context.getArgument<Map<bool, Expense>>();

    if (widgetTransaction != null) {
      _transaction = widgetTransaction;
      _dateController.text = DateFormat('dd/MM/yyyy')
          .format(widgetTransaction.date?.toDate() ?? DateTime.now());

      _categoryController.text = "Others";
      _paymentModeController.text = "Cash";

      context.read<TransactionTypeSelectionCubit>().toggleTransactionType(
          widgetTransaction.type?.name == TransactionType.expense.name
              ? TransactionType.expense
              : widgetTransaction.type?.name == TransactionType.income.name
                  ? TransactionType.income
                  : TransactionType.expense);
      return widgetTransaction;
    }
    if (existingTransaction != null) {
      if (existingTransaction.keys.first) {
        context
            .read<TransactionTypeSelectionCubit>()
            .toggleTransactionType(TransactionType.expense);
      } else {
        context
            .read<TransactionTypeSelectionCubit>()
            .toggleTransactionType(TransactionType.income);
      }
      _amountController.text =
          existingTransaction.values.first.amount.toString();
      _dateController.text = DateFormat('dd/MM/yyyy')
          .format(existingTransaction.values.first.date.toDate());
      _categoryController.text = existingTransaction.values.first.category;
      _paymentModeController.text =
          existingTransaction.values.first.paymentMode;
      _detailsController.text =
          existingTransaction.values.first.details ?? _detailsController.text;
    }

    final currentUser = AuthService.firebase().currentUser!;
    final userId = currentUser.id;
    final newTransaction = TransactionModel(uid: userId);
    _dateController.text = DateFormat('dd/MM/yyyy').format(DateTime.now());
    _categoryController.text = "Others";
    _paymentModeController.text = "Cash";

    return newTransaction;
  }

  @override
  void dispose() {
    _dateController.dispose();
    _amountController.dispose();
    _categoryController.dispose();
    _paymentModeController.dispose();
    _detailsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Add Transaction",
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.only(right: 16, left: 16),
          child: FutureBuilder(
            future: createOrGetExistingTransaction(context),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.done:
                  return BlocBuilder<TransactionTypeSelectionCubit,
                      TransactionType>(builder: (context, state) {
                    return Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        const SizedBox(
                          height: 24,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () {
                                context
                                    .read<TransactionTypeSelectionCubit>()
                                    .toggleTransactionType(
                                        TransactionType.expense);
                              },
                              child: Container(
                                width: MediaQuery.sizeOf(context).width * 0.44,
                                height: 36,
                                decoration: BoxDecoration(
                                  color: state == TransactionType.expense
                                      ? Colors.blue
                                      : Colors.white38,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Center(child: Text("Expense")),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                context
                                    .read<TransactionTypeSelectionCubit>()
                                    .toggleTransactionType(
                                        TransactionType.income);
                              },
                              child: Container(
                                width: MediaQuery.sizeOf(context).width * 0.44,
                                height: 36,
                                decoration: BoxDecoration(
                                  color: state == TransactionType.income
                                      ? Colors.blue
                                      : Colors.white38,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Center(child: Text("Income")),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 24,
                        ),
                        Row(
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(right: 10),
                              child: Icon(
                                Icons.calendar_month,
                                color: Colors.white,
                              ),
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: () async {
                                  await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(DateTime.now().year,
                                        DateTime.now().month, 1),
                                    lastDate: DateTime.now(),
                                  ).then(
                                    (value) => value != null
                                        ? _dateController.text =
                                            DateFormat('dd/MM/yyyy')
                                                .format(value)
                                        : _dateController.text,
                                  );
                                },
                                child: TextField(
                                  controller: _dateController,
                                  enabled: false,
                                  style:
                                      Theme.of(context).textTheme.displaySmall,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide.none),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        //Amount
                        Padding(
                          padding: const EdgeInsets.only(top: 20, bottom: 20),
                          child: Row(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(right: 16, left: 6),
                                child: Text(
                                  '\u20B9',
                                  style:
                                      Theme.of(context).textTheme.displayMedium,
                                ),
                              ),
                              Expanded(
                                child: TextField(
                                  controller: _amountController,
                                  style:
                                      Theme.of(context).textTheme.displaySmall,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    border: const OutlineInputBorder(
                                        borderSide: BorderSide.none),
                                    labelText: 'Amount',
                                    labelStyle: Theme.of(context)
                                        .textTheme
                                        .displaySmall!
                                        .copyWith(
                                            color: Colors.white54,
                                            fontWeight: FontWeight.w400),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        //Category
                        Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: Row(
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(right: 6, left: 6),
                                child: Icon(
                                  Icons.category_outlined,
                                  color: Colors.white,
                                ),
                              ),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () async {
                                    await showModalBottomSheet(
                                        context: context,
                                        builder: (context) {
                                          return Container(
                                            height: 500,
                                            decoration: const BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(12),
                                                topRight: Radius.circular(12),
                                              ),
                                              color: Colors.black87,
                                            ),
                                            child: GridView.builder(
                                                itemCount:
                                                    categories.keys.length,
                                                gridDelegate:
                                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                                        crossAxisCount: 3),
                                                itemBuilder: (context, index) {
                                                  return GestureDetector(
                                                    onTap: () {
                                                      final String text =
                                                          categories.keys
                                                              .toList()[index];

                                                      Navigator.of(context)
                                                          .pop(text);
                                                    },
                                                    child: Column(
                                                      children: [
                                                        const SizedBox(
                                                          height: 36,
                                                        ),
                                                        CircleAvatar(
                                                          backgroundColor:
                                                              Colors.black,
                                                          radius: 32,
                                                          child: Icon(
                                                            categories.values
                                                                    .toList()[
                                                                index],
                                                            color: Colors
                                                                .amberAccent,
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          height: 8,
                                                        ),
                                                        Text(categories.keys
                                                                .toList()[index]
                                                                .substring(0, 1)
                                                                .toUpperCase() +
                                                            categories.keys
                                                                .toList()[index]
                                                                .substring(1)),
                                                      ],
                                                    ),
                                                  );
                                                }),
                                          );
                                        }).then((value) {
                                      _categoryController.text = value == null
                                          ? _categoryController.text
                                          : value
                                                  .toString()
                                                  .substring(0, 1)
                                                  .toUpperCase() +
                                              value.toString().substring(1);
                                    });
                                  },
                                  child: TextField(
                                    controller: _categoryController,
                                    enabled: false,
                                    style: Theme.of(context)
                                        .textTheme
                                        .displaySmall,
                                    decoration: InputDecoration(
                                      border: const OutlineInputBorder(
                                          borderSide: BorderSide.none),
                                      labelText: 'Category',
                                      labelStyle: Theme.of(context)
                                          .textTheme
                                          .displaySmall!
                                          .copyWith(
                                              color: Colors.white54,
                                              fontWeight: FontWeight.w400),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        //PaymentMode
                        Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(right: 6, left: 6),
                                child: Icon(
                                  Icons.wallet,
                                  color: Colors.white,
                                ),
                              ),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () async {
                                    await showModalBottomSheet(
                                        context: context,
                                        builder: (context) {
                                          return Container(
                                            height: 200,
                                            decoration: const BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(12),
                                                topRight: Radius.circular(12),
                                              ),
                                              color: Colors.black87,
                                            ),
                                            child: GridView.builder(
                                                itemCount:
                                                    paymentMode.keys.length,
                                                gridDelegate:
                                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                                        crossAxisCount: 3),
                                                itemBuilder: (context, index) {
                                                  return GestureDetector(
                                                    onTap: () {
                                                      final String text =
                                                          paymentMode.keys
                                                              .toList()[index];

                                                      Navigator.of(context)
                                                          .pop(text);
                                                    },
                                                    child: Column(
                                                      children: [
                                                        const SizedBox(
                                                          height: 36,
                                                        ),
                                                        CircleAvatar(
                                                          backgroundColor:
                                                              Colors.black,
                                                          radius: 32,
                                                          child: Icon(
                                                            paymentMode.values
                                                                    .toList()[
                                                                index],
                                                            color: Colors
                                                                .amberAccent,
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          height: 8,
                                                        ),
                                                        Text(paymentMode.keys
                                                                .toList()[index]
                                                                .substring(0, 1)
                                                                .toUpperCase() +
                                                            paymentMode.keys
                                                                .toList()[index]
                                                                .substring(1)),
                                                      ],
                                                    ),
                                                  );
                                                }),
                                          );
                                        }).then((value) {
                                      _paymentModeController.text =
                                          value == null
                                              ? _paymentModeController.text
                                              : value
                                                      .toString()
                                                      .substring(0, 1)
                                                      .toUpperCase() +
                                                  value.toString().substring(1);
                                    });
                                  },
                                  child: TextField(
                                    controller: _paymentModeController,
                                    enabled: false,
                                    style: Theme.of(context)
                                        .textTheme
                                        .displaySmall,
                                    decoration: InputDecoration(
                                        border: const OutlineInputBorder(
                                            borderSide: BorderSide.none),
                                        labelText: 'Payment mode',
                                        labelStyle: Theme.of(context)
                                            .textTheme
                                            .displaySmall!
                                            .copyWith(
                                                color: Colors.white54,
                                                fontWeight: FontWeight.w400)),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(right: 16, left: 6),
                              child: Icon(
                                Icons.note_add_rounded,
                                color: Colors.white,
                              ),
                            ),
                            Expanded(
                              child: TextField(
                                controller: _detailsController,
                                style: Theme.of(context).textTheme.displaySmall,
                                decoration: InputDecoration(
                                  border: const OutlineInputBorder(
                                      borderSide: BorderSide.none),
                                  labelText: 'Other details',
                                  labelStyle: Theme.of(context)
                                      .textTheme
                                      .displaySmall!
                                      .copyWith(
                                          color: Colors.white54,
                                          fontWeight: FontWeight.w400),
                                ),
                              ),
                            ),
                          ],
                        ),

                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(18),
                            child: Align(
                              alignment: Alignment.bottomCenter,
                              child: ElevatedButton(
                                style: ButtonStyle(
                                    fixedSize: MaterialStatePropertyAll(Size(
                                        MediaQuery.sizeOf(context).width, 48))),
                                onPressed: () async {
                                  if (_amountController.text.isNullOrEmpty ||
                                      _dateController.text.isNullOrEmpty ||
                                      _categoryController.text.isNullOrEmpty ||
                                      _paymentModeController
                                          .text.isNullOrEmpty) {
                                    Fluttertoast.showToast(
                                        msg:
                                            "Please fill all neccessary details");
                                  } else {
                                    await _transactionService.addNewTransaction(
                                      docId: snapshot.data?.documentId ?? '',
                                      type: context
                                          .read<TransactionTypeSelectionCubit>()
                                          .state
                                          .name
                                          .toString(),
                                      date: getDateTime(_dateController.text),
                                      amount: _amountController.text,
                                      category: _categoryController.text,
                                      paymentMode: _paymentModeController.text,
                                    );
                                  }
                                  if (context.mounted) {
                                    Navigator.of(context).pop();
                                  }
                                },
                                child: Text(
                                  "Save",
                                  style:
                                      Theme.of(context).textTheme.displaySmall,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  });
                default:
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
              }
            },
          ),
        ));
  }
}
