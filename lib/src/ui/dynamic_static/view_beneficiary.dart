import 'package:craft_dynamic/craft_dynamic.dart';
import 'package:craft_dynamic/src/network/dynamic_request.dart';
import 'package:craft_dynamic/src/util/local_data_util.dart';
import 'package:flutter/material.dart';

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
      // appBar: AppBar(
      //   title: Text(widget.moduleItem.moduleName),
      // ),
        body: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            const SizedBox(
              height: 35,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
              child: Card(
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                    //set border radius more than 50% of height and width to make circle
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
                                  fontWeight: FontWeight.bold),
                            ))
                      ],
                    ),
                  )),
            ),
            Expanded(child: Container(
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 2),
              height: double.maxFinite,
              color: const Color.fromARGB(255, 219, 220, 221),
              child: BlurrLoadScreen(
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
                                padding: EdgeInsets.only(left: 0, right: 0, top: 15),
                                separatorBuilder: (context, index) => Divider(
                                  color: Colors.grey[300],
                                ),
                                itemCount: itemCount,
                                itemBuilder: (context, index) {
                                  final beneficiary = snapshot.data![index];

                                  return Padding(padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 1),
                                    child: Material(
                                        elevation: 1.5,
                                        borderRadius: BorderRadius.zero,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 15, vertical: 15),
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
                                                        fontFamily: "Myriad Pro",
                                                        color: APIService.appPrimaryColor,
                                                        fontWeight: FontWeight.bold),
                                                  ),
                                                  const SizedBox(
                                                    height: 12,
                                                  ),
                                                  const Text(
                                                    "Alias",
                                                    style: TextStyle(
                                                        fontFamily: "Myriad Pro",
                                                        color: Colors.grey,
                                                        fontWeight: FontWeight.normal),
                                                  ),
                                                  const SizedBox(
                                                    width: 12,
                                                  ),
                                                  Text(beneficiary.accountAlias,
                                                    style: TextStyle(
                                                        fontFamily: "Myriad Pro",
                                                        fontSize: 14,
                                                        fontWeight: FontWeight.bold
                                                    ),),
                                                  const SizedBox(
                                                    height: 12,
                                                  ),
                                                  const Text(
                                                    "Meter/Account ID",
                                                    style: TextStyle(
                                                      fontFamily: "Myriad Pro",
                                                      color: Colors.grey,),
                                                  ),
                                                  const SizedBox(
                                                    width: 12,
                                                  ),
                                                  Text(beneficiary.accountID,
                                                    style: TextStyle(
                                                        fontFamily: "Myriad Pro",
                                                        fontSize: 14,
                                                        fontWeight: FontWeight.bold
                                                    ),),
                                                ],
                                              ),
                                              IconButton(
                                                  onPressed: () {
                                                    AlertUtil.showAlertDialog(context,
                                                        "Confirm action to delete ${beneficiary.merchantName}",
                                                        isConfirm: true, title: "Delete")
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
                                        )
                                    ),);
                                });
                          }
                        }
                        return widget;
                      })),
            ))
          ],
        )
    );
  }

  Future<List<Beneficiary>> viewBeneficiaries() async {
    isCallingService.value = true;
    List<Beneficiary> beneficiaries = [];
    try {
      DynamicInput.formInputValues.clear();
      DynamicInput.formInputValues
          .addAll({"MerchantID": widget.moduleItem.merchantID});

      DynamicInput.formInputValues.addAll({"HEADER": "GETBENEFICIARY"});
      DynamicInput.formInputValues.addAll({"INFOFIELD1": "TRANSFER"});
    } catch (e) {
      debugPrint("benefifciary error $e");
    }

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
    DynamicInput.formInputValues
        .addAll({"INFOFIELD1": beneficiary.accountAlias});
    DynamicInput.formInputValues
        .addAll({"INFOFIELD2": beneficiary.merchantName});
    DynamicInput.formInputValues.addAll({"INFOFIELD4": beneficiary.accountID});
    DynamicInput.formInputValues.addAll({"INFOFIELD3": beneficiary.rowId});
    DynamicInput.formInputValues
        .addAll({"MerchantID": widget.moduleItem.merchantID});
    DynamicInput.formInputValues.addAll({"HEADER": "DELETEBENEFICIARY"});
    _dynamicFormRequest
        .dynamicRequest(widget.moduleItem,
        dataObj: DynamicInput.formInputValues,
        context: context,
        listType: ListType.BeneficiaryList)
        .then((value) {
      isCallingService.value = false;

      if (value?.status == StatusCode.success.statusCode) {
        CommonUtils.showToast(
            "Beneficiary ${beneficiary.accountAlias} successfully deleted");
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
