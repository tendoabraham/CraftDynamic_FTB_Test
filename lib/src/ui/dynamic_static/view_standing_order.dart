// ignore_for_file: must_be_immutable, unnecessary_const

import 'package:craft_dynamic/craft_dynamic.dart';
import 'package:craft_dynamic/src/network/dynamic_request.dart';
import 'package:craft_dynamic/src/ui/dynamic_components.dart';
import 'package:flutter/material.dart';

import '../../../dynamic_widget.dart';

class ViewStandingOrder extends StatefulWidget {
  final ModuleItem moduleItem;

  const ViewStandingOrder({required this.moduleItem, super.key});

  @override
  State<StatefulWidget> createState() => _ViewStandingOrderState();
}

class _ViewStandingOrderState extends State<ViewStandingOrder> {
  List<StandingOrder> standingOrderList = [];
  final _dynamicRequest = DynamicFormRequest();

  @override
  void initState() {
    super.initState();
    DynamicInput.formInputValues.clear();
    DynamicInput.formInputValues.add({"HEADER": "VIEWSTANDINGORDER"});
  }

  getStandingOrder() => _dynamicRequest.dynamicRequest(widget.moduleItem,
      dataObj: DynamicInput.formInputValues,
      encryptedField: DynamicInput.encryptedField,
      context: context,
      listType: ListType.ViewOrderList);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: (() {
            Navigator.of(context).pop();
          }),
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        title: Text(widget.moduleItem.moduleName),
      ),
      body: FutureBuilder<DynamicResponse?>(
          future: getStandingOrder(),
          builder:
              (BuildContext context, AsyncSnapshot<DynamicResponse?> snapshot) {
            Widget widget = Center(
              child: LoadUtil(),
            );
            if (snapshot.hasData) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                handleAnyError(snapshot.data?.status ?? "",
                    snapshot.data?.message ?? "Error");
              });
              var list = snapshot.data?.dynamicList;
              if (list != null && list.isNotEmpty) {
                addStandingOrders(list: list);
                widget = ListView.builder(
                  itemCount: standingOrderList.length,
                  itemBuilder: (context, index) {
                    return StandingOrderItem(
                        standingOrder: standingOrderList[index]);
                  },
                );
              } else {
                widget = Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      const Icon(
                        Icons.warning_amber_rounded,
                        size: 44,
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Text("Nothing here!")
                    ],
                  ),
                );
              }
            }
            return widget;
          }),
    );
  }

  addStandingOrders({required list}) {
    list.forEach((item) {
      standingOrderList.add(StandingOrder.fromJson(item));
    });
  }

  handleAnyError(String status, String message) {
    if (status != StatusCode.success.statusCode) {
      AlertUtil.showAlertDialog(context, message, isConfirm: false);
    }
  }
}

class StandingOrderItem extends StatelessWidget {
  StandingOrder standingOrder;

  StandingOrderItem({Key? key, required this.standingOrder}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        margin: const EdgeInsets.only(bottom: 8.0, top: 4),
        child: Material(
            elevation: 2,
            borderRadius: BorderRadius.circular(8.0),
            child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                child: IntrinsicHeight(
                    child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              standingOrder.requestData ?? "****",
                              style: TextStyle(
                                  fontSize: 16,
                                  color: APIService.appPrimaryColor),
                            ),
                          ],
                        ),
                        Text(standingOrder.effectiveDate ?? "****"),
                        const SizedBox(
                          height: 18,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Amount"),
                            Text(standingOrder.amount.toString(),
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold))
                          ],
                        ),
                      ],
                    ))
                  ],
                )))));
  }
}
