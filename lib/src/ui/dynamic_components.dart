// ignore_for_file: must_be_immutable, prefer_typing_uninitialized_variables

import 'dart:collection';
import 'dart:io';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:provider/provider.dart';
import 'package:camera/camera.dart';
import 'package:collection/collection.dart';

import 'package:craft_dynamic/craft_dynamic.dart';
import 'package:craft_dynamic/src/ui/dynamic_static/grouped_button.dart';
import 'package:craft_dynamic/src/ui/dynamic_static/list_screen.dart';
import 'package:craft_dynamic/src/network/dynamic_request.dart';
import 'package:craft_dynamic/dynamic_widget.dart';
import 'package:craft_dynamic/src/providers/group_button_provider.dart';
import 'package:craft_dynamic/src/state/plugin_state.dart';
import 'package:craft_dynamic/src/network/dynamic_postcall.dart';
import 'package:craft_dynamic/src/util/widget_util.dart';

import 'dynamic_static/qr_scanner.dart';

class DynamicInput {
  static Map<String?, dynamic> formInputValues = {};
  static Map<String?, dynamic> encryptedField = {};

  clearDynamicInput() {
    formInputValues.clear();
    encryptedField.clear();
  }
}

class BaseFormComponent extends StatelessWidget {
  const BaseFormComponent(
      {super.key,
      required this.child,
      required this.formItem,
      required this.moduleItem,
      required this.formItems,
      required this.formKey});

  final Widget child;
  final FormItem formItem;
  final ModuleItem moduleItem;
  final List<FormItem> formItems;
  final GlobalKey<FormState> formKey;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BaseFormInheritedComponent(
          widget: child,
          formItem: formItem,
          moduleItem: moduleItem,
          formItems: formItems,
          formKey: formKey,
        ),
        formItem.controlType == ViewType.HIDDEN.name ||
                formItem.controlType == ViewType.CONTAINER.name ||
                formItem.controlType == ViewType.RBUTTON.name ||
                formItem.controlType == ViewType.TAB.name ||
                formItem.controlType == ViewType.LIST.name ||
                formItem.controlType == ViewType.TITLE.name ||
                formItem.controlType == ViewType.SELECTEDTEXT.name ||
                formItem.controlType == ViewType.FORM.name ||
                formItem.controlType == ViewType.IMAGE.name ||
                formItem.controlType == ViewType.TEXTVIEW.name
            ? const SizedBox()
            : const SizedBox(
                height: 18,
              )
      ],
    );
  }
}

class BaseFormInheritedComponent extends InheritedWidget {
  final FormItem formItem;
  final ModuleItem moduleItem;
  final List<FormItem> formItems;
  final GlobalKey<FormState> formKey;
  final Widget widget;
  List<dynamic>? jsonText;

  BaseFormInheritedComponent(
      {Key? key,
      required this.widget,
      required this.formItem,
      required this.moduleItem,
      required this.formItems,
      required this.formKey,
      this.jsonText})
      : super(key: key, child: widget);

  static BaseFormInheritedComponent? of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<BaseFormInheritedComponent>();
  }

  @override
  bool updateShouldNotify(covariant BaseFormInheritedComponent oldWidget) {
    return oldWidget.formItem != formItem;
  }
}

class DynamicTextFormField extends StatefulWidget implements IFormWidget {
  Function? func;
  bool isEnabled;
  String? customText;
  TextEditingController? controller;
  List<dynamic>? formFields;

  DynamicTextFormField(
      {Key? key,
      this.isEnabled = true,
      this.func,
      this.customText,
      this.controller,
      this.formFields})
      : super(key: key);

  @override
  Widget render() {
    return DynamicTextFormField(
      formFields: formFields,
    );
  }

  @override
  State<DynamicTextFormField> createState() => _DynamicTextFormFieldState();
}

class _DynamicTextFormFieldState extends State<DynamicTextFormField> {
  var controller = TextEditingController();
  var inputType = TextInputType.text;
  bool isObscured = false;
  IconButton? suffixIcon;
  FormItem? formItem;
  String? initialValue;
  String linkedToControlText = "";

