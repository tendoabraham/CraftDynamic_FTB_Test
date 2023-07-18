// ignore_for_file: must_be_immutable, unnecessary_const

import 'package:blur/blur.dart';
import 'package:craft_dynamic/craft_dynamic.dart';
import 'package:craft_dynamic/src/network/dynamic_request.dart';
import 'package:craft_dynamic/src/ui/dynamic_components.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import '../../../dynamic_widget.dart';
import '../../state/plugin_state.dart';

final _dynamicRequest = DynamicFormRequest();

class ViewStandingOrder extends StatefulWidget {
  final ModuleItem moduleItem;

  const ViewStandingOrder({required this.moduleItem, super.key});

  @override
  State<StatefulWidget> createState() => _ViewStandingOrderState();
}

class _ViewStandingOrderState extends State<ViewStandingOrder> {
  List<StandingOrder> standingOrderList = [];

  @override
  void initState() {
    super.initState();
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
        body: Stack(
          children: [
            FutureBuilder<List<StandingOrder>?>(
                future: _viewStandingOrder(),
                builder: (BuildContext context,
                    AsyncSnapshot<List<StandingOrder>?> snapshot) {
                  Widget child = Center(
                    child: LoadUtil(),
                  );
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasData) {
                      var list = snapshot.data;
                      if (list != null && list.isNotEmpty) {
                        child = ListView.builder(
                          itemCount: list.length,
                          itemBuilder: (context, index) {
                            return StandingOrderItem(
                              standingOrder: list[index],
                              moduleItem: widget.moduleItem,
                              refreshParent: refresh,
                            );
                          },
                        );
                      } else {
                        child = Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.warning_amber_rounded,
                                size: 122,
                                color:
                                    APIService.appPrimaryColor.withOpacity(.4),
                              ),
                              const SizedBox(
                                height: 12,
                              ),
                              const Text("Nothing here!")
                            ],
                          ),
                        );
                      }
                    }
                  }
                  return child;
                }),
            Obx(() => isDeletingStandingOrder.value
                ? LoadUtil().frosted(
                    blur: 2,
                  )
                : const SizedBox())
          ],
        ));
  }

  Future<List<StandingOrder>?> _viewStandingOrder() async {
    List<StandingOrder>? orders = [];

    DynamicInput.formInputValues.clear();
    DynamicInput.formInputValues
        .addAll({"MerchantID": widget.moduleItem.merchantID});
    DynamicInput.formInputValues.addAll({"HEADER": "VIEWSTANDINGORDER"});
    // DynamicInput.formInputValues.add({"INFOFIELD1": "TRANSFER"});
    var results = await _dynamicRequest.dynamicRequest(widget.moduleItem,
        dataObj: DynamicInput.formInputValues,
        context: context,
        listType: ListType.ViewOrderList);

    if (results?.status == StatusCode.success.statusCode) {
      var list = results?.dynamicList;
      AppLogger.appLogD(tag: "Standing orders", message: list);
      if (list != []) {
        list?.forEach((order) {
          try {
            Map<String, dynamic> orderJson = order;
            orders.add(StandingOrder.fromJson(orderJson));
          } catch (e) {
            AppLogger.appLogE(
                tag: "Add standing order error", message: e.toString());
          }
        });
      }
    }

    return orders;
  }

  void refresh() {
    setState(() {});
  }
}

class StandingOrderItem extends StatefulWidget {
  StandingOrder standingOrder;
  ModuleItem moduleItem;
  Function() refreshParent;

  StandingOrderItem(
      {Key? key,
      required this.standingOrder,
      required this.moduleItem,
      required this.refreshParent})
      : super(key: key);

  @override
  State<StandingOrderItem> createState() => _StandingOrderItemState();
}

class _StandingOrderItemState extends State<StandingOrderItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        margin: const EdgeInsets.only(bottom: 8.0, top: 4),
        child: Material(
            elevation: 1,
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
                        RowItem(
                          title: "Effective date",
                          value: widget.standingOrder.effectiveDate,
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        RowItem(
                          title: "Debit Account",
                          value: widget.standingOrder.debitAccount,
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        RowItem(
                          title: "Amount",
                          value: widget.standingOrder.amount.toString(),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        RowItem(
                          title: "Narration",
                          value: widget.standingOrder.narration,
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        RowItem(
                          title: "Frequency",
                          value: widget.standingOrder.frequencyID,
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        RowItem(
                          title: "Executions",
                          value: widget.standingOrder.noOfExecutions.toString(),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        IconButton(
                            onPressed: () {
                              _confirmDeleteAction(
                                      context, widget.standingOrder)
                                  .then((value) {
                                if (value) {
                                  isDeletingStandingOrder.value = true;
                                  _deleteStandingOrder(widget.standingOrder,
                                      widget.moduleItem, context);
                                }
                              });
                            },
                            style: ButtonStyle(
                                minimumSize: MaterialStateProperty.all(
                                    const Size.fromHeight(40))),
                            icon: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.delete_outline_rounded,
                                    color: APIService.appPrimaryColor,
                                    size: 34,
                                  ),
                                  const SizedBox(
                                    width: 4,
                                  ),
                                  const Text(
                                    "Delete",
                                    style: TextStyle(
                                        color: Colors.red, fontSize: 18),
                                  )
                                ]))
                      ],
                    ))
                  ],
                )))));
  }

  _deleteStandingOrder(
      StandingOrder standingOrder, ModuleItem moduleItem, context) async {
    DynamicInput.formInputValues.clear();
    DynamicInput.formInputValues
        .addAll({"INFOFIELD3": standingOrder.standingOrderID});
    DynamicInput.formInputValues
        .addAll({RequestParam.MerchantID.name: moduleItem.merchantID});
    DynamicInput.formInputValues
        .addAll({RequestParam.HEADER.name: "DELETESTANDINGORDER"});

    await _dynamicRequest
        .dynamicRequest(moduleItem,
            dataObj: DynamicInput.formInputValues,
            context: context,
            listType: ListType.ViewOrderList)
        .then((value) {
      isDeletingStandingOrder.value = false;
      if (value?.status == StatusCode.success.statusCode) {
        CommonUtils.showToast("Standing order deleted successfully");
        widget.refreshParent();
      } else {
        AlertUtil.showAlertDialog(
          context,
          value?.message ?? "Unable to delete standing Order",
        );
      }
    });
  }

  _confirmDeleteAction(BuildContext context, StandingOrder standingOrder) {
    return AlertUtil.showAlertDialog(context,
        "Confirm deletion of Standing order for debit account ${standingOrder.debitAccount} with amount ${standingOrder.amount}",
        isConfirm: true, title: "Confirm", confirmButtonText: "Delete");
  }
}

class RowItem extends StatelessWidget {
  final String title;
  String? value;

  RowItem({required this.title, this.value, super.key});

  @override
  Widget build(BuildContext context) => Column(children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title),
            Text(value ?? "***",
                style: const TextStyle(fontWeight: FontWeight.bold))
          ],
        ),
      ]);
}
