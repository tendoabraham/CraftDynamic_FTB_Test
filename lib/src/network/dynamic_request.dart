import 'package:craft_dynamic/craft_dynamic.dart';
import 'package:craft_dynamic/src/state/plugin_state.dart';
import 'package:craft_dynamic/src/ui/forms/confirmation_form.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../builder/factory_builder.dart';

class DynamicFormRequest {
  Map<String, dynamic> requestObj = {};
  List<Map<String?, dynamic>> formvalues = [];
  List<Map<String?, dynamic>> encryptedvalues = [];
  final _actionControlRepository = ActionControlRepository();
  final _formsRepository = FormsRepository();
  final _services = APIService();
  final _sharedPref = CommonSharedPref();
  String? confirmationModuleID;
  DynamicResponse? dynamicResponse;

  Future<DynamicResponse?> dynamicRequest(
    ModuleItem? moduleItem, {
    FormItem? formItem,
    dataObj,
    encryptedField,
    isList = false,
    context,
    listType = ListType.TransactionList,
    tappedButton = false,
  }) async {
    formvalues.addAll(
        Provider.of<PluginState>(context, listen: false).formInputValues);
    encryptedvalues.addAll(
        Provider.of<PluginState>(context, listen: false).encryptedFields);

    ActionItem? actionControl;
    dynamicResponse = DynamicResponse(status: StatusCode.unknown.name);
    var merchantID = moduleItem?.merchantID ?? "BANKIMAGE";

    if (dataObj == null) {
      Fluttertoast.showToast(
          msg: "Unable to process data", backgroundColor: Colors.red);
      return dynamicResponse;
    }

    ActionType actionType = ActionType.DBCALL;
    if (listType == ListType.ViewOrderList ||
        listType == ListType.BeneficiaryList) {
      requestObj["EncryptedFields"] = {};
      requestObj["MerchantID"] = merchantID;
    }

    requestObj["ModuleID"] = moduleItem?.moduleId;
    requestObj["SessionID"] = "ffffffff-e46c-53ce-0000-00001d093e12";

    if (formItem != null) {
      AppLogger.appLogD(
          tag: "control id::moduleid",
          message: "${formItem.controlId}:${moduleItem?.moduleId}");
      actionControl =
          await _actionControlRepository.getActionControlByModuleIdAndControlId(
              moduleItem?.moduleId ?? "", formItem.controlId);
      AppLogger.appLogD(
          tag: "action control merchant id-->",
          message: actionControl?.merchantID);
    }

    if (actionControl?.displayFormID == ControlFormat.LISTDATA.name ||
        actionControl == null) {
      isList = true;
    }

    if (actionControl != null) {
      var actionMerchantID = actionControl.merchantID;
      if (actionMerchantID != null && actionMerchantID != "") {
        AppLogger.appLogD(
            tag: "action merchantid", message: actionControl.merchantID);
        merchantID = actionMerchantID;
      }
    }

    if (actionControl != null) {
      actionType = ActionType.values.byName(actionControl.actionType);
    }

    if (actionType == ActionType.VALIDATE) {
      setDeleteForm(context, false);
    } else {
      setDeleteForm(context, true);
    }

    confirmationModuleID = actionControl?.confirmationModuleID;
    if (confirmationModuleID != null && confirmationModuleID != "") {
      List<FormItem> form = await _formsRepository
              .getFormsByModuleId(confirmationModuleID ?? "") ??
          [];
      var result = await ConfirmationForm.confirmTransaction(
          context, form, moduleItem!, formvalues);
      if (result != null) {
        if (result == 1) {
          Provider.of<PluginState>(context, listen: false)
              .setRequestState(false);
          return dynamicResponse;
        }
      } else {
        try {
          Provider.of<PluginState>(context, listen: false)
              .setRequestState(false);
        } catch (e) {
          AppLogger.appLogE(tag: "error", message: e.toString());
        }
        return dynamicResponse;
      }
    }

    requestObj = DynamicFactory.getDynamicRequestObject(actionType,
        merchantID: merchantID,
        actionID: formItem?.actionId ?? "",
        requestMap: requestObj,
        dataObject: formvalues,
        isList: isList,
        listType: listType,
        encryptedFields:
            encryptedvalues); // Get a request map from this interface

    dynamicResponse = await _services.dynamicRequest(
        requestObj: requestObj,
        webHeader: actionControl?.webHeader,
        formID: actionType.name);

    if (dynamicResponse?.status == StatusCode.unknown.name) {
      Provider.of<PluginState>(context, listen: false).setRequestState(false);
    }

    var dynamicData = DynamicData(
        actionType: actionType,
        dynamicResponse:
            dynamicResponse ?? DynamicResponse(status: StatusCode.unknown.name),
        moduleItem: moduleItem,
        controlID: formItem?.controlId,
        isList: isList,
        listType: listType,
        tappedButton: tappedButton);

    dynamicResponse?.dynamicData = dynamicData;

    if (moduleItem?.moduleId == StatusCode.unknown.name &&
        dynamicResponse?.status == StatusCode.success.statusCode) {
      _sharedPref.setBio(false);
    }

    Provider.of<PluginState>(context, listen: false).setRequestState(false);

    return dynamicResponse;
  }

  void setDeleteForm(context, bool status) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      try {
        Provider.of<PluginState>(context, listen: false).setDeleteForm(status);
      } catch (e) {}
    });
  }
}