  @override
  void initState() {
    super.initState();
    if (widget.customText != null) {
      controller.text = widget.customText!;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    formItem = BaseFormInheritedComponent.of(context)?.formItem;
  }

  updateControllerText(String value) {
    controller.text = value;
  }

  @override
  Widget build(BuildContext context) {
    bool isEnabled = formItem?.isEnabled ?? false;

    return Consumer<PluginState>(builder: (context, state, child) {
      isObscured = formItem?.controlFormat == ControlFormat.PinNumber.name ||
              formItem?.controlFormat == ControlFormat.PIN.name
          ? true
          : false;

      var textFieldParams = WidgetUtil.checkControlFormat(
          formItem!.controlFormat!,
          context: context,
          isObscure: isObscured,
          refreshParent: refreshParent);
      inputType = textFieldParams['inputType'];
      var formFieldValue = widget.formFields?.firstWhereOrNull((formField) =>
              formField[FormFieldProp.ControlID.name].toLowerCase() ==
              formItem?.controlId?.toLowerCase()) ??
          "";

      if (formFieldValue.isNotEmpty) {
        controller.text = formFieldValue[FormFieldProp.ControlValue.name] ?? "";
      }

      String linkedDropDownValue =
          state.screenDropDowns[formItem?.linkedToRowID?.toLowerCase()] ?? "";

      if (linkedDropDownValue.isNotEmpty) {
        controller.text = linkedDropDownValue;
      }

      var properties = TextFormFieldProperties(
          isEnabled: formFieldValue.isNotEmpty ||
                  linkedDropDownValue.isNotEmpty ||
                  isEnabled
              ? false
              : true,
          isObscured: isObscured ? state.obscureText : false,
          controller: controller,
          textInputType: inputType,
          inputDecoration: InputDecoration(
            // border: const OutlineInputBorder(),
            labelText: formItem?.controlText,
            suffixIcon: textFieldParams['suffixIcon'],
          ),
          isAmount: formItem?.controlFormat == ControlFormat.Amount.name);

      return WidgetFactory.buildTextField(context, properties, validator);
    });
  }

  String? validator(String? value) {
    var formattedValue = value.toString().replaceAll(',', '');
    if (formItem!.isMandatory! && value!.isEmpty) {
      return 'Input required*';
    }

    if (inputType == TextInputType.number &&
        formItem?.controlFormat == ControlFormat.Amount.name) {
      if (formItem?.maxValue != null) {
        if (formItem!.maxValue!.isNotEmpty) {
          if (double.parse(formattedValue) >
              double.parse(formItem!.maxValue!)) {
            return "Maximum accepted is ${formItem!.maxValue}";
          }
          if (formItem?.minValue != null) {
            if (double.parse(formattedValue) <
                double.parse(formItem!.minValue!)) {
              return "Minimum required is ${formItem?.minValue}";
            }
          }
        }
      }
    }
    if (isObscured) {
      Provider.of<PluginState>(context, listen: false).addEncryptedFields({
        "${formItem?.serviceParamId}":
            CryptLib.encryptField(formattedValue.replaceAll(" ", ""))
      });
    } else {
      Provider.of<PluginState>(context, listen: false)
          .addFormInput({"${formItem?.serviceParamId}": "$value"});
    }
    return null;
  }

  void refreshParent(bool status, {newText}) {
    setState(() {
      status;
      controller.text = DateFormat('yyyy-MM-dd').format(newText);
    });
  }
}

class HiddenWidget implements IFormWidget {
  List<dynamic>? formFields;
  FormItem? formItem;

  HiddenWidget({this.formFields, this.formItem});

  @override
  Widget render() {
    return Builder(builder: (context) {
      String controlValue = "";

      if (formFields != null) {
        formFields?.forEach((formField) {
          if (formField[FormFieldProp.ControlID.name] == formItem?.controlId) {
            controlValue = formField[FormFieldProp.ControlValue.name];
            if (controlValue.isNotEmpty) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Provider.of<PluginState>(context, listen: false).addFormInput(
                    {"${formItem?.serviceParamId}": controlValue});
              });
            }
          }
        });
      } else {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Provider.of<PluginState>(context, listen: false)
              .addFormInput({formItem?.serviceParamId: formItem?.controlValue});
        });
      }
      return const Visibility(
        visible: false,
        child: SizedBox(),
      );
    });
  }
}

class DynamicButton extends StatefulWidget implements IFormWidget {
  const DynamicButton({super.key});

  @override
  Widget render() {
    return const DynamicButton();
  }

  @override
  State<DynamicButton> createState() => _DynamicButtonState();
}

