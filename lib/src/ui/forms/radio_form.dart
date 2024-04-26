// ignore_for_file: must_be_immutable

import 'package:craft_dynamic/src/ui/dynamic_static/list_data.dart';
import 'package:flutter/material.dart';

import 'package:craft_dynamic/craft_dynamic.dart';
import 'package:craft_dynamic/src/util/widget_util.dart';
import 'package:provider/provider.dart';

class RadioWidget extends StatefulWidget {
  List<FormItem> formItems;
  String title;
  ModuleItem moduleItem;
  Function? updateState;

  RadioWidget(
      {super.key,
        required this.title,
        required this.formItems,
        required this.moduleItem,
        this.updateState});

  @override
  State<RadioWidget> createState() => _RadioWidgetState();
}

class _RadioWidgetState extends State<RadioWidget> {
  FormItem? recentList;
  List<FormItem> radioFormControls = [];

  @override
  void initState() {
    radioFormControls = widget.formItems;
    try {
      recentList = radioFormControls.firstWhere(
            (item) => item.controlType == ViewType.LIST.name,
      );
    } catch (e) {
      AppLogger.appLogE(tag: "recent list error", message: e.toString());
    }
    radioFormControls
        .removeWhere((formItem) => formItem.controlType == ViewType.LIST.name);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
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
                            )),
                        Container(width: 25),
                      ],
                    ),
                  )),
            ),
            Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  color: const Color.fromARGB(255, 219, 220, 221),
                  child: RadioWidgetList(
                    formItems: radioFormControls,
                    moduleItem: widget.moduleItem,),
                )
            )
          ],
        ));
  }

  @override
  void dispose() {
    super.dispose();
  }
}

class RadioWidgetList extends StatefulWidget {
  final List<FormItem> formItems;
  ModuleItem moduleItem;

  RadioWidgetList(
      {super.key, required this.formItems, required this.moduleItem});

  @override
  State<RadioWidgetList> createState() => _RadioWidgetListState();
}

class _RadioWidgetListState extends State<RadioWidgetList> {
  final _formKey = GlobalKey<FormState>();
  List<FormItem> sortedForms = [];
  List<Widget> chips = [];
  List<FormItem> chipChoices = [];
  List<FormItem> rButtonForms = [];
  int? _value = 0;

  @override
  void initState() {
    super.initState();
  }

  List<FormItem> getRButtons() => widget.formItems
      .where((formItem) => formItem.controlType == ViewType.RBUTTON.name)
      .toList();

  addChips(List<FormItem> formItems) {
    chips.clear();
    chipChoices.clear();
    formItems.asMap().forEach((index, formItem) {
      chipChoices.add(formItem);
      chips.add(Expanded(
          flex: 1,
          child: Container(
              margin: const EdgeInsets.only(right: 2),
              child: ChoiceChip(
                side: _value == index
                    ? null
                    : BorderSide(
                    color: Theme.of(context).primaryColor.withOpacity(.4)),
                labelStyle: TextStyle(
                  overflow: TextOverflow.ellipsis,
                  color: _value == index
                      ? Colors.white
                      : APIService.appSecondaryColor,
                ),
                label: SizedBox(
                  width: double.infinity,
                  child: Text(formItem.controlText ?? ""),
                ),
                selected: _value == index,
                onSelected: (bool selected) {
                  if (_value != index) {
                    setState(() {
                      _value = selected ? index : null;
                    });
                  }
                },
              ))));
    });
  }

  getRButtonForms(FormItem formItem) {
    sortedForms.clear();
    rButtonForms.clear();
    rButtonForms = widget.formItems
        .where((element) =>
    element.linkedToControl == formItem.controlId ||
        element.linkedToControl == "" ||
        element.linkedToControl == null)
        .toList();

    rButtonForms
        .removeWhere((element) => element.controlType == ViewType.LIST.name);
    sortedForms = WidgetUtil.sortForms(rButtonForms);
  }

  @override
  Widget build(BuildContext context) {
    addChips(getRButtons());
    getRButtonForms(chipChoices[_value ?? 0]);

    return WillPopScope(
        onWillPop: () async {
          Provider.of<PluginState>(context, listen: false)
              .setRequestState(false);
          return true;
        },
        child: SizedBox(
            height: double.infinity,
            child: SingleChildScrollView(
                child: Column(mainAxisSize: MainAxisSize.max, children: [
                  const SizedBox(
                    height: 12,
                  ),
                  Padding(
                      padding: const EdgeInsets.only(left: 18, right: 18, top: 8),
                      child: Align(
                          child: Row(
                            children: chips,
                          ))),
                  const SizedBox(
                    height: 18,
                  ),
                  Form(
                      key: _formKey,
                      child: ListView.builder(
                          shrinkWrap: true,
                          padding:
                          const EdgeInsets.only(left: 14, right: 14, top: 8),
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: sortedForms.length,
                          itemBuilder: (context, index) {
                            return BaseFormComponent(
                                formItem: sortedForms[index],
                                moduleItem: widget.moduleItem,
                                formKey: _formKey,
                                formItems: sortedForms,
                                child: IFormWidget(
                                  sortedForms[index],
                                ).render());
                          }))
                ]))));
  }
}
