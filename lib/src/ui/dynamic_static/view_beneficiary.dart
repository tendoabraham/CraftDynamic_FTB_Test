import 'package:craft_dynamic/craft_dynamic.dart';
import 'package:craft_dynamic/src/network/dynamic_request.dart';
import 'package:craft_dynamic/src/state/plugin_state.dart';
import 'package:craft_dynamic/src/ui/dynamic_components.dart';
import 'package:craft_dynamic/src/util/local_data_util.dart';
import 'package:flutter/material.dart';

import '../../../dynamic_widget.dart';

class ViewBeneficiary extends StatefulWidget {
  final ModuleItem moduleItem;

  const ViewBeneficiary({required this.moduleItem, super.key});

  @override
  State<StatefulWidget> createState() => _ViewBeneficiaryState();
}

class _ViewBeneficiaryState extends State<ViewBeneficiary> {
  final _beneficiaryRepository = BeneficiaryRepository();
  final _dynamicFormRequest = DynamicFormRequest();

  @override
  initState() {
    super.initState();
    isCallingService.value = false;
  }

  getBeneficiaries() => _beneficiaryRepository.getAllBeneficiaries();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.moduleItem.moduleName),
      ),
      body: BlurrLoadScreen(
          mainWidget: FutureBuilder<List<Beneficiary>>(
              future: viewBeneficiaries(),
              builder: (BuildContext context,
                  AsyncSnapshot<List<Beneficiary>> snapshot) {
                Widget widget = Center(child: LoadUtil());

                if (snapshot.hasData) {
                  final itemCount = snapshot.data?.length ?? 0;

                  if (itemCount == 0) {
                    widget = const EmptyUtil();
                  } else {
                    widget = ListView.separated(
                        separatorBuilder: (context, index) => Divider(
                              color: Colors.grey[300],
                            ),
                        itemCount: itemCount,
                        itemBuilder: (context, index) {
                          final beneficiary = snapshot.data![index];

                          return Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      beneficiary.merchantName,
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: APIService.appPrimaryColor),
                                    ),
                                    const SizedBox(
                                      height: 12,
                                    ),
                                    Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 4),
                                        child: Row(
                                          children: [
                                            const Text(
                                              "Alias",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            const SizedBox(
                                              width: 12,
                                            ),
                                            Text(beneficiary.accountAlias),
                                          ],
                                        )),
                                    const SizedBox(
                                      height: 2,
                                    ),
                                    Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 4),
                                        child: Row(
                                          children: [
                                            const Text(
                                              "Id",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            const SizedBox(
                                              width: 12,
                                            ),
                                            Text(beneficiary.accountID),
                                          ],
                                        ))
                                  ],
                                ),
                                IconButton(
                                    onPressed: () {
                                      AlertUtil.showAlertDialog(context,
                                              "Confirm action to delete ${beneficiary.merchantName}",
                                              isConfirm: true)
                                          .then((value) {
                                        if (value) {
                                          deleteBeneficiary(
                                              beneficiary, context);
                                        }
                                      });
                                    },
                                    icon: const Icon(
                                      Icons.delete_outline_outlined,
                                      color: Colors.red,
                                      size: 34,
                                    ))
                              ],
                            ),
                          );
                        });
                  }
                }
                return widget;
              })),
    );
  }

  Future<List<Beneficiary>> viewBeneficiaries() async {
    isCallingService.value = true;
    List<Beneficiary> beneficiaries = [];

    DynamicInput.formInputValues.clear();
    DynamicInput.formInputValues
        .add({"MerchantID": widget.moduleItem.merchantID});

    DynamicInput.formInputValues.add({"HEADER": "GETBENEFICIARY"});
    // DynamicInput.formInputValues.add({"INFOFIELD1": "TRANSFER"});
    await _dynamicFormRequest
        .dynamicRequest(widget.moduleItem,
            dataObj: DynamicInput.formInputValues,
            context: context,
            listType: ListType.BeneficiaryList)
        .then((value) {
      isCallingService.value = false;
      if (value?.status == StatusCode.success.statusCode) {
        var beneficiaryList = value?.beneficiaries;
        if (beneficiaryList != []) {
          beneficiaryList?.forEach((beneficiary) {
            beneficiaries.add(Beneficiary.fromJson(beneficiary));
          });
        }
      }
    });
    return beneficiaries;
  }

  deleteBeneficiary(Beneficiary beneficiary, context) {
    isCallingService.value = true;
    DynamicInput.formInputValues.clear();
    DynamicInput.formInputValues.add({"INFOFIELD1": beneficiary.accountAlias});
    DynamicInput.formInputValues.add({"INFOFIELD2": beneficiary.merchantName});
    DynamicInput.formInputValues.add({"INFOFIELD4": beneficiary.accountID});
    DynamicInput.formInputValues.add({"INFOFIELD3": beneficiary.rowId});
    DynamicInput.formInputValues
        .add({"MerchantID": widget.moduleItem.merchantID});
    DynamicInput.formInputValues.add({"HEADER": "DELETEBENEFICIARY"});
    _dynamicFormRequest
        .dynamicRequest(widget.moduleItem,
            dataObj: DynamicInput.formInputValues,
            context: context,
            listType: ListType.BeneficiaryList)
        .then((value) {
      isCallingService.value = false;

      if (value?.status == StatusCode.success.statusCode) {
        setState(() {
          _beneficiaryRepository.deleteBeneficiary(beneficiary.rowId);
          var beneficiaries = value?.beneficiaries;
          if (beneficiaries != null) {
            LocalDataUtil.refreshBeneficiaries(beneficiaries);
          }
        });
      } else {
        AlertUtil.showAlertDialog(
          context,
          value?.message ?? "Error",
        );
      }
    });
  }
}