class _DynamicButtonState extends State<DynamicButton> {
  final _dynamicRequest = DynamicFormRequest();
  final _moduleRepository = ModuleRepository();
  FormItem? formItem;
  ModuleItem? moduleItem;
  var formKey;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    formItem = BaseFormInheritedComponent.of(context)?.formItem;
    moduleItem = BaseFormInheritedComponent.of(context)?.moduleItem;
    formKey = BaseFormInheritedComponent.of(context)?.formKey;
  }

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (BuildContext context) {
      return Container(
          alignment: Alignment.bottomCenter,
          padding: const EdgeInsets.symmetric(vertical: 34),
          child: Consumer<PluginState>(builder: (context, state, child) {
            return state.loadingNetworkData
                ? LoadUtil()
                : WidgetFactory.buildButton(
                    context, onClick, formItem!.controlText!.capitalize());
          }));
    });
  }

  onClick() {
    if (formItem?.controlId == "CLOSE") {
      Navigator.of(context).pop();
      Navigator.of(context).pop();
      return;
    }

    if (formItem?.controlFormat == ControlFormat.OPENFORM.name) {
      getModule(formItem?.actionId ?? "").then((module) {
        CommonUtils.navigateToRoute(
            context: context,
            widget: DynamicWidget(
              moduleItem: module,
            ));
      });

      return;
    }

    if (formKey?.currentState?.validate()!) {
      FocusScopeNode currentFocus = FocusScope.of(context);
      if (!currentFocus.hasPrimaryFocus) {
        currentFocus.unfocus();
      }

      if (formItem?.controlFormat == ControlFormat.NEXT.name) {
        Provider.of<PluginState>(context, listen: false).setDeleteForm(false);
        CommonUtils.navigateToRoute(
            context: context,
            widget: DynamicWidget(
              moduleItem: moduleItem,
              nextFormSequence: 2,
            ));
        return;
      } else {
        Provider.of<PluginState>(context, listen: false).setRequestState(true);
        _dynamicRequest
            .dynamicRequest(moduleItem!,
                formItem: formItem,
                dataObj: Provider.of<PluginState>(context, listen: false)
                    .formInputValues,
                encryptedField: Provider.of<PluginState>(context, listen: false)
                    .encryptedFields,
                context: context,
                tappedButton: true)
            .then((value) {
          if (value?.status != StatusCode.unknown.statusCode) {
            DynamicPostCall.processDynamicResponse(
                value!.dynamicData!, context, formItem!.controlId!,
                moduleItem: moduleItem);
          }
        });
      }
    } else {
      CommonUtils.vibrate();
    }
  }

  getModule(String moduleID) => _moduleRepository.getModuleById(moduleID);
}

class DynamicDropDown implements IFormWidget {
  final _apiService = APIService();
  FormItem? formItem;
  ModuleItem? moduleItem;
  String? _currentValue;
  Map<String, dynamic> extraFieldMap = {};

  Future<DynamicResponse?> dbCall(
          String actionID, ModuleItem moduleItem) async =>
      _apiService.getDynamicDropDownValues(actionID, moduleItem);

  @override
  Widget render() {
    return Builder(builder: (BuildContext context) {
      formItem = BaseFormInheritedComponent.of(context)?.formItem;
      moduleItem = BaseFormInheritedComponent.of(context)?.moduleItem;

      return FutureBuilder<DynamicResponse?>(
          future: dbCall(formItem?.actionId ?? "", moduleItem!),
          builder:
              (BuildContext context, AsyncSnapshot<DynamicResponse?> snapshot) {
            Widget child = DropdownButtonFormField2(
              value: _currentValue,
              decoration: InputDecoration(
                  prefixIcon: SizedBox(
                      height: 28,
                      width: 28,
                      child: Center(
                          child: CircularProgressIndicator(
                        color: APIService.appSecondaryColor,
                      )))),
              hint: Text(
                formItem!.controlText!,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              isExpanded: true,
              style: const TextStyle(fontSize: 16, color: Colors.black),
              items: const [],
            );
            if (snapshot.hasData) {
              var dropdownItems = snapshot.data?.dynamicList ?? [];

              Map<String, String> mapList = {};

              for (dynamic item in dropdownItems) {
                if (item is Map<String, dynamic>) {
                  // Assuming each item in the list is a map with a single key-value pair
                  String key = item.values.last;
                  String value = item.values.first;
                  mapList[key] = value;
                }
              }

              var dropdownPicks = mapList.entries.map((item) {
                return DropdownMenuItem(
                  value: item.key,
                  child: Text(
                    item.value,
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                );
              }).toList();
              dropdownPicks.toSet().toList();
              if (dropdownPicks.isNotEmpty) {
                _currentValue = dropdownPicks[0].value;
                addInitialValueToLinkedField(context);
              }
              child = DropdownButtonFormField(
                value: _currentValue,
                decoration: InputDecoration(labelText: formItem?.controlText),
                isExpanded: true,
                style: const TextStyle(fontWeight: FontWeight.normal),
                onChanged: ((value) => {
                      _currentValue = value.toString(),
                      Provider.of<PluginState>(context, listen: false)
                          .addScreenDropDown({
                        formItem?.rowID.toString(): extraFieldMap[_currentValue]
                      }),
                    }),
                validator: (value) {
                  Provider.of<PluginState>(context, listen: false)
                      .addFormInput({"${formItem?.serviceParamId}": value});
                },
                items: dropdownPicks,
              );
            }

            return child;
          });
    });
  }

  void addInitialValueToLinkedField(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      try {
        if (Provider.of<PluginState>(context, listen: false)
            .screenDropDowns
            .isEmpty) {
          Provider.of<PluginState>(context, listen: false).addScreenDropDown(
              {formItem?.rowID?.toString(): extraFieldMap[_currentValue]});
        }
      } catch (e) {
        AppLogger.appLogE(tag: "Dropdown error", message: e.toString());
      }
    });
  }
}

