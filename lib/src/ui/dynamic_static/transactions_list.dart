// ignore_for_file: prefer_typing_uninitialized_variables, must_be_immutable

import 'package:craft_dynamic/craft_dynamic.dart';
import 'package:craft_dynamic/src/network/dynamic_request.dart';
import 'package:flutter/material.dart';

class TransactionList extends StatefulWidget {
  TransactionList({Key? key, required this.moduleItem}) : super(key: key);
  ModuleItem moduleItem;

  @override
  State<TransactionList> createState() => _TransactionListState();
}

class _TransactionListState extends State<TransactionList> {
  List<Transaction> transactionList = [];
  final _dynamicRequest = DynamicFormRequest();

  @override
  void initState() {
    super.initState();
    DynamicInput.formInputValues.clear();
    DynamicInput.formInputValues.addAll({"HEADER": "GETTRXLIST"});
  }

  getTransactionList() => _dynamicRequest.dynamicRequest(widget.moduleItem,
      dataObj: DynamicInput.formInputValues,
      encryptedField: DynamicInput.encryptedField,
      context: context,
      listType: ListType.TransactionList);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: 35,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
            child: Card(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.zero,
              ),
              color: const Color.fromARGB(255, 0, 80, 170),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 15),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Image(
                        image: AssetImage("assets/images/back_arrow.png"),
                        width: 25,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        widget.moduleItem?.moduleName ?? "",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          fontFamily: "Myriad Pro",
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(width: 25),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
              child: Container(
                color: const Color.fromARGB(255, 219, 220, 221),
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: FutureBuilder<DynamicResponse?>(
                  future: getTransactionList(),
                  builder: (BuildContext context,
                      AsyncSnapshot<DynamicResponse?> snapshot) {
                    Widget widget = Center(child: LoadUtil());

                    if (snapshot.hasData) {
                      var list = snapshot.data?.dynamicList;
                      if (list != null && list.isNotEmpty) {
                        addTransactions(list: list);
                        widget = ListView.separated(
                          itemCount: transactionList.length,
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          itemBuilder: (context, index) {
                            return TransactionItem(
                                transaction: transactionList[index]);
                          },
                          separatorBuilder: (BuildContext context, int index) =>
                          const SizedBox(
                            height: 8,
                          ),
                        );
                      } else {
                        widget = const EmptyUtil();
                      }
                    }
                    return widget;
                  },
                ),
              )
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  addTransactions({required list}) {
    list.forEach((item) {
      transactionList.add(Transaction.fromJson(item));
    });
  }
}

class TransactionItem extends StatelessWidget {
  Transaction transaction;

  TransactionItem({Key? key, required this.transaction}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.only(left: 5, top: 8, right: 5, bottom: 0),
        child: Material(
            elevation: 1.5,
            borderRadius: BorderRadius.zero,
            child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: IntrinsicHeight(
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  height: 12,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      transaction.serviceName,
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: "Myriad Pro",
                                          color: APIService.appPrimaryColor),
                                    ),
                                    Text(
                                      transaction.status,
                                      style: TextStyle(
                                        fontFamily: "Myriad Pro",
                                        color: transaction.status == "FAIL"
                                            ? Colors.red
                                            : Colors.green,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 12,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Text("Date",
                                            style: TextStyle(
                                              color: Colors.grey,
                                            ),),
                                          Text(
                                            transaction.date,
                                            style: const TextStyle(
                                                color: const Color.fromARGB(255, 0, 80, 170),
                                                fontFamily: "Myriad Pro",
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ]),
                                    Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Text("Amount",
                                            style: TextStyle(
                                                color: Colors.grey
                                            ),),
                                          Text(transaction.amount,
                                              style: const TextStyle(
                                                  color: const Color.fromARGB(255, 0, 80, 170),
                                                  fontFamily: "Myriad Pro",
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.bold))
                                        ])
                                  ],
                                ),
                                const SizedBox(
                                  height: 12,
                                )
                              ],
                            )),
                      ],
                    )))));
  }
}

class Transaction {
  String bankAccountID;
  String status;
  String serviceName;
  String date;
  String amount;

  Transaction(
      {required this.bankAccountID,
        required this.status,
        required this.serviceName,
        required this.date,
        required this.amount});

  Transaction.fromJson(Map<String, dynamic> json)
      : bankAccountID = json["BankAccountID"],
        status = json["Status"],
        serviceName = json["ServiceName"],
        date = json["Date"],
        amount = json["Amount"];
}