class DropDown extends StatefulWidget implements IFormWidget {
  const DropDown({super.key});

  @override
  State<DropDown> createState() => _DropDownState();

  @override
  Widget render() => const DropDown();
}

class _DropDownState extends State<DropDown> {
  final _userCodeRepository = UserCodeRepository();
  List<UserCode> userCodes = [];
  Map<String, dynamic> extraFieldMap = {};

  FormItem? formItem;
  ModuleItem? moduleItem;
  String? _currentValue;

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (BuildContext context) {
      formItem = BaseFormInheritedComponent.of(context)?.formItem;
      moduleItem = BaseFormInheritedComponent.of(context)?.moduleItem;

      return FutureBuilder<Map<String, dynamic>?>(
          future: getDropDownValues(formItem!, moduleItem!),
          builder: (BuildContext context,
              AsyncSnapshot<Map<String, dynamic>?> snapshot) {
            Widget child = DropdownButtonFormField2(
              value: _currentValue,
              hint: Text(
                formItem!.controlText!,
              ),
              isExpanded: true,
              items: const [],
            );
            if (snapshot.hasData) {
              var dropdownItems = snapshot.data;

              var dropdownPicks = dropdownItems?.entries.map((item) {
                return DropdownMenuItem(
                  value: item.key,
                  child: Text(
                    item.value,
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                );
              }).toList();
              dropdownPicks?.toSet().toList();
              if (dropdownPicks != null) {
                if (dropdownPicks.isNotEmpty) {
                  _currentValue = dropdownPicks[0].value;

                  addInitialValueToLinkedField(
                      context, extraFieldMap[_currentValue] ?? "");
                }
              }

              child = Consumer<DropDownState>(builder: (context, state, child) {
                if (formItem?.controlId == ControlID.TOACCOUNTID.name) {
                  dropdownPicks?.removeWhere((item) =>
                      item.value ==
                      state.currentSelections?[ControlID.FROMACCOUNTID]);
                }
                return DropdownButtonFormField(
                  value: _currentValue,
                  decoration: InputDecoration(labelText: formItem?.controlText),
                  isExpanded: true,
                  style: const TextStyle(fontWeight: FontWeight.normal),
                  onChanged: ((value) => {
                        _currentValue = value.toString(),
                        state.setCurrentSelections(
                            {formItem?.controlId: _currentValue}),
                        debugPrint(
                            "Dropdown changed --------------> ${state.currentSelections}"),
                        Provider.of<PluginState>(context, listen: false)
                            .addScreenDropDown({
                          formItem?.rowID?.toString():
                              extraFieldMap[_currentValue]
                        }),
                      }),
                  validator: (value) {
                    Provider.of<PluginState>(context, listen: false)
                        .addFormInput({"${formItem?.serviceParamId}": value});
                  },
                  items: dropdownPicks,
                );
              });
            }
            return child;
          });
    });
  }

  void addInitialValueToLinkedField(BuildContext context, String initialValue) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      try {
        Provider.of<DropDownState>(context, listen: false)
            .setCurrentSelections({formItem?.controlId: _currentValue});
        var items =
            Provider.of<PluginState>(context, listen: false).screenDropDowns;
        if (!items.containsKey(formItem?.rowID?.toString())) {
          Provider.of<PluginState>(context, listen: false)
              .addScreenDropDown({formItem?.rowID?.toString(): initialValue});
        }
      } catch (e) {
        AppLogger.appLogE(tag: "Dropdown error", message: e.toString());
      }
    });
  }

  Future<Map<String, dynamic>?>? getDropDownValues(
      FormItem formItem, ModuleItem moduleItem) async {
    if (formItem.controlFormat != ControlFormat.SELECTBANKACCOUNT.name ||
        formItem.controlFormat != ControlFormat.SELECTBENEFICIARY.name) {
      try {
        userCodes =
            await _userCodeRepository.getUserCodesById(formItem.dataSourceId);
        extraFieldMap = userCodes.fold<Map<String, dynamic>>(
            {}, (acc, curr) => acc..[curr.subCodeId] = curr.extraField!);
      } catch (e) {
        AppLogger.appLogE(tag: "Dropdown error", message: e.toString());
      }
    }
    return await IDropDownAdapter(formItem, moduleItem).getDropDownItems();
  }
}

// class DropDown implements IFormWidget {
//   final _userCodeRepository = UserCodeRepository();
//   List<UserCode> userCodes = [];
//   Map<String, dynamic> extraFieldMap = {};

//   FormItem? formItem;
//   ModuleItem? moduleItem;
//   String? _currentValue;

//   @override
//   Widget render() {
//     return Builder(builder: (BuildContext context) {
//       formItem = BaseFormInheritedComponent.of(context)?.formItem;
//       moduleItem = BaseFormInheritedComponent.of(context)?.moduleItem;

//       return FutureBuilder<Map<String, dynamic>?>(
//           future: getDropDownValues(formItem!, moduleItem!),
//           builder: (BuildContext context,
//               AsyncSnapshot<Map<String, dynamic>?> snapshot) {
//             Widget child = DropdownButtonFormField2(
//               value: _currentValue,
//               hint: Text(
//                 formItem!.controlText!,
//               ),
//               isExpanded: true,
//               items: const [],
//             );
//             if (snapshot.hasData) {
//               var dropdownItems = snapshot.data;

//               var dropdownPicks = dropdownItems?.entries.map((item) {
//                 return DropdownMenuItem(
//                   value: item.key,
//                   child: Text(
//                     item.value,
//                     style: Theme.of(context).textTheme.labelSmall,
//                   ),
//                 );
//               }).toList();
//               dropdownPicks?.toSet().toList();
//               if (dropdownPicks != null) {
//                 if (dropdownPicks.isNotEmpty) {
//                   _currentValue = dropdownPicks[0].value;
//                   addInitialValueToLinkedField(
//                       context, extraFieldMap[_currentValue] ?? "");
//                 }
//               }

//               child = Consumer<DropDownState>(builder: (context, state, child) {
//                 return DropdownButtonFormField(
//                   value: _currentValue,
//                   decoration: InputDecoration(labelText: formItem?.controlText),
//                   isExpanded: true,
//                   style: const TextStyle(fontWeight: FontWeight.normal),
//                   onChanged: ((value) => {
//                         _currentValue = value.toString(),
//                         debugPrint(
//                             "Dropdown changed --------------> ${state.currentSelections}"),
//                         Provider.of<PluginState>(context, listen: false)
//                             .addScreenDropDown({
//                           formItem?.rowID?.toString():
//                               extraFieldMap[_currentValue]
//                         }),
//                       }),
//                   validator: (value) {
//                     Provider.of<PluginState>(context, listen: false)
//                         .addFormInput({"${formItem?.serviceParamId}": value});
//                   },
//                   items: dropdownPicks,
//                 );
//               });
//             }
//             return child;
//           });
//     });
//   }

//   void addInitialValueToLinkedField(BuildContext context, String initialValue) {
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       try {
//         var items =
//             Provider.of<PluginState>(context, listen: false).screenDropDowns;
//         if (!items.containsKey(formItem?.rowID?.toString())) {
//           Provider.of<PluginState>(context, listen: false)
//               .addScreenDropDown({formItem?.rowID?.toString(): initialValue});
//         }
//       } catch (e) {
//         AppLogger.appLogE(tag: "Dropdown error", message: e.toString());
//       }
//     });
//   }

//   Future<Map<String, dynamic>?>? getDropDownValues(
//       FormItem formItem, ModuleItem moduleItem) async {
//     if (formItem.controlFormat != ControlFormat.SELECTBANKACCOUNT.name ||
//         formItem.controlFormat != ControlFormat.SELECTBENEFICIARY.name) {
//       try {
//         userCodes =
//             await _userCodeRepository.getUserCodesById(formItem.dataSourceId);
//         extraFieldMap = userCodes.fold<Map<String, dynamic>>(
//             {}, (acc, curr) => acc..[curr.subCodeId] = curr.extraField!);
//       } catch (e) {
//         AppLogger.appLogE(tag: "Dropdown error", message: e.toString());
//       }
//     }
//     return await IDropDownAdapter(formItem, moduleItem).getDropDownItems();
//   }
// }

class DynamicLabelWidget implements IFormWidget {
  DynamicResponse? dynamicResponse;
  final _dynamicRequest = DynamicFormRequest();

  getDynamicLabel(
          BuildContext context, FormItem? formItem, ModuleItem moduleItem) =>
      _dynamicRequest.dynamicRequest(
        moduleItem,
        formItem: formItem,
        dataObj:
            Provider.of<PluginState>(context, listen: false).formInputValues,
        encryptedField:
            Provider.of<PluginState>(context, listen: false).encryptedFields,
        isList: true,
        context: context,
      );

  @override
  Widget render() {
    return Builder(builder: (BuildContext context) {
      var formItem = BaseFormInheritedComponent.of(context)?.formItem;
      var moduleItem = BaseFormInheritedComponent.of(context)?.moduleItem;

      return formItem?.controlFormat == ControlFormat.LISTDATA.name
          ? FutureBuilder<DynamicResponse?>(
              future: getDynamicLabel(context, formItem, moduleItem!),
              builder: (BuildContext context,
                  AsyncSnapshot<DynamicResponse?> snapshot) {
                Widget child = Text(formItem?.controlText ?? "");
                if (snapshot.hasData) {
                  var dynamicResponse = snapshot.data;
                  DynamicPostCall.processDynamicResponse(
                      dynamicResponse!.dynamicData!,
                      context,
                      formItem?.controlId);

                  child = DynamicTextViewWidget(
                          jsonText: dynamicResponse.dynamicList)
                      .render();
                }
                return child;
              })
          : Text(
              formItem?.controlText ?? "",
              style: const TextStyle(fontSize: 16),
            );
    });
  }
}

class DynamicTextViewWidget implements IFormWidget {
  List<dynamic>? jsonText;
  List<LinkedHashMap> mapItems = [];

  DynamicTextViewWidget({
    Key? key,
    this.jsonText,
  });

  @override
  Widget render() {
    jsonText?.forEach((item) {
      mapItems.add(item);
    });

    return mapItems.isNotEmpty
        ? Builder(builder: (BuildContext context) {
            return Column(children: [
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: mapItems.length,
                itemBuilder: (context, index) {
                  var mapItem = mapItems[index];
                  mapItem.removeWhere((key, value) =>
                      key == null || value == null || value == "");

                  return Material(
                      elevation: 1,
                      borderRadius:
                          const BorderRadius.all(Radius.circular(8.0)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12.0, vertical: 8.0),
                        child: Column(
                          children: mapItem
                              .map((key, value) => MapEntry(
                                  key,
                                  Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "$key:",
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium,
                                          ),
                                          Flexible(
                                              child: Text(
                                            value.toString(),
                                            textAlign: TextAlign.right,
                                            style: const TextStyle(
                                                fontFamily: "Roboto"),
                                          ))
                                        ],
                                      ))))
                              .values
                              .toList(),
                        ),
                      ));
                },
              ),
              const SizedBox(
                height: 18,
              )
            ]);
          })
        : const SizedBox();
  }
}

class DynamicQRScanner implements IFormWidget {
  @override
  Widget render() {
    return Builder(builder: (BuildContext context) {
      var formItem = BaseFormInheritedComponent.of(context)?.formItem;
      var moduleItem = BaseFormInheritedComponent.of(context)?.moduleItem;
      return Column(
        children: [
          const SizedBox(
            height: 24,
          ),
          InkWell(
            onTap: () {
              context.navigate(QRScanner(
                moduleItem: moduleItem!,
                formItem: formItem!,
                context: context,
              ));
            },
            child: Image.asset(
              "packages/craft_dynamic/assets/images/qr-code.png",
              width: 200,
              height: 200,
            ),
          ),
          const SizedBox(
            height: 12,
          ),
          Text(
            "QR Code quick scan",
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(
            height: 12,
          ),
          const Text("Tap on the above image to start scanning"),
          const SizedBox(
            height: 44,
          ),
          Consumer<PluginState>(
            builder: (context, state, child) =>
                state.scanvalidationloading ? LoadUtil() : const SizedBox(),
          )
        ],
      );
    });
  }
}

class DynamicPhonePickerFormWidget extends StatefulWidget
    implements IFormWidget {
  const DynamicPhonePickerFormWidget({super.key});

  @override
  State<DynamicPhonePickerFormWidget> createState() =>
      _DynamicPhonePickerFormWidgetState();

  @override
  Widget render() {
    return const DynamicPhonePickerFormWidget();
  }
}

class _DynamicPhonePickerFormWidgetState
    extends State<DynamicPhonePickerFormWidget> {
  String? code;

  var controller = TextEditingController();
  String initialCountry = 'ET';
  PhoneNumber inputNumber = PhoneNumber(isoCode: 'ET');

  @override
  Widget build(BuildContext context) {
    var formItem = BaseFormInheritedComponent.of(context)?.formItem;

    return InternationalPhoneNumberInput(
      onInputChanged: (PhoneNumber number) {
        inputNumber = number;
      },
      selectorConfig: const SelectorConfig(
          selectorType: PhoneInputSelectorType.DIALOG,
          setSelectorButtonAsPrefixIcon: true,
          leadingPadding: 14),
      ignoreBlank: false,
      autoValidateMode: AutovalidateMode.disabled,
      initialValue: inputNumber,
      textFieldController: controller,
      inputDecoration: InputDecoration(labelText: formItem?.controlText),
      validator: (value) {
        var input = value?.replaceAll(" ", "");
        if (input?.length != 9) {
          return "Invalid mobile";
        } else if (input == "") {
          return "Enter your mobile";
        } else {
          Provider.of<PluginState>(context, listen: false).addFormInput({
            "${formItem?.serviceParamId}":
                inputNumber.phoneNumber?.replaceAll("+", "")
          });
        }
      },
    );
  }
}

class DynamicListWidget implements IFormWidget {
  final _dynamicRequest = DynamicFormRequest();
  DynamicResponse? dynamicResponse;
  FormItem? formItem, inheritedFormItem;
  ModuleItem? moduleItem, inheritedModuleItem;

  DynamicListWidget({this.moduleItem, this.formItem});

  getDynamicList(context, formItem, module) => _dynamicRequest.dynamicRequest(
        module,
        formItem: formItem,
        dataObj:
            Provider.of<PluginState>(context, listen: false).formInputValues,
        encryptedField:
            Provider.of<PluginState>(context, listen: false).encryptedFields,
        isList: true,
        context: context,
      );

  @override
  Widget render() {
    return Builder(builder: (BuildContext context) {
      inheritedFormItem = BaseFormInheritedComponent.of(context)?.formItem;
      inheritedModuleItem = BaseFormInheritedComponent.of(context)?.moduleItem;

      Provider.of<PluginState>(context, listen: false).addFormInput({
        RequestParam.HEADER.name:
            inheritedFormItem?.actionId ?? formItem?.actionId
      });

      return isEmptyList()
          ? const Center(
              child: Text("Nothing was found!"),
            )
          : FutureBuilder<DynamicResponse?>(
              future: getDynamicList(
                  context, formItem, inheritedModuleItem ?? moduleItem),
              builder: (BuildContext context,
                  AsyncSnapshot<DynamicResponse?> snapshot) {
                Widget child = Center(
                  child: LoadUtil(),
                );
                if (snapshot.hasData) {
                  dynamicResponse = snapshot.data;
                  // DynamicPostCall.processDynamicResponse(
                  //     dynamicResponse?.dynamicData,
                  //     context,
                  //     formItem?.controlId);

                  child = ListWidget(
                    dynamicList: dynamicResponse?.dynamicList,
                    scrollable: false,
                    controlID: formItem?.controlId,
                    moduleItem: moduleItem,
                    serviceParamID: formItem?.serviceParamId,
                  );
                }
                return child;
              });
    });
  }

  bool isEmptyList() {
    if (formItem?.controlFormat != null &&
            formItem!.controlFormat!.isNotEmpty ||
        formItem?.actionId == null ||
        formItem?.actionId == "") {
      return false;
    }
    return true;
  }
}

class DynamicHyperLink implements IFormWidget {
  @override
  Widget render() {
    return Builder(builder: (BuildContext context) {
      var formItem = BaseFormInheritedComponent.of(context)?.formItem;
      if (formItem?.controlValue != null) {
        CommonUtils.openUrl(Uri.parse(formItem!.controlValue!));
        Navigator.pop(context);
      }
      return const Visibility(visible: false, child: SizedBox());
    });
  }
}

class DynamicImageUpload extends StatefulWidget implements IFormWidget {
  const DynamicImageUpload({super.key});

  @override
  State<DynamicImageUpload> createState() => _DynamicImageUpload();

  @override
  Widget render() {
    return const DynamicImageUpload();
  }
}

class _DynamicImageUpload extends State<DynamicImageUpload> {
  String? imageFile;
  FormItem? formItem;
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    formItem = BaseFormInheritedComponent.of(context)?.formItem;

    return FutureBuilder<List<CameraDescription>>(
        future: availableCameras(),
        // a previously-obtained Future<String> or null
        builder: (BuildContext context,
            AsyncSnapshot<List<CameraDescription>> snapshot) {
          Widget child = const SizedBox();
          if (snapshot.hasData) {
            child = InkWell(
                borderRadius: BorderRadius.circular(8.0),
                onTap: () async {
                  final XFile? photo =
                      await _picker.pickImage(source: ImageSource.camera);
                  setState(() {
                    imageFile = photo?.path;
                  });
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      formItem!.controlText!,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8.0)),
                      width: double.infinity,
                      height: 177,
                      child: imageFile == null
                          ? const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                  Icon(
                                    Icons.add_a_photo,
                                    size: 34,
                                    color: Colors.blueGrey,
                                  ),
                                  SizedBox(
                                    height: 8.0,
                                  ),
                                  Text("Tap to take picture")
                                ])
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Image.file(
                                File(imageFile!),
                                fit: BoxFit.fitWidth,
                              )),
                    )
                  ],
                ));
          }
          return child;
        });
  }
}

class DynamicLinkedContainer extends StatefulWidget implements IFormWidget {
  const DynamicLinkedContainer({super.key});

  @override
  State<StatefulWidget> createState() => _DynamicLinkedContainerState();

  @override
  Widget render() {
    return const DynamicLinkedContainer();
  }
}

class _DynamicLinkedContainerState extends State<DynamicLinkedContainer> {
  String? controlFormat;
  List<String> buttons = [];
  List<Widget> widgets = [];
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var formItem = BaseFormInheritedComponent.of(context)?.formItem;
    var formItems = BaseFormInheritedComponent.of(context)?.formItems;

    if (formItem?.controlFormat == ControlFormat.HorizontalScroll.name) {
      for (var item in formItems!) {
        if (item.controlType == ViewType.SELECTEDTEXT.name) {
          buttons.add(item.controlText!);
        }
        if (item.controlType == ViewType.TEXT.name) {
          widgets.add(const SizedBox(
            height: 15,
          ));
          widgets.add(Consumer<GroupButtonModel>(
              builder: (context, selectedItem, child) {
            _controller.text = selectedItem.selectedItem;
            return WidgetFactory.buildTextField(
                context,
                TextFormFieldProperties(
                    controller: _controller,
                    textInputType: TextInputType.name,
                    inputDecoration:
                        InputDecoration(hintText: formItem?.controlText)),
                (string) {
              Provider.of<PluginState>(context, listen: false).addFormInput(
                  {"${formItem?.serviceParamId}": _controller.text});
              // Provider.of<PluginState>(context, listen: false).formInputValues
              //     .add({"${formItem?.serviceParamId}": _controller.text});
              return null;
            });
          }));
          widgets.add(const SizedBox(
            height: 8,
          ));
        }
      }
    }
    if (buttons.isNotEmpty) {
      widgets.add(GroupButtonWidget(
        buttons: buttons,
      ));
    }
    widgets = widgets.reversed.toList();
    return ChangeNotifierProvider(
        create: (context) => GroupButtonModel(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: widgets,
        ));
  }
}

class DynamicCheckBox extends StatefulWidget implements IFormWidget {
  const DynamicCheckBox({super.key});

  @override
  State<StatefulWidget> createState() => _DynamicCheckBoxState();

  @override
  Widget render() => const DynamicCheckBox();
}

class _DynamicCheckBoxState extends State<DynamicCheckBox> {
  FormItem? formItem;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    formItem = BaseFormInheritedComponent.of(context)?.formItem;
    return CheckboxFormField(
        title: Text(formItem?.controlText ?? ""),
        validator: (value) {
          validate(value);
        });
  }

  validate(value) {
    Provider.of<PluginState>(context, listen: false)
        .addFormInput({"${formItem?.serviceParamId}": "$value"});
  }
}

class CheckboxFormField extends FormField<bool> {
  CheckboxFormField(
      {super.key,
      required Widget title,
      required FormFieldValidator<bool> validator,
      bool initialValue = false,
      bool autovalidate = false})
      : super(
            validator: validator,
            initialValue: initialValue,
            builder: (FormFieldState<bool> state) {
              return CheckboxListTile(
                dense: state.hasError,
                title: title,
                value: state.value,
                onChanged: state.didChange,
                controlAffinity: ListTileControlAffinity.platform,
              );
            });
}

class DynamicHorizontalText extends StatefulWidget implements IFormWidget {
  const DynamicHorizontalText({super.key, required this.input});

  final Map<String?, dynamic> input;

  @override
  State<StatefulWidget> createState() => _DynamicHorizontalText();

  @override
  Widget render() => DynamicHorizontalText(
        input: input,
      );
}

class _DynamicHorizontalText extends State<DynamicHorizontalText> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var formItem = BaseFormInheritedComponent.of(context)?.formItem;
    var formInput = widget.input[formItem?.controlId];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(formItem?.controlText ?? ""),
        Text(
          formInput ?? "****",
          style: const TextStyle(fontWeight: FontWeight.bold),
          textAlign: TextAlign.start,
        )
      ],
    );
  }
}

class TextLink extends StatefulWidget implements IFormWidget {
  const TextLink({super.key});

  @override
  State<TextLink> createState() => _TextLinkState();

  @override
  Widget render() => const TextLink();
}

class _TextLinkState extends State<TextLink> {
  final _api = APIService();

  @override
  Widget build(BuildContext context) {
    var moduleItem = BaseFormInheritedComponent.of(context)?.moduleItem;
    var formItem = BaseFormInheritedComponent.of(context)?.formItem;

    return FutureBuilder<DynamicResponse?>(
        future: _api.getDynamicLink(formItem?.actionId ?? "", moduleItem!),
        builder:
            (BuildContext context, AsyncSnapshot<DynamicResponse?> snapshot) {
          Widget child = TextButton(
              onPressed: () {
                CommonUtils.openUrl(Uri.parse(formItem?.controlValue ?? ""));
              },
              child: Text(formItem?.controlText ?? "Link"));
          if (snapshot.hasData) {
            return Align(
                alignment: Alignment.centerLeft,
                child: TextButton(
                    onPressed: () {
                      CommonUtils.openUrl(
                          Uri.parse(snapshot.data?.otherText ?? ""));
                    },
                    child: Text(formItem?.controlText ?? "Link")));
          }
          return child;
        });
  }
}

class NullWidget implements IFormWidget {
  @override
  Widget render() {
    return const Visibility(
      visible: false,
      child: SizedBox(),
    );
  }
}
